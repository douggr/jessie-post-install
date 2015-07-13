## tl;dr;
  - Install a clean [Debian](https://debian.org) jessie copy
  - Install `git` and `ca-certificates` with
    `$ apt-get install git ca-certificates --no-install-recommends`
  - clone `git clone https://github.com/douggr/jessie-post-install` or
    [download](https://github.com/douggr/jessie-post-install/archive/master.zip)
    this repository
  - If you'd choose to download instead of cloning you'll need to install
    `unzip` with `$ apt-get install unzip --no-install-recommends`
    - unzip it `unzip master.zip`
  - cd to the new directory
  - execute `./install.sh` and reboot your system

## Notes
  - This will add `--no-install-recommends` to your apt preferences
  - *This program will overwrite your sources.list*
  - Two new repositories will be added:
    - deb-multimedia.org
     (see [etc/sources.list.d/deb-multimedia.list](http://git.io/vmvUt))
    - ppa.launchpad.net
     (see [etc/sources.list.d/webupd8team-java.list](http://git.io/vmvUs))
  - Optionally you can add a minimal Xorg install with
    - Xfce 4.12 from *testing* with few plugins (*stable* provides 4.10)
    - Slim (desktop-independent graphical login manager for X11)
  - There are options to install the following packages:
    - Oracle Java binaries
    - VirtualBox
    - Google Chrome (over Chromium)

## Packages
*Descriptions taken using: `$ dpkg-query -l $package | cut -c45-` and a
very little clean up*

In the case you don't want any package, just comment it (with `#`) in
`packages/*`.

**This program will install the following base packages:**

### Base System
 - **bash-completion:** programmable completion for the bash shell
 - **bzip2:** high-quality block-sorting file compressor - utilities
 - **ca-certificates:** Common CA certificates
 - **curl:** command line tool for transferring data with URL syntax
 - **docker.io:** Linux container runtime
 - **firmware-linux-nonfree:** Binary firmware for various drivers in the Linux kernel
 - **firmware-realtek:** Binary firmware for Realtek wired and wireless network adapters
 - **git:** fast, scalable, distributed revision control system
 - **gnupg-agent:** GNU privacy guard - password agent
 - **ntfs-3g:** read/write NTFS driver for FUSE
 - **openssh-server:** secure shell (SSH) server, for secure access from remote machines
 - **patch:** Apply a diff file to an original
 - **policykit-1:** framework for managing administrative policies and privileges
 - **secure-delete:** tools to wipe files, free disk space, swap and memory
 - **subversion:** Advanced version control system
 - **tlp:** Save battery power on laptops
 - **unzip:** De-archiver for .zip files
 - **usbmount:** automatically mount and unmount USB mass storage devices
 - **xz-utils:** XZ-format compression utilities

### Desktop (optional)
 - **alsa-utils:** Utilities for configuring and using ALSA
 - **dmz-cursor-theme:** Style neutral, scalable cursor theme
 - **faenza-icon-theme:** Faenza icon theme
 - **gconf2:** GNOME configuration database system (support tools)
 - **gtk2-engines-murrine:** cairo-based gtk+-2.0 theme engine
 - **gtk2-engines-pixbuf:** pixbuf-based theme for GTK+ 2.x
 - **gtk2-engines-xfce:** GTK+-2.0 theme engine for Xfce
 - **gvfs-bin:** userspace virtual filesystem - binaries
 - **iceweasel:** Web browser based on Firefox
 - **libappindicator1:** allow applications to export a menu into the panel
 - **libgl1-mesa-dri:** free implementation of the OpenGL API -- DRI modules
 - **mousepad:** simple Xfce oriented text editor
 - **ristretto:** lightweight picture-viewer for the Xfce desktop environment
 - **slim:** desktop-independent graphical login manager for X11
 - **thunar:** File Manager for Xfce
 - **xfce4-appfinder:** Application finder for the Xfce4 Desktop Environment
 - **xfce4-datetime-plugin:** date and time plugin for the Xfce4 panel
 - **xfce4-mixer:** Xfce mixer application
 - **xfce4-notifyd:** simple, visually-appealing notification daemon for Xfce
 - **xfce4-panel:** panel for Xfce4 desktop environment
 - **xfce4-power-manager:** power manager for Xfce desktop
 - **xfce4-screenshooter:** screenshots utility for Xfce
 - **xfce4-session:** Xfce4 Session Manager
 - **xfce4-terminal:** Xfce terminal emulator
 - **xfce4-volumed:** volume keys daemon
 - **xfdesktop4:** xfce desktop background, icons and root menu manager
 - **xfwm4:** window manager of the Xfce project
 - **xserver-xorg-core:**   Xorg X server - core server
 - **xserver-xorg-input-all:** input driver metapackage
 - **xserver-xorg-video-ati:** AMD/ATI display driver wrapper
 - **xserver-xorg-video-intel:** Intel i8xx, i9xx display driver
