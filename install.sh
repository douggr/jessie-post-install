#!/bin/sh
# coding: utf-8
#
## INSTALL-SYSTEM -- Command for upgrading and sanitizing a clean Debian system.
#
## HOMEPAGE
#  https://github.com/douggr/jessie-post-install
#
## AUTHORS
#  Douglas Gontijo <https://github.com/douggr>
#
## LICENSE
#  MIT <http://www.opensource.org/licenses/MIT>
#
## REQUIRES
#  root
#
## DEPENDENCIES
#  apt
#  lsb
#  dpkg
#  git
#  ca-certificates
#
## CHANGES
#  2015-07-11   Initial release.                v0.1 [DG]
##

## Insert eventual localisation here
DISPLAY=
LANGUAGE=en
LC_ALL=C.UTF-8
export DISPLAY LANGUAGE LC_ALL

## Get lsb functions
. /lib/lsb/init-functions

## Requires `root`
if [ "$(id -u)" != "0" ]; then
	log_failure_msg "Must be run as root"
	exit 1
fi

## Check required package
package_check_install () {
  log_begin_msg "Checking for $1 "
  dpkg-query -W -f='${Version}' $1 2>/dev/null
}

log_action_msg "Checking for required packages"

for PKGNAME in git ca-certificates dpkg apt; do
  if package_check_install $PKGNAME; then
    log_success_msg
  else
    log_failure_msg
    exit 1
  fi
done

ask () {
  log_begin_msg "$@ [y/n]? "
  read CONFIRM
}

bail () {
  log_failure_msg && exit 1
}

## (command, message)
run_command () {
  eval $1 && log_success_msg || bail
}

## (command, package, message)
apt_get () {
  log_begin_msg "$3"
  OUTPUT="2>/dev/null"
  if [ "install" = "$1" ]; then
    OUTPUT="1>/dev/null"
  fi

  eval "apt-get -qq -y $1 $2 $OUTPUT"
  if [ "0" != "$?" ]; then
    log_failure_msg
    exit 1
  fi
  log_success_msg
}

install_package () {
  apt_get install $1 "Installing $1"
}

finish_install () {
  echo 1024 > /sys/block/sda/queue/read_ahead_kb
  echo 256  > /sys/block/sda/queue/nr_requests

  apt_get purge "$(dpkg --get-selections | grep blue | cut -f 1) busybox -qq" "Cleaning up"
  apt_get autoremove "--purge" "Cleaning unused packages"
  apt-get clean

  exit $?
}

## Begin the magic
cp -R etc/apt/* /etc/apt/

LAUNCHPADKEY="EEA14886"
LAUNCHPADCKH=$(apt-key list | grep $LAUNCHPADKEY)
if [ "0" != "$?" ]; then
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $LAUNCHPADKEY
fi

apt_get update "" "Updating apt sources and settings"
apt_get upgrade "" "Upgrading installed packages"

## Install base libraries
for PACKAGE in $(cat packages/base | grep -v '#'); do
  install_package $PACKAGE
done

## java
ask "Would you like to install java packages"
if [ "$CONFIRM" = "y" ]; then
  install_package oracle-java8-installer
fi

ask "Would you like to install Xfce packages"
if [ "$CONFIRM" != "y" ]; then
  finish_install
fi

for PACKAGE in $(cat packages/xfce | grep -v '#'); do
  install_package $PACKAGE
done

ask "Would you like to install Google Chrome over Chromium"
if [ "$CONFIRM" = "y" ]; then
  wget -q \
    https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    -O /tmp/chrome.deb

  run_command "dpkg -i /tmp/chrome.deb" "Installing Google Chrome"
else
  install_package chromium
fi

ask "Install VirtualBox"
if [ "$CONFIRM" != "y" ]; then
  finish_install
fi

install_package linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
install_package virtualbox
install_package virtualbox-dkms
install_package virtualbox-qt

finish_install
