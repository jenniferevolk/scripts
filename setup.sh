#!/bin/sh
#setup.sh
#Jennifer's laptop setup script
#by Jennifer E Volk

sudo -v
clear
############################### variables
#color codes
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# app lists
system="thermald microcode.ctl intel-microcode preload"

clitools="powertop htop libcurl3 libav-tools ffmpeg xclip tmux"

compression="p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract"

codecs="chromium-codecs-ffmpeg-extra gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libavcodec-extra libdvdcss2 libdvdnav4 libdvdread4 oxideqt-codecs-extra unshield vlc vlc-plugin-notify"

desktop="redshift-gtk geoclue-2.0 clipit autokey-gtk"

graphics="blender shutter cheese pinta"

office="zim anki cherrytree okular"

virtualization="vagrant virtualbox-qt virtualbox-guest-additions-iso linux-image-generic linux-image-extra-virtual"

browsers="chromium-browser"

devtools="autoconf automake bison build-essential curl libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3  zlib1g zlib1g-dev libgdbm-dev libncurses5-dev libffi-dev ruby-dev libcurl4-openssl-dev python-software-properties postgresql postgresql-contrib libpq-dev pgadmin3 libc6-dev nodejs"

repo_apps="tlp variety telegram neofetch tor-browser youtube-dl atom sublime-text docker heroku spotify-client numix-icon-theme-circle numix-folders arc-theme tor-browser docker-engine"

package_list=$devtools" "$browsers" "$virtualization" "$office" "$graphics" "$desktop" "$compresion" "$clitools" "$system" "$codecs

############################################reusable functions
 
download_install(){
    echo "  ${GREEN}Downloading $1${NC}"
    pkg=$1.deb
    wget -nv -O $pkg $2 >>setup.log 2>&1 
    sudo dpkg -i $pkg >>setup.log 2>&1 && echo "  ${GREEN}Installed $1${NC}"
    rm -f $pkg >>setup.log 2>&1 
}

add_repo(){
    sudo add-apt-repository -y $2 >>setup.log 2>&1 && echo " ${GREEN} Repo $1 added${NC}" || echo "*** ${RED}Repo $i not installed${NC} ***"
}

mass_install(){
	echo " ${GREEN} mass software install ${NC}"
	sudo apt-fast -y install $1 >>setup.log 2>&1  || {
		echo " ${RED} mass software install failed switching to indiviual installs ${NC}"
    	for i in $1; do
       		sudo apt-fast install  -y $i >>setup.log 2>&1 && echo " ${GREEN}  installed $i${NC}"  || echo "*** ${RED}$i not installed${NC} ***"
   		done
	}
}
################### Blocks ##########################
install_aptfast(){
	echo "installing apt-fast"
    sudo apt-get install -y aria2 git curl >>setup.log 2>&1   
    git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast >>setup.log 2>&1  
    sudo cp /tmp/apt-fast/apt-fast /usr/bin >>setup.log 2>&1  
    sudo chmod +x /usr/bin/apt-fast >>setup.log 2>&1  
    sudo cp /tmp/apt-fast/apt-fast.conf /etc >>setup.log 2>&1  
}

set_mirrors(){
	echo "setting faster mirrors"
    MIRRORS="MIRRORS=( 'http://mirror.os6.org/ubuntu/,http://mirror.math.ucdavis.edu/ubuntu/,http://mirrors.us.kernel.org/ubuntu/, http://mirrors.xmission.com/ubuntu/' )"
    sudo sh -c "echo '$MIRRORS'  >> /etc/apt-fast.conf" >>setup.log 2>&1  

    sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 
    sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 
}

add_repos(){
	echo "Adding keys.."
	#keys
    #heroku
    curl -SsL https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - >>setup.log 2>&1 && echo  " ${GREEN} Added Heroku ${NC}"
   
    #spotify
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886 >>setup.log 2>&1 && echo  " ${GREEN} Added Spotify ${NC}"

    #docker
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >>setup.log 2>&1 && echo  " ${GREEN} Added Docker ${NC}"

	echo "Adding repositories.."
	#repos
    add_repo tlp        ppa:linrunner/tlp
    add_repo variety    ppa:peterlevi/ppa
    add_repo telegram   ppa:atareao/telegram
    add_repo neofetch   ppa:dawidd0811/neofetch
    add_repo tor        ppa:webupd8team/tor-browser
    add_repo youtube-dl ppa:nilarimogard/webupd8
    add_repo atom       ppa:webupd8team/atom
    add_repo numix      ppa:numix/ppa
    add_repo arc        ppa:noobslab/themes
    add_repo sublime    ppa:webupd8team/sublime-text-2
    add_repo heroku     "deb https://cli-assets.heroku.com/branches/stable/apt ./"
    add_repo spotify    "deb http://repository.spotify.com stable non-free"

    sudo apt-get update >>setup.log 2>&1
}


install_software(){

	echo "upgrading..."
    sudo apt-fast -y upgrade >>setup.log 2>&1 
 

	echo "now for the software..."
    mass_install "$package_list"
	mass_install "$repo_apps"

	echo "installing slow downloads"
    download_install rambox https://getrambox.herokuapp.com/download/linux_64?filetype=deb
    download_install skype https://go.skype.com/skypeforlinux-64-alpha.deb
    download_install discord "https://discordapp.com/api/download?platform=linux&format=deb"
    download_install slack https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb
    download_install gitter https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb
    download_install gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb
}

rails_install(){

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
    
    
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc
    echo "   installing rails"
    gem install rails 

    echo "   install bundler"
    gem install bundler 

    rvm --version
    ruby -v
    rails -v
    bundler version
}

settings(){

	echo "settings.."

	echo "  ${GREEN}turn on firewall${NC}"
	sudo ufw enable >>setup.log 2>&1 

	echo "  ${GREEN}add user to vbox group ${NC}"
	sudo adduser $USER vboxusers >>setup.log 2>&1 
}

cleanup(){
	echo "cleaning up.." 
	echo "  ${GREEN}clear caches${NC}"
	sudo apt-get clean >>setup.log 2>&1 
	sudo apt-get -y autoremove >>setup.log 2>&1 
}

main(){
	clear
	echo "Jennifer's setup"
	install_aptfast
	set_mirrors
	add_repos
	install_software
	rails_install
	settings
	cleanup
}

main

