#!/bin/sh
clear
echo "Jenn's Laptop Setup"
sudo -v
#color codes
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

#functions
xinstall () {
  echo "  ${GREEN}installing $1${NC}"
  echo "">>setup.log
  echo "========= installing $1 ==========" >> setup.log
  echo "">>setup.log
  sudo apt-get install -q -y "$1" >> setup.log 2>&1 || echo "*** ${RED}$1 not installed${NC} ***"
}
binstall () {
  echo "  ${GREEN}installing $1${NC}"
  echo "">>setup.log
  echo "========= installing $1 ==========" >> setup.log
  echo "">>setup.log
  pkg=$1.deb
  wget -nv -O $pkg $2 >>setup.log 2>&1
  sudo dpkg -i $pkg >>setup.log 2>&1
  rm -f $pkg >>setup.log 2>&1
}

echo "Adding repositories.."
sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl software-properties-common >>setup.log 2>&1
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
sudo add-apt-repository -y "deb https://cli-assets.heroku.com/branches/stable/apt ./" >>setup.log 2>&1 
curl -SsL https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - >>setup.log 2>&1
echo "  ${GREEN}spotify${NC}"
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free" >>setup.log 2>&1
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886 >>setup.log 2>&1
echo "  ${GREEN}Numix icons${NC}"
sudo add-apt-repository -y ppa:numix/ppa >>setup.log 2>&1
echo "  ${GREEN}Arc theme${NC}"
sudo add-apt-repository -y ppa:noobslab/themes >>setup.log 2>&1
echo "  ${GREEN}Sublime${NC}"
sudo add-apt-repository -y ppa:webupd8team/sublime-text-2 >>setup.log 2>&1
echo "  ${GREEN}Docker${NC}"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >>setup.log 2>&1
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' >>setup.log 2>&1


#echo "  ${GREEN}Nvidia drivers${NC}"
#add-apt-repository -y ppa:graphics-drivers/ppa >>setup.log 2>&1

echo "change mirrors & update repositories.."
sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo apt-get update >>setup.log 2>&1
sudo sed -i s/"us.archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list >>setup.log 2>&1
sudo apt-get update >>setup.log 2>&1

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

echo "desktop tools.."
xinstall redshift-gtk
xinstall geoclue-2.0
xinstall plank
xinstall clipit
xinstall tilda
xinstall autokey-gtk
xinstall variety
xinstall spotify-client
xinstall gnome-do

echo "icons and theme.."
xinstall numix-icon-theme-circle
xinstall numix-folders
xinstall arc-theme

echo "graphics.."
xinstall blender
xinstall gimp
xinstall shutter
xinstall cheese
xinstall pinta

echo "office.."
xinstall zim
xinstall anki
xinstall cherrytree

echo "virtualization.."
xinstall vagrant
xinstall virtualbox-qt
xinstall virtualbox-guest-additions-iso
adduser jennifer vboxusers >>setup.log 2>&1
xinstall linux-image-generic
xinstall linux-image-extra-virtual
xinstall docker-engine

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
xinstall libgdbm-dev
xinstall libncurses5-dev
xinstall libffi-dev
xinstall heroku


binstall gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb
xinstall atom
xinstall sublime-text

echo "installing rails.."
echo "${GREEN}"
gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >>setup.log 2>&1
curl -sSL https://get.rvm.io | bash -s stable >>setup.log 2>&1
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
rvm version
rvm install 2.4.0
rvm use 2.4.0 --default
ruby --version

sudo gem install rails -v 5.0.1 >>setup.log 2>&1
rails version
sudo gem install bundler >>setup.log 2>&1
bundler version
echo "${NC}"
#settings
echo "settings.."
echo "  ${GREEN}turn on firewall${NC}"
sudo ufw enable >>setup.log 2>&1

#cleaning up
echo "cleaning up.."
sudo apt-get clean >>setup.log 2>&1
sudo apt-get -y autoremove >>setup.log 2>&1
