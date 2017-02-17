#!/bin/sh

echo "Adding repositories.."
sudo add-apt-repository -y ppa:linrunner/tlp >>setup.log 2>&1           #tlp
sudo add-apt-repository -y ppa:peterlevi/ppa >>setup.log 2>&1            #variety
sudo add-apt-repository -y ppa:atareao/telegram >>setup.log 2>&1         #telegram
sudo add-apt-repository -y ppa:dawidd0811/neofetch >>setup.log 2>&1      #neofetch
sudo add-apt-repository -y ppa:webupd8team/tor-browser >>setup.log 2>&1   #tor-browser
sudo add-apt-repository -y ppa:nilarimogard/webupd8 >>setup.log 2>&1    #youtube-dl
sudo add-apt-repository -y ppa:webupd8team/atom >>setup.log 2>&1       #atom
sudo add-apt-repository -y "deb https://cli-assets.heroku.com/branches/stable/apt ./" >>setup.log 2>&1 #heroku


echo "change mirrors.."
sudo sed -i s/"archive.ubuntu.com"/"mirror.math.ucdavis.edu"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1
sudo sed -i s/"packages.linuxmint.com"/"mirrors.kernel.org/linuxmint-packages"/g /etc/apt/sources.list.d/official-package-repositories.list >>setup.log 2>&1

#recommends? lightness vs features
#sudo sed -i 's/false/true/g' /etc/apt/apt.conf.d/00recommends >>setup.log 2>&1

sudo apt-get update >>setup.log 2>&1
#install messengers early so we can chat while install continues
echo "installing messengers.. (we can chat while installing)"
sudo apt-get install -q telegram hexchat >>setup.log 2>&1
wget https://go.skype.com/skypeforlinux-64-alpha.deb >>setup.log 2>&1
sudo dpkg -i --force-depends skypeforlinux-64-alpha.deb >>setup.log 2>&1
wget -o discord.deb https://discordapp.com/api/download?platform=linux&format=deb >>setup.log 2>&1
sudo dpkg -i  discord.deb >>setup.log 2>&1
wget -o rambox.deb https://getrambox.herokuapp.com/download/linux_64?filetype=deb
sudo dpkg -i rambox.deb >>setup.log 2>&1

echo "running updates..."
sudo apt-get -y upgrade >>setup.log 2>&1

echo "installing hardware stuffs..."
sudo apt-get -y install tlp tlp-rdw thermald >>setup.log 2>&1
sudo apt-get -y install nvidia-304 nvidia-settings bumblebee bumblebee-nvidia linux-headers-generic primus primus-libs >>setup.log 2>&1

sudo apt-get -y install microcode.ctl intel-microcode >>setup.log 2>&1

