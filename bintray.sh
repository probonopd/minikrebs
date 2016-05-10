#!/bin/bash

# Push firmware images and related metadata to Bintray
# https://bintray.com/docs/api/

trap 'exit 1' ERR

API=https://api.bintray.com

if [ -z "TRAIT" ]; then
    echo "Need to set TRAIT"
    exit 1
fi
TRAIT_URL="https://github.com/krebscode/minikrebs/tree/master/"$(find traits/ -name "$TRAIT" -type d)
echo "$TRAIT_URL"

DESCRIPTION="$(cat "profiles/$TRAIT" | python -c 'import json,sys; print json.dumps(sys.stdin.read())')"
echo "$DESCRIPTION"
FILE=$1
[ -f "$FILE" ] || exit 1

BINTRAY_USER="makefu"
BINTRAY_SUBJECT="krebscode"
BINTRAY_API_KEY=$BINTRAY_API_KEY # env
BINTRAY_REPO="minikrebs"
PCK_NAME=$TRAIT
WEBSITE_URL="$TRAIT_URL"
ISSUE_TRACKER_URL="https://github.com/krebscode/minikrebs/issues"
VCS_URL="https://github.com/krebscode/minikrebs.git" # Mandatory for packages in free Bintray repos

which curl || exit 1
which grep || exit 1

if [ ! $(env | grep BINTRAY_API_KEY ) ] ; then
  echo "Environment variable \$BINTRAY_API_KEY missing"
  exit 1
fi

# Do not upload artefacts generated as part of a pull request
if [ $(env | grep TRAVIS_PULL_REQUEST ) ] ; then
  if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then
    echo "Not uploading since this is a pull request"
    exit 0
  fi
fi

CURL="curl -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H Content-Type:application/json -H Accept:application/json"

VERSION=$(cat ./builder/build_dir/target-*/root-*/etc/banner | grep "(" | cut -d "(" -f 2 | cut -d ")" -f 1 | sed -e 's/, /./g')
# VERSION=$(git rev-list --count HEAD).$(git log -n 1 | head -n 1 | sed -e 's/^commit //' | head -c 8)

if [ "$VERSION" == "" ] ; then
  echo "* VERSION missing, exiting"
  exit 1
else
  echo "* VERSION $VERSION"
fi

# exit 0
##########

echo ""
echo "Creating package ${PCK_NAME}..."
    data="{
    \"name\": \"${PCK_NAME}\",
    \"desc\": ${DESCRIPTION},
    \"desc_url\": \"auto\",
    \"website_url\": [\"${WEBSITE_URL}\"],
    \"vcs_url\": [\"${VCS_URL}\"],
    \"issue_tracker_url\": [\"${ISSUE_TRACKER_URL}\"],
    \"licenses\": [\"MIT\"],
    \"labels\": [\"AppImage\", \"AppImageKit\"]
    }"
${CURL} -X POST -d "${data}" ${API}/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO}

echo ""
echo "Uploading and publishing ${FILE}..."
${CURL} -T ${FILE} "${API}/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO}/${PCK_NAME}/${VERSION}/$(basename ${FILE})?publish=1&override=1"

if [ $(env | grep TRAVIS_JOB_ID ) ] ; then
echo ""
echo "Adding Travis CI log to release notes..."
BUILD_LOG="https://api.travis-ci.org/jobs/${TRAVIS_JOB_ID}/log.txt?deansi=true"
    data='{
  "bintray": {
    "syntax": "markdown",
    "content": "'${BUILD_LOG}'"
  }
}'
${CURL} -X POST -d "${data}" ${API}/packages/${BINTRAY_SUBJECT}/${BINTRAY_REPO}/${PCK_NAME}/versions/${VERSION}/release_notes
fi

