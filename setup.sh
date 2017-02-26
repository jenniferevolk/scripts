#!/bin/sh
clear
echo "Jenn's Laptop Setup"
#color codes
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

#functions
xinstall () {
  echo "  ${GREEN}installing $1${NC}"
  sudo apt-get install -q -y "$1" >> setup.log 2>&1 || echo "*** ${RED}$1 not installed${NC} ***"
}
binstall () {
  echo "  ${GREEN}installing $1${NC}"
  pkg=$1.deb
  wget -nv -O $pkg $2 >>setup.log 2>&1
  sudo dpkg -i $pkg >>setup.log 2>&1
  rm -f $pkg >>setup.log 2>&1
}

echo "Adding repositories.."
echo "  ${GREEN}tlp${NC}"
sudo add-apt-repository -y ppa:linrunner/tlp >>setup.log 2>&1
echo "  ${GREEN}variety${NC}"
sudo add-apt-repository -y ppa:peterlevi/ppa >>setup.log 2>&1
echo "  ${GREEN}telegram${NC}"
sudo add-apt-repository -y ppa:atareao/telegram >>setup.log 2>&1
echo "  ${GREEN}neofetch${NC}"
sudo add-apt-repository -y ppa:dawidd0811/neofetch >>setup.log 2>&1
echo "  ${GREEN}tor browser${NC}"
sudo add-apt-repository -y ppa:webupd8team/tor-browser >>setup.log 2>&1
echo "  ${GREEN}youtube-dl${NC}"
sudo add-apt-repository -y ppa:nilarimogard/webupd8 >>setup.log 2>&1
echo "  ${GREEN}atom${NC}"
sudo add-apt-repository -y ppa:webupd8team/atom >>setup.log 2>&1
echo "  ${GREEN}heroku${NC}"
sudo add-apt-repository -y "deb https://cli-assets.heroku.com/branches/stable/apt ./" >>setup.log 2>&1 #heroku
echo "  ${GREEN}spotify${NC}"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 >>setup.log 2>&1
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list >>setup.log 2>&1
echo "  ${GREEN}Numix${NC}"
sudo add-apt-repository -y ppa:numix/ppa >>setup.log 2>&1
echo "  ${GREEN}Sublime${NC}"
sudo add-apt-repository -y ppa:webupd8team/sublime-text-2 >>setup.log 2>&1
#echo "  ${GREEN}Nvidia drivers${NC}"
#add-apt-repository -y ppa:graphics-drivers/ppa >>setup.log 2>&1


echo "change mirrors & update repositories.."
sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo apt-get update >>setup.log 2>&1

#for ubuntu sudo sed -i s/"us.archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list >>setup.log 2>&1


#install messengers early so we can chat while install continues
echo "installing messengers.. (we can chat while installing)"
xinstall telegram
binstall skype https://go.skype.com/skypeforlinux-64-alpha.deb
binstall discord "https://discordapp.com/api/download?platform=linux&format=deb"
binstall rambox https://getrambox.herokuapp.com/download/linux_64?filetype=deb


echo "running updates..."
sudo apt-get -y upgrade >>setup.log 2>&1

echo "hardware stuffs..."
xinstall tlp
xinstall thermald
xinstall microcode.ctl
xinstall intel-microcode
xinstall preload

echo "codecs..  remove flash"
xinstall mint-meta-codecs
apt-get purge -y -q flashplugin-installer >>setup.log 2>&1

#echo "DVD support.."
#xinstall libdvdread4 
#xinstall libdvd-pkg
#dpkg-reconfigure libdvd-pkg

echo "cli tools.."
xinstall powertop
xinstall htop
xinstall neofetch
xinstall youtube-dl
xinstall libcurl3
xinstall libav-tools
xinstall ffmpeg
xinstall xclip

echo "file compression.."
xinstall p7zip-rar
xinstall p7zip-full
xinstall unace
xinstall unrar
xinstall zip
xinstall unzip
xinstall sharutils
xinstall rar
xinstall uudeview
xinstall mpack
xinstall arj
xinstall cabextract
xinstall file-roller

echo "desktop tools.."
xinstall redshift-gtk
xinstall plank
xinstall clipit
xinstall tilda
xinstall autokey-gtk
xinstall variety
xinstall spotify-client
xinstall gnome-do
xinstall numix-icon-theme-circle
xinstall numix-icon-theme

echo "graphics.."
xinstall blender
xinstall shotwell
xinstall gimp
xinstall shutter
xinstall cheese
xinstall pinta

echo "office.."
xinstall zim
xinstall anki
xinstall cherrytree
xinstall thunderbird

echo "virtualization.."
xinstall vagrant
xinstall virtualbox-qt
adduser jennifer vboxusers >>setup.log 2>&1

echo "web browsers.."
xinstall tor-browser
xinstall chromium-browser

echo "misc development tools.."
xinstall autoconf
xinstall automake
xinstall bison
xinstall build-essential
xinstall curl
xinstall git-core
xinstall libapr1
xinstall libaprutil1
xinstall libc6-dev
xinstall libltdl-dev
xinstall libreadline6
xinstall libreadline6-dev
xinstall libsqlite3-0
xinstall libsqlite3-dev
xinstall libssl-dev
xinstall libtool
xinstall libxml2-dev
xinstall libxslt-dev
xinstall libxslt1-dev
xinstall libyaml-dev
xinstall ncurses-dev
xinstall nodejs
xinstall openssl
xinstall sqlite3
xinstall zlib1g
xinstall zlib1g-dev

echo "  ${GREEN}installing rvm..${NC}"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >>setup.log 2>&1
curl -L -s get.rvm.io | bash -s stable >>setup.log 2>&1
source ~/.rvm/scripts/rvm

echo "  ${GREEN}installing ruby 2.3..${NC}"
rvm install 2.3 >>setup.log 2>&1
rvm --default use 2.3 >>setup.log 2>&1
source ~/.rvm/scripts/rvm

echo "  ${GREEN}installing rails..${NC}"
gem install rails >>setup.log 2>&1

echo "  ${GREEN}installing heroku..${NC}"
curl -L -s https://cli-assets.heroku.com/apt/release.key | apt-key add - >>setup.log 2>&1
sudo apt-get install -q -y --allow-unauthenticated heroku >> setup.log 2>&1 || echo "*** Heroku not installed${NC} ***"

binstall gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb
xinstall atom
xinstall sublime-text

#settings
echo "settings"
echo "  ${GREEN}turn on firewall${NC}"
ufw enable >>setup.log 2>&1

#cleaning up
echo "cleaning up.."
sudo apt-get clean >>setup.log 2>&1
sudo apt-get -y autoremove >>setup.log 2>&1
