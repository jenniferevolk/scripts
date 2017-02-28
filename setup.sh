#!/bin/sh
#setup.sh
#Jennifer's laptop setup script
#by Jennifer E Volk

sudo -v
clear

#color codes
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

echo "Jenn's Laptop Setup"
echo ""
echo "installing apt-fast"
sudo apt-get install -y aria2 git >> setup.log 2>&1
git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast >> setup.log 2>&1
sudo cp /tmp/apt-fast/apt-fast /usr/bin >> setup.log 2>&1
sudo chmod +x /usr/bin/apt-fast >> setup.log 2>&1
sudo cp /tmp/apt-fast/apt-fast.conf /etc >> setup.log 2>&1

echo "set faster mirrors"
MIRRORS="MIRRORS=( 'http://mirror.os6.org/ubuntu/,http://mirror.math.ucdavis.edu/ubuntu/,http://mirrors.us.kernel.org/ubuntu/, http://mirrors.xmission.com/ubuntu/' )"
sudo sh -c "echo $MIRRORS  >> /etc/apt-fast.conf" >> setup.log 2>&1

sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1


################### functions #########################

xinstall () {
  echo "  ${GREEN}installing $1${NC}"
  echo "">>setup.log
  echo "========= installing $1 ==========" >> setup.log
  echo "">>setup.log
  sudo apt-fast install -q -y "$1" >> setup.log 2>&1 || echo "*** ${RED}$1 not installed${NC} ***"
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

repo(){
    sudo add-apt-repository -y $2 >>setup.log 2>&1
    echo "  ${GREEN} $1 ${NC}"
}
slowinstall(){
echo "*** ${RED}$1 Warp drive failed switching to impulse (one at a time) ${NC} ***"
echo "mass install failed switching to individual install">>setup.log

echo "system stuff..."
xinstall tlp
xinstall thermald
xinstall microcode.ctl
xinstall intel-microcode
xinstall preload

echo "codecs.."
xinstall mint-meta-codecs

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
xinstall clipit
xinstall tilda
xinstall autokey-gtk
xinstall variety
xinstall spotify-client

##mate tweak and related apps
xinstall mate-tweak
xinstall mate-menu
xinstall maximus
xinstall libtopmenu-client-gtk2-0
xinstall libtopmenu-client-gtk3-0
xinstall mate-applet-topmenu
xinstall plank
xinstall mate-indicator-applet
xinstall mate-dock-applet
xinstall synapse
xinstall indicator-application-gtk2
xinstall indicator-sound-gtk2

echo "icons and theme.."
xinstall numix-icon-theme-circle
xinstall numix-folders
xinstall arc-theme

echo "graphics.."
xinstall blender
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
xinstall atom
xinstall sublime-text
}
################### Repositories #########################

echo "Adding repositories.."
sudo apt-fast install -y --no-install-recommends apt-transport-https ca-certificates curl software-properties-common >>setup.log 2>&1

#keys
#heroku
curl -SsL https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - >>setup.log 2>&1
#spotify
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886 >>setup.log 2>&1 
#docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >>setup.log 2>&1 

repo tlp        ppa:linrunner/tlp
repo variety    ppa:peterlevi/ppa
repo telegram   ppa:atareao/telegram
repo neofetch   ppa:dawidd0811/neofetch
repo tor        ppa:webupd8team/tor-browser
repo youtube-dl ppa:nilarimogard/webupd8
repo atom       ppa:webupd8team/atom
repo numix      ppa:numix/ppa
repo arc        ppa:noobslab/themes
repo sublime    ppa:webupd8team/sublime-text-2
repo docker     "deb https://apt.dockerproject.org/repo ubuntu-xenial main"
repo heroku     "deb https://cli-assets.heroku.com/branches/stable/apt ./"
repo spotify    "deb http://repository.spotify.com stable non-free"
repo mate-tweak ppa:ubuntu-mate-dev/ppa

sudo apt-get update >>setup.log 2>&1

echo "installing rambox early so we can chat during install"
binstall rambox https://getrambox.herokuapp.com/download/linux_64?filetype=deb

echo "upgrading..."
sudo apt-fast -y upgrade >>setup.log 2>&1

echo "special repo installs"
apt-get -y -q "tlp variety telegram neofetch tor-browser youtube-dl atom sublime-text docker heroku mate-tweak spotify-client numix-icon-theme-circle numix-folders arc-theme tor-browser docker-engine" >>setup.log 2>&1

echo "lets try warp speed (mass install): warp speed....engage!"
apt-fast -q -y install thermald microcode.ctl intel-microcode preload mint-meta-codecs powertop htop libcurl3 libav-tools ffmpeg xclip p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract redshift-gtk geoclue-2.0 clipit tilda autokey-gtk mate-menu maximus libtopmenu-client-gtk2-0 libtopmenu-client-gtk3-0 mate-applet-topmenu plank mate-indicator-applet mate-dock-applet synapse indicator-application-gtk2 indicator-sound-gtk2 blender shutter cheese pinta zim anki cherrytree vagrant virtualbox-qt virtualbox-guest-additions-iso linux-image-generic linux-image-extra-virtual chromium-browser autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev libgdbm-dev libncurses5-dev libffi-dev sublime-text || slowinstall

echo "repo installs finished"

echo "installing slow downloads"
binstall skype https://go.skype.com/skypeforlinux-64-alpha.deb
binstall discord "https://discordapp.com/api/download?platform=linux&format=deb"
binstall slack https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb
binstall gitter https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb
binstall gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb


echo "installing rails..${GREEN}"

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

################### settings #########################

echo "settings.."

echo "  ${GREEN}turn on firewall${NC}"
sudo ufw enable >>setup.log 2>&1

echo "  ${GREEN}add user to vbox group ${NC}"
sudo adduser $USER vboxusers >>setup.log 2>&1

echo "  ${GREEN}mate-tweak settings ${NC}"
wget https://launchpad.net/ubuntu/+archive/primary/+files/ubuntu-mate-settings_16.04.5.3.tar.xz >>setup.log 2>&1

sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/mate-panel/layouts >>setup.log 2>&1
sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/mate/autostart/tilda.desktop >>setup.log 2>&1
sudo tar --strip-components=1 -xf ubuntu-mate-settings_16.04.5.3.tar.xz -C / ubuntu-mate-settings-xenial/usr/share/plank/themes/Ubuntu-MATE/ >>setup.log 2>&1
rm ubuntu-mate-settings_16.04.5.3.tar.xz

################### clean up #########################

echo "cleaning up.."
echo "  ${GREEN}remove flash${NC}"
sudo apt-get purge -y -q flashplugin-installer >>setup.log 2>&1

echo "  ${GREEN}clear caches${NC}"
sudo apt-get clean >>setup.log 2>&1
sudo apt-get -y autoremove >>setup.log 2>&1
