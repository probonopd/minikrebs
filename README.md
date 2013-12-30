Minikrebs: A Customized OpenWRT image generator
==================================

Original Documentation: http://shackspace.de/wiki/doku.php?id=project:minikrebs 

Contact
------
If you want to know more about the project and how to use it, go to
irc://freenode.org to #krebs or contact @makefoo on twitter.


Example Usage
=======
Build instacam webcam server
------------------------

    # grab repository
    git clone https://github.com/krebscode/minikrebs && cd minikrebs
    # get everything ready for instacam
    # this may need some time run initially
    ./prepare instacam 
    # PLATFORM=TLMR3020 ./prepare instacam # for a MR3020 based image

    # build the image
    builder/init 
    # flash the device, either copy the sysupgrade image (from output before)
    # to the device or use the upgrade script (ssh must be available)
    ./upgrade <ip-of-device>
    

Build image that contains a webradio client
-------------------------------------------
Build A webradio client based on probonopd@github's code

    # If you want to build for a device other than the TP-LINK TL-WR703N, do:
    export PLATFORM=DIR505A1 # for D-Link DIR-505
    # Get ready
    ./prepare radio
    # Build the firmware image
    ./builder/init
    # Flash to the device - this asks for the root password of the device twice, then reboots
    # Note: OpenWRT must already be running on the device
    ./upgrade 192.168.0.19 # replace with the IP address of the device

The device will get an IP address via DHCP on wired Ethernet, and default password is "minikrebs".

### Setting up WLAN client mode

* Wifi: Scan, Join Network, Create / Assign firewall-zone: select lan (green)! (this is no longer needed since the firewall packet is no longer installed), Submit, Save and apply
* Interfaces -> WWAN -> Advanced settings -> Override MAC address: Has the WRONG IP, so set IP+1, Save and apply
* Interfaces: Both LAN and WWAN should be green now and both should have an IP address
* HTML interface should be reachable on both addresses

If you have totally mis-configured the network and can't get in anymore, use "OpenWRT Failsafe" (using an Ethernet cable and the reset button)

### Setting up radio stations and remote control codes
* http://192.168.0.19/cgi-bin/luci/admin/radio/stations
* http://192.168.0.19/cgi-bin/luci/admin/radio/remote (this is for a 3.3V 16MHz Arduino to be hooked up to the router)


LICENSE
======
All code written around the original OpenWRT Image generator
(traits,libs,gluecode) is licensed under the WTFPL, see COPYING
