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

clitools="powertop htop whois libcurl3 libav-tools ffmpeg xclip tmux tilda traceroute nmap lame soundstretch libid3-3.8.3v5"

compression="p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract"

#codecs="chromium-codecs-ffmpeg-extra gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libavcodec-extra libdvdcss2 libdvdnav4 libdvdread4 oxideqt-codecs-extra unshield vlc vlc-plugin-notify"
codecs="mint-meta-codecs"
desktop="redshift-gtk geoclue-2.0 clipit autokey-gtk"

graphics="gimp blender shutter cheese pinta"

office="libreoffice zim anki cherrytree okular"

virtualization="vagrant virtualbox-qt virtualbox-guest-additions-iso linux-image-generic linux-image-extra-virtual"

web="chromium-browser hexchat telegram gpodder"

devtools="autoconf automake bison build-essential libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3  zlib1g zlib1g-dev libgdbm-dev libncurses5-dev libffi-dev ruby-dev libcurl4-openssl-dev python-software-properties postgresql postgresql-contrib libpq-dev pgadmin3 libc6-dev nodejs sqlitebrowser git curl"

repo_apps="tlp variety telegram neofetch tor-browser youtube-dl atom sublime-text docker heroku-toolbelt spotify-client numix-icon-theme-circle numix-folders arc-theme tor-browser docker-engine"

xapps="xreader xplayer xviewer pix xed"

package_list=$devtools" "$internet" "$virtualization" "$office" "$graphics" "$desktop" "$compresion" "$clitools" "$system" "$codecs

remove_list=""

############################################reusable functions
 
download_install(){
    echo "-------------------------------------" >setup.log
    log "  ${GREEN}Downloading $1${NC}"
    pkg=$1.deb
    wget -nv -O $pkg $2 >>setup.log 2>&1 
    sudo dpkg -i $pkg >>setup.log 2>&1 && log "  ${GREEN}Installed $1${NC}"
    rm -f $pkg >>setup.log 2>&1 
}

add_repo(){
    echo "-------------------------------------" >setup.log
    sudo add-apt-repository -y $2 >>setup.log 2>&1 && log " ${GREEN} Repo $1 added${NC}" || log "*** ${RED}Repo $i not installed${NC} ***"
}

mass_install(){
    echo "-------------------------------------" >setup.log
	log " ${GREEN} mass software install ${NC}"
	sudo apt-fast -y install $1  || {
		log " ${RED} mass software install failed switching to indiviual installs ${NC}"
    	for i in $1; do
            echo "-------------------------------------" >setup.log
       		sudo apt-fast install  -y $i >>setup.log 2>&1 && log " ${GREEN}  installed $i${NC}"  || log "*** ${RED}$i not installed${NC} ***"
   		done
	}
}
log(){
echo $1
echo -e "\n"$1"\n" > setup.log
}
################### Blocks ##########################
install_aptfast(){
	log "installing apt-fast"
    sudo apt-get install -y aria2 git curl >>setup.log 2>&1   
    git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast >>setup.log 2>&1  
    sudo cp /tmp/apt-fast/apt-fast /usr/bin >>setup.log 2>&1  
    sudo chmod +x /usr/bin/apt-fast >>setup.log 2>&1  
    sudo cp /tmp/apt-fast/apt-fast.conf /etc >>setup.log 2>&1  
}

set_mirrors(){
	log "setting faster mirrors"
    MIRRORS="MIRRORS=( 'http://mirror.os6.org/ubuntu/,http://mirror.math.ucdavis.edu/ubuntu/,http://mirrors.us.kernel.org/ubuntu/, http://mirrors.xmission.com/ubuntu/' )"
    sudo sh -c "echo '$MIRRORS'  >> /etc/apt-fast.conf" >>setup.log 2>&1  

    sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 
    sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org\/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1 
}

add_repos(){
	log "Adding keys.."
	#keys
   
    #spotify
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886 >>setup.log 2>&1 && log  " ${GREEN} Added Spotify ${NC}"

    #docker
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >>setup.log 2>&1 && log  " ${GREEN} Added Docker ${NC}"

	log "Adding repositories.."
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
   add_repo spotify    "deb http://repository.spotify.com stable non-free"
    add_repo xapps		ppa:embrosyn/xapps

    sudo apt-get update >>setup.log 2>&1
}


install_software(){

	log "upgrading..."
    sudo apt-fast -y upgrade
 

	log "now for the software..."
    mass_install "$package_list"
	mass_install "$repo_apps"

	log "installing slow downloads"
    download_install rambox https://getrambox.herokuapp.com/download/linux_64?filetype=deb
    download_install skype https://go.skype.com/skypeforlinux-64-alpha.deb
    download_install discord "https://discordapp.com/api/download?platform=linux&format=deb"
    download_install slack https://downloads.slack-edge.com/linux_releases/slack-desktop-2.4.2-amd64.deb
    download_install gitter https://update.gitter.im/linux64/gitter_3.1.0_amd64.deb
    download_install gitkracken https://release.gitkraken.com/linux/gitkraken-amd64.deb

log "  ${GREEN}installing heroku${NC}"
wget https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz -O heroku.tar.gz >>setup.log 2>&1
sudo tar -xvzf heroku.tar.gz -C /usr/local/lib >>setup.log 2>&1
sudo /usr/local/lib/heroku/install >>setup.log 2>&1
}

rails_install(){

	log "installing rails..${GREEN}"
	echo ""
	log "  installing rvm"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3   >>setup.log 2>&1
    curl -sSL https://get.rvm.io | bash -s stable   >>setup.log 2>&1
    source ~/.rvm/scripts/rvm  >>setup.log 2>&1
    echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile  >>setup.log 2>&1

    log "   installing Ruby"
    rvm install 2.4.0   >>setup.log 2>&1
    rvm use 2.4.0 --default   >>setup.log 2>&1
    
    
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc  >>setup.log 2>&1
    log "   installing rails"
    gem install rails  >>setup.log 2>&1

    log "   installing bundler"
    gem install bundler  >>setup.log 2>&1

    

    rvm --version  
    ruby -v 
    rails -v
    bundler version
    heroku --version
}

settings(){
log "  ${GREEN}turn on firewall${NC}"
	log "settings.."

	
	sudo ufw enable >>setup.log 2>&1 

	log "  ${GREEN}add user to vbox group ${NC}"
	sudo adduser $USER vboxusers >>setup.log 2>&1 
}

cleanup(){
	log "cleaning up.." 
	sudo apt-get remove $remove_list >>setup.log 2>&1
	sudo apt-get clean >>setup.log 2>&1 
	sudo apt-get -y autoremove >>setup.log 2>&1 
}


main(){
	clear
	log "Jennifer's setup"
	install_aptfast
	set_mirrors
	add_repos
	install_software
	rails_install
	settings
	cleanup
}

main

