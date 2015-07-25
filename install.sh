#!/bin/bash
#
### BEGIN INIT INFO
# Provides:           xfce4-desktop
# Short-Description:  Create lightweight, portable, self-sufficient desktop
#                     environment.
### END INIT INFO
set -e

# Require lsb functions
. /lib/lsb/init-functions

# Fail unless root
if [ "$(id -u)" != "0" ]; then
  log_failure_msg "$0 must be run as root"
  exit 1
fi

# int do_apt_get(char *commands)
do_apt_get()
{
  debconf-apt-progress --logfile=$1.log -- apt-get -y $@
}

# void do_install(char *packages)
do_install()
{
  do_apt_get install ${APT_INSTALL_RECOMENDS} -o APT::Get::AutomaticRemove=true $@
}

# int do_confirm(char *message)
do_confirm()
{
  echo -n "$@ [Y/n] "
  read confirm

  case ${confirm:-y} in
    Y|y) return 0 ;;
    *)   return 1 ;;
  esac
}

if do_confirm "Would you like to install recommended packages?"; then
  APT_INSTALL_RECOMENDS="-o APT::Install-Recommends=true"
fi

# Core packages.
PACKAGES=(
  bzip2
  ca-certificates
  curl
  firmware-linux
  firmware-linux-nonfree
  lsb-release
  ntfs-3g
  openssh-client
  patch
  policykit-1
  rsync
  secure-delete
  tlp
  unzip
  xz-utils
)

# Check for Atheros controllers
[ ! -z "$(lspci | grep Atheros)" ] && PACKAGES+=(firmware-atheros)

# Check for Realtek controllers
[ ! -z "$(lspci | grep Realtek)" ] && PACKAGES+=(firmware-realtek)

if do_confirm "Add Oracle Java (JDK and JRE) binaries?"
then
  if [ -z "$(apt-key list | grep EEA14886)" ]
  then
    log_begin_msg "Adding Oracle's GPG key"
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 &>/dev/null
    log_end_msg $?
  fi

  echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main\
    > /etc/apt/sources.list.d/webupd8team-java.list

  # Accept the Oracle JDK8 license automatically
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true
    | /usr/bin/debconf-set-selections

  # Finally append the package
  PACKAGES+=(oracle-java8-installer)
fi

if do_confirm "Install VirtualBox?"
then
  PACKAGES+=(linux-headers-$(uname -r) virtualbox virtualbox-dkms)
fi

if do_confirm "Install Google Chrome?"
then
  log_begin_msg "Adding Google's GPG key"
  GOOGLE_KEY=$(wget --no-check-certificate -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -)
  log_end_msg $?

  echo deb http://dl.google.com/linux/chrome/deb/ stable main\
    > /etc/apt/sources.list.d/google-chrome.list

  PACKAGES+=(google-chrome-stable)
fi

if do_confirm "Install Atom text editor?"
then
  DPKG_ATOM_INSTALL=$(mktemp /tmp/atom.XXXXXXXXXX)
  wget --no-check-certificate -q -c https://atom.io/download/deb -O $DPKG_ATOM_INSTALL &>/dev/null
fi

# Configure apt repositories
echo "\
#
# Debian “jessie”
# https://debian.org/releases/stable/releasenotes

deb http://httpredir.debian.org/debian jessie main contrib non-free
# deb-src http://httpredir.debian.org/debian jessie main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
# deb-src http://security.debian.org jessie/updates main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free
# deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free

#
# Backports cannot be tested as extensively as Debian stable, and backports are
# provided on an as-is basis, with risk of incompatibilities with other
# components in Debian stable. Use with care!

deb http://http.debian.net/debian jessie-backports main contrib non-free
# deb-src http://http.debian.net/debian jessie-backports main contrib non-free

#
# Please note that security updates for 'testing' distribution are not yet
# managed by the security team. Hence, 'testing' does not get security updates
# in a timely manner.

deb http://debian.pop-sc.rnp.br/debian testing main contrib non-free
# deb-src http://debian.pop-sc.rnp.br/debian testing main contrib non-free

" > /etc/apt/sources.list

echo "\
Package: *
Pin: release jessie
Pin-Priority: 900

" > /etc/apt/preferences.d/jessie

echo "\
#
# XFCE 4.12 (only in testing as of 2015 July)

# If used with tasksel
Package: tasksel tasksel-* task-*
Pin: release testing
Pin-Priority: 990

# Main Files, Development Tools and Plugins
Package: xfce4 xfce4-* xfce-* xfswitch-plugin
Pin: release testing
Pin-Priority: 990

# Configuration Manager
Package: xfconf libxfconf*
Pin: release testing
Pin-Priority: 990

# Menu Library (garcon)
Package: libgarcon*
Pin: release testing
Pin-Priority: 990

# Extension Library (exo)
Package: exo-utils exo-utils-dbg libexo-*
Pin: release testing
Pin-Priority: 990

# Widget Library and Utility Library
Package: libxfce4panel-* libxfce4ui-* libxfcegui4-* libxfce4util*
Pin: release testing
Pin-Priority: 990

# File Manager
Package: thunar thunar-* libthunar*
Pin: release testing
Pin-Priority: 990

# Desktop and Window Managers
Package: xfdesktop4 xfdesktop4-* xfwm4 xfwm4-*
Pin: release testing
Pin-Priority: 990

# Theme Engines
Package: gtk2-engines-* gtk3-engines-*
Pin: release testing
Pin-Priority: 990

# Thumbnail Generator (tumbler)
Package: tumbler tumbler-* libtumbler-*
Pin: release testing
Pin-Priority: 990

# Applications
Package: orage xfburn mousepad parole parole-* ristretto
Pin: release testing
Pin-Priority: 990

" > /etc/apt/preferences.d/xfce412

# Fanyness
echo
log_success_msg "Initial configuration is done."
log_begin_msg "You can add or remove additional packages editing the 'packages' file."
echo

# More fanyness
if ! do_confirm "Continue?"
then
  log_end_msg 1
fi
log_end_msg 0

# Add additional packages
PACKAGES+=($(cat packages | sed "s/ *#.*//g"))

# Update repositories
log_begin_msg "Updating repositories."
apt-get -qq update
log_end_msg $?

# UPgrade installed files
do_apt_get upgrade

# And then...
do_install ${PACKAGES[@]}

# Log installed packages
echo ${PACKAGES[@]} > packages.log

# Install Atom text editor
if [ ! -z "$DPKG_ATOM_INSTALL" ]
then
  dpkg -i $DPKG_ATOM_INSTALL
  echo atom >> packages.log
fi

# Install remainnning packages
do_apt_get install -f

echo "\
APT::Install-Recommends false;
APT::Install-Suggests false;

" > /etc/apt/apt.conf.d/00norecommends

# Clean up
do_apt_get purge bluetooth bluez busybox $(dpkg --get-selections | grep linux-headers | cut -f 1)
do_apt_get autoremove --purge
do_apt_get clean
