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
echo .
echo "installing apt-fast"
sudo apt-get install -y aria2 git >>setup.log 2>&1   
git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast >>setup.log 2>&1  
sudo cp /tmp/apt-fast/apt-fast /usr/bin >>setup.log 2>&1  
sudo chmod +x /usr/bin/apt-fast >>setup.log 2>&1  
sudo cp /tmp/apt-fast/apt-fast.conf /etc >>setup.log 2>&1  

echo "setting faster mirrors"
MIRRORS="MIRRORS=( 'http://mirror.os6.org/ubuntu/,http://mirror.math.ucdavis.edu/ubuntu/,http://mirrors.us.kernel.org/ubuntu/, http://mirrors.xmission.com/ubuntu/' )"
sudo sh -c "echo '$MIRRORS'  >> /etc/apt-fast.conf" >>setup.log 2>&1  

sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 
sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 


################### functions #########################
binstall () {
    echo "  ${GREEN}installing $1${NC}"
    echo "">>setup.log 2>&1
    echo "========= installing $1 ==========" >>setup.log 2>&1 
    echo "">>setup.log 2>&1
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
    for i in $1; do
       echo "">>setup.log 2>&1
       echo "========= installing $1 ==========" >>setup.log 2>&1 
       echo "">>setup.log 2>&1
       sudo apt-fast install -q -y $i >>setup.log 2>&1  && echo "   installed $i" || apt-get install -q -y $i >>setup.log 2>&1  && echo "   installed $i" || echo "*** ${RED}$i not installed${NC} ***"
    done
}

# ******* app lists *******
system="thermald microcode.ctl intel-microcode preload"

clitools="powertop htop neofetch youtube-dl libcurl3 libav-tools ffmpeg xclip"

compression="p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract"

desktop="redshift-gtk geoclue-2.0 clipit tilda autokey-gtk"

graphics="blender shutter cheese pinta"

office="zim anki cherrytree okular"

virtualization="vagrant virtualbox-qt virtualbox-guest-additions-iso linux-image-generic linux-image-extra-virtual"

browsers="chromium-browser"

devtools="autoconf automake bison build-essential curl libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3  zlib1g zlib1g-dev libgdbm-dev libncurses5-dev libffi-dev ruby-dev"

pkglist=$devtools" "$browsers" "$virtualization" "$office" "$graphics" "$desktop" "$compresion" "$clitools" "$system

special_apps="tlp variety telegram neofetch tor-browser youtube-dl atom sublime-text docker heroku mate-tweak spotify-client numix-icon-theme-circle numix-folders arc-theme tor-browser docker-engine"
################### Repositories #########################

echo "Adding repositories.."
    sudo apt-fast install -y --no-install-recommends apt-transport-https ca-certificates curl >>setup.log 2>&1 

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

    sudo apt-get update >>setup.log 2>&1 

#************************* software
echo "installing rambox early so we can chat during install"
    binstall rambox https://getrambox.herokuapp.com/download/linux_64?filetype=deb

echo "upgrading..."
    sudo apt-fast -y upgrade 
 
echo "codecs.."
    sudo apt-fast -q -y install mint-meta-codecs || sudo apt-fast -q -y install ubuntu-restricted-extras

echo "special repo installs"
    sudo apt-get -y -q install $special_apps >>setup.log 2>&1  || slowinstall $special_apps

echo "now for the software..."
    sudo apt-fast -y install $pkglist || echo "${red}***mass install failed, switching to slow mode***${nc}" ; slowinstall $pkglist

echo "installing slow downloads"
    binstall skype https://go.skype.com/skypeforlinux-64-alpha.deb
    binstall discord "https://discordapp.com/api/download?platform=linux&format=deb"
    binstall slack https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb
    binstall gitter https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb
    binstall gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb

echo "installing rails..${GREEN}"
echo ""
echo "  installing rvm"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3  
    curl -sSL https://get.rvm.io | bash -s stable  
    source ~/.rvm/scripts/rvm 
    echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile

    echo "   installing Ruby"
    rvm install 2.4.0  
    rvm use 2.4.0 --default  

    echo "   installing rails"
    gem install rails 

    echo "   install bundler"
    gem install bundler 

    rvm --version
    ruby -v
    rails -v
    bundler version

################### settings #########################

echo "settings.."

echo "  ${GREEN}turn on firewall${NC}"
sudo ufw enable >>setup.log 2>&1 

echo "  ${GREEN}add user to vbox group ${NC}"
sudo adduser $USER vboxusers >>setup.log 2>&1 

################### clean up #########################

echo "cleaning up.."
echo "  ${GREEN}remove flash${NC}"
sudo apt-get purge -y -q flashplugin-installer >>setup.log 2>&1 

echo "  ${GREEN}clear caches${NC}"
sudo apt-get clean >>setup.log 2>&1 
sudo apt-get -y autoremove >>setup.log 2>&1 
