#!/bin/sh
#mate-tweak.sh
#install mate-tweak with panel-layouts, features, tilda, plank, synapse
#by Jennifer E Volk

sudo add-apt-repository -y ppa:ubuntu-mate-dev/ppa
sudo apt-get update
sudo apt-get -y install mate-tweak mate-menu maximus libtopmenu-client-gtk2-0 libtopmenu-client-gtk3-0 mate-applet-topmenu plank mate-indicator-applet tilda mate-dock-applet synapse indicator-application-gtk2 indicator-sound-gtk2

wget https://launchpad.net/ubuntu/+archive/primary/+files/ubuntu-mate-settings_16.04.5.3.tar.xz

sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/mate-panel/layouts
sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/mate/autostart/tilda.desktop
sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/plank/themes/Ubuntu-MATE/

rm ubuntu-mate-settings_16.04.5.3.tar.xz