echo "installing codecs..  (everything except flash and ttf)"
sudo apt-get -y install chromium-codecs-ffmpeg-extra gstreamer0.10-ffmpeg gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad-faad gstreamer1.0-plugins-bad-videoparsers gstreamer1.0-plugins-ugly gstreamer1.0-plugins-ugly-amr liba52-0.7.4 libass5 libavcodec-extra libavcodec-ffmpeg-extra56 libavfilter-ffmpeg5 libavformat-ffmpeg56 libavresample-ffmpeg2 libavutil-ffmpeg54 libbasicusageenvironment1 libbluray1 libbs2b0 libcddb2 libchromaprint0 libcrystalhd3 libdc1394-22 libdca0 libde265-0 libdirectfb-1.2-9 libdvbpsi10 libdvdcss2 libebml4v5 libfaad2 libflite1 libfluidsynth1 libgme0 libgroupsock8 libgstreamer-plugins-bad1.0-0 libgtkglext1 libiso9660-8 libkate1 liblivemedia50 libmad0 libmatroska6v5 libmimic0 libmjpegutils-2.1-0 libmms0 libmodplug1 libmp3lame0 libmpcdec6 libmpeg2-4 libmpeg2encpp-2.1-0 libmpg123-0 libmplex2-2.1-0 libmspack0 libofa0 libopenal1 libopencv-calib3d2.4v5 libopencv-contrib2.4v5 libopencv-core2.4v5 libopencv-features2d2.4v5 libopencv-flann2.4v5 libopencv-highgui2.4v5 libopencv-imgproc2.4v5 libopencv-legacy2.4v5 libopencv-ml2.4v5 libopencv-objdetect2.4v5 libopencv-video2.4v5 libopenjpeg5 libpostproc-ffmpeg53 libproxy-tools libqt5x11extras5 libresid-builder0c2a libschroedinger-1.0-0 libsdl-image1.2 libshine3 libsidplay1v5 libsidplay2v5 libsnappy1v5 libsodium18 libsoundtouch1 libsoxr0 libspandsp2 libsrtp0 libssh-gcrypt-4 libssh2-1 libswresample-ffmpeg1 libswscale-ffmpeg3 libtbb2 libtwolame0 libunshield0 libupnp6 libusageenvironment3 libva-drm1 libva-x11-1 libva1 libvcdinfo0 libvlc5 libvlccore8 libvncclient1 libvo-aacenc0 libvo-amrwbenc0 libwildmidi-config libwildmidi1 libx264-148 libx265-79 libxcb-composite0 libxcb-xv0 libxvidcore4 libzbar0 libzmq5 libzvbi-common libzvbi0 oxideqt-codecs-extra unrar unshield vlc vlc-data vlc-nox vlc-plugin-notify xplayer-mozilla xplayer-plugins-extra  >>setup.log 2>&1

echo "DVD support.."
sudo apt-get install -q libdvdread4 >>setup.log 2>&1
sudo /usr/share/doc/libdvdread4/install-css.sh >>setup.log 2>&1

echo "cli tools.."
sudo apt-get install -q powertop htop neofetch youtube-dl libcurl3 libav-tools ffmpeg xclip >>setup.log 2>&1

echo "file compression.."
sudo apt-get install -q p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract file-roller >>setup.log 2>&1


echo "desktop tools.."
sudo apt-get install -q redshift-gtk geoclue-2.0 plank clipit tilda autokey-gtk variety transmission >>setup.log 2>&1

echo "graphics.."
sudo apt-get install -q blender shotwell gimp shutter cheese pinta >>setup.log 2>&1


echo "office.."
sudo apt-get install -q zim anki cherrytree thunderbird libreoffice >>setup.log 2>&1

echo "virtualization.."
sudo apt-get install -q vagrant virtualbox-qt >>setup.log 2>&1
sudo adduser jennifer vboxusers >>setup.log 2>&1

echo "web browsers.."
sudo apt-get install -q tor-browser firefox >>setup.log 2>&1

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >>setup.log 2>&1
sudo dpkg -i google-chrome-stable_current_amd64.deb >>setup.log 2>&1

echo "misc development tools.."
sudo apt-get install -q autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev >>setup.log 2>&1

echo "rvm.."
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >>setup.log 2>&1
curl -L get.rvm.io | bash -s stable >>setup.log 2>&1

echo "ruby 2.3 .."
rvm install 2.3 >>setup.log 2>&1
rvm --default use 2.3 >>setup.log 2>&1

echo "rails.."
gem install rails >>setup.log 2>&1

echo "heroku.."
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - >>setup.log 2>&1
sudo apt-get install -q heroku >>setup.log 2>&1

echo "gitkracken.."
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb >>setup.log 2>&1
sudo dpkg -i gitkraken-amd64.deb >>setup.log 2>&1

echo "atom.."
sudo apt-get install -q atom >>setup.log 2>&1
echo "sublime.."
sudo apt-get install -q sublime-text >>setup.log 2>&1


#settings
echo "turn on firewall"
sudo ufw enable >>setup.log 2>&1

#cleaning up
echo "cleaning up.."
sudo apt-get clean >>setup.log 2>&1
sudo apt-get -y autoremove >>setup.log 2>&1
