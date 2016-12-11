# Customized OpenWrt image generator [![Build Status](https://travis-ci.org/krebscode/minikrebs.svg?branch=master)](https://travis-ci.org/krebscode/minikrebs)

This is a customized OpenWrt firmware image generator based on http://shackspace.de/wiki/doku.php?id=project:minikrebs

You can download some of the generated firmware images from this [Bintray repository](https://bintray.com/krebscode/minikrebs).

__CAUTION:__ These images are entirely __untested__ and you are running them on __your own risk__. You might brick your device, so if you do not know how to debrick your device e.g., using a serial console, don't use these images.


## Profiles

### Tor Router

Creates a router which transparently forwards tcp traffic from one interface to
another.

* **tor-router-dual-eth**: route between two network interfaces

```
IMAGEBUILDER_URL='https://downloads.openwrt.org/chaos_calmer/15.05/x86/64/OpenWrt-ImageBuilder-15.05-x86-64.Linux-x86_64.tar.bz2'
PLATFORM=''
./prepare tor-router-dual-eth
builder/init
```

* **tor-router-glinet**: route between from wifi to ethernet for glinet routers

```
PLATFORM='GLINET'
IMAGEBUILDER_URL='https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/OpenWrt-ImageBuilder-15.05-ar71xx-generic.Linux-x86_64.tar.bz2'
./prepare tor-router-glinet
builder/init
```

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

# Overlay
## How it works
Overlaying the rootfs with an usb stick provides your mini computer with a lot
of free disk space. Minikrebs provides means to prepare an overlay and
automatically install packages on first boot with the following traits:

  * *usb/root_overlay/*
  * *usb/root_overlay/install_overlay_packages/*

Include these traits in your profile and an overlay filesystem will be used on
bootup. The source code is very short so be sure to read it :)

Other traits then can use `OVERLAY_PACKAGES` in their manifest to
install packages which normally would be too big.


## Overlay Init
For initialization the following steps must be performed:

```
cfdisk /dev/sdx # create a single partition
mkfs.vfat /dev/sdx1 # prepare a file system which is supported for the overlay
./prepare profile-with-overlay
# builder/overlay_packages will be filled by the traits by utilizing 
mkdir -p builder/mnt/overlay
mount /dev/sdx1 builder/mnt/overlay
./builder/init_overlay # copies packages from overlay_packages, also copies
                       # files from ./builder/overlay to ./builder/mnt/overlay
# builder/mnt/overlay will be unmounted after successful init
./builder/init
```

## Caveats for Overlaying
Please be aware that the overlay initialization is pretty much entirely
untested - **it worked 3 years ago for me, nothing more, nothing less**.

My focus shifted a bit from 4mb flash routers to routers with enough disk 
space (16m).
