#! /bin/sh
get_ifnames_for_phy () {
  itf=$1
  uci show network | grep ifname | grep "'$itf'" \
    | cut -d. -f 2| while read ifname; do
    echo $ifname
  done
}
clear_interface_config (){
  # TODO: maybe just remove the interface from the configured networks?
  # itf: the real,physical interface
  itf="${1?must provide interface to clear config for}"
  get_ifnames_for_phy $itf | while read ifname; do
    uci delete network.$ifname
    # TODO: maybe clear_dhcp_config $ifname
    # TODO: maybe clear_firewall_zone
    # returns the original luci interface name
    echo $ifname
  done
}

clear_dhcp_config() {
    ifname=$1
    # the network interface name
    uci show dhcp | grep interface | grep "'$ifname'" \
      | cut -d. -f 2 | while read dhcpname; do
      uci delete "dhcp.$dhcpname" || :
    done
}

clear_firewall_zone() {
  # use the ifname which gets returned for clear_interface_config
  # normally we do not need to remove configured zones
  ifname=$1
  uci show firewall | grep zone | grep network= \
    | grep $ifname | cut -d. -f 2 | while read zone;do
    zonename=$(uci get firewall.${zone}.name)
    uci show firewall | egrep '(src|dest)' | grep $zonename \
      | cut -d. -f 1 | while read rule; do
      uci delete firewall.${rule}
    done
  done
}
