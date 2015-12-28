# Customized OpenWrt image generator [![Build Status](https://travis-ci.org/probonopd/minikrebs.svg?branch=master)](https://travis-ci.org/probonopd/minikrebs)

This is a customized OpenWrt firmware image generator based on http://shackspace.de/wiki/doku.php?id=project:minikrebs 

You can download some of the generated firmware images from this [Bintray repository](https://bintray.com/probono/OpenWrt).

__CAUTION:__ These images are entirely __untested__ and you are running them on __your own risk__. You might brick your device, so if you do not know how to debrick your device e.g., using a serial console, don't use these images.

## Profiles

### Radio

Builds an image that contains a web radio and podcast client.

You can use this firmware image generator to produce a firmware that does the following:
- Play web radio streams
- Play podcasts
- Connect wired ethernet or wireless LAN
- Use station IDs/jingles or spoken announcements to identify the radio stream
- Flip through predefined channels and podcasts using a regular infrared remote control
- Use an HTML interface to control the player from any computer or mobile device in the household
- Search for and play MP3 music files on the Internet
- Search for and play radio stations and podcasts 
- Discover radio stations and podcasts using a server-based repository of radio stations and podcasts
- Find and play podcast episodes
- Sleep timer
- Optionally, send infrared remote control codes to other devices, e.g. an amplifier

```
# If you want to build for a device other than the TP-LINK TL-WR703N, do:
export PLATFORM=DIR505A1 # for D-Link DIR-505
export PLATFORM=TLWR710 # for TP-LINK TL-WR710N
# Get ready
./prepare radio
# Build the firmware image
./builder/init
# Flash to the device - either using the OEM's web interface 
# or using the script below if the router is already running OpenWrt - 
# this asks for the root password of the device twice, then reboots
# Note: OpenWrt must already be running on the device for this to work
./upgrade 192.168.0.19 # replace with the IP address of the device
```

For more information see doc/radio.md

### Captive

A captive portal.
To be written

### Netem

A worst-case network simulator.
To be written

## Supported hardware

### TP-Link TL-WR703N

![TP-Link TL-WR703N](https://cloud.githubusercontent.com/assets/2480569/12024482/afdb60bc-ada4-11e5-858f-c083eb205571.jpg)

To be written

### TP-Link TL-WR710N

To be written

### D-Link DIR-505 Mobile Companion

![D-Link DIR-505 Mobile Companion](https://cloud.githubusercontent.com/assets/2480569/5601325/4f1c2a26-92f8-11e4-846a-ef47d5c96ae3.jpeg)

To be written

### Unbranded A5-V11 (7 EUR router)

![Unbranded A5-V11](https://cloud.githubusercontent.com/assets/2480569/5695474/788bbd18-99a6-11e4-83d8-e110ed81cbe8.jpg)

This [whitelabel A5-V11 Ralink/Mediatek RT5350F-based router](http://wiki.openwrt.org/toh/unbranded/a5-v11) is sold on eBay from Chinese sellers for around 8 USD (shipped) as of January 2015, which is around a third of the TL-WR703N. It has a white housing with silver print "3G/4G Router 150M". On the PCB it says "A5-V11". On the PCB it has a W9825G6EH-75 RAM (32 MB) RAM chip and 4 MB SPI ROM. Ethernet MAC address starts with 2C:67:FB:. As of OpenWrt trunk r43793 it is supported by the Image Generator. The factory image can successfully be flashed from the stock firmware GUI without having to open the device or mess with uboot manually.

__CAUTION: This device uses eth0.1 rather than eth0 or eth1, so be aware of that in order for the wired Ethernet to work. You need to change /etc/configuration/network accordingly or the device will not be accessible after flashing without using a serial adapter to unbrick (or possibly OpenWrt Failsafe).__

To build for this device, move or remove any pre-existing builder/ directory, and change the IMAGEBUILDER_URL so that it points to a "trunk/ramips/generic" ImageBuilder URL like `IMAGEBUILDER_URL="https://downloads.openwrt.org/snapshots/trunk/ramips/generic/OpenWrt-ImageBuilder-ramips_rt305x-for-linux-x86_64.tar.bz2"`.

Now you can build for this platform like so:
```
export PLATFORM=A5-V11 
./prepare radio
./builder/init
```

Before flashing, make sure that /etc/config/network looks like this (note the eth0.1):
```
config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'
 
config interface 'lan0'
        option ifname 'eth0.1'
        option proto 'dhcp'
```
