#!/bin/bash
#######################################################################################################
#######################################################################################################
#######################################################################################################
######                                                                                          #######
######                                                                                          #######
######                                                                                          #######
######                                   Install SymLinks                                       #######
######                                     Version-0.1                                          #######
######                                   DropBox Required                                       #######
######                                                                                          #######
######                                                                                          #######
#######################################################################################################
#######################################################################################################
#######################################################################################################

cd $HOME

echo ""
echo "Enable repos FREE and NoFREE (drm shit)"
sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;

#sudo dnf -y install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
#sudo dnf -y install http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm

sudo dnf update -y
sudo dnf group install -y "C Development Tools and Libraries"
sudo dnf -y install wget go rubygems readline jpegoptim autoconf automake cmake libtool bison sqlite-devel readline-devel binutils zlib zlib-devel gcc gcc-c++ make patch qt libgomp glibc-headers glibc-devel redhat-rpm-config kernel-headers kernel-devel dkms curl cabextract xorg-x11-font-utils fontconfig nano htop catfish ettercap etherape filezilla gparted gpick inkscape meld screenruler shutter wireshark nmap Zim terminator calligra-krita gnome-tweak-tool bzip2 libxcb libxcb-devel libX11-devel
sudo dnf -y install arora php php-devel jekyll backintime-gnome jq iperf catfish tokyocabinet calendar fuse fuse-devel s3fs-fuse fuse-exfat exfat-utils chkrootkit conky dia fontforge gnucash sshpass p7zip p7zip-plugins wine libyubikey pam_yubico yubikey-personalization-gui ykpers figlet vlc python-vlc community-mysql
sudo dnf -y install liveusb-creator dnf-plugins-core ShellCheck ntp ntpdate s3cmd hub youtube-dl joe goaccess iperf3 lsyncd pydf gnupg seahorse seahorse-nautilus epiphany cifs-utils openconnect NetworkManager-openconnect-gnome xl2tpd NetworkManager-l2tp NetworkManager-l2tp-gnome libreswan NetworkManager-libreswan NetworkManager-libreswan-gnome ldns nss-tools libuuid-devel libguestfs-tools python-swiftclient python-devel firewall-config gimp pinta tigervnc task ruby-devel filezilla java-1.8.0-openjdk-devel
sudo dnf -y install libxcrypt-compat dos2unix compat-readline6-static compat-readline6 python3-virtualenv python3-devel python-wheel-wheel python3-rpm-macros nautilus-python python3-gobject mailx obs-studio pgp-tools libxml2-devel acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig suricata jython recoll recoll-gssp gsconnect
sudo dnf -y install https://rpmfind.net/linux/fedora/linux/releases/30/Everything/x86_64/os/Packages/f/fslint-2.46-6.fc30.noarch.rpm
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

sudo mkdir -p /usr/share/fonts/Stackicons /usr/share/fonts/DevIcons
sudo cp ~/Downloads/fonts/Stackicons/Stackicons-Branding.otf /usr/share/fonts/Stackicons/
sudo cp ~/Downloads/fonts/Stackicons/Stackicons-Social-Minimal.otf /usr/share/fonts/Stackicons/
sudo cp ~/Downloads/fonts/Stackicons/Stackicons-Social-Minimal.otf /usr/share/fonts/Stackicons/
sudo cp ~/Downloads/fonts/DevIcons/devicons.ttf /usr/share/fonts/DevIcons/
sudo fc-cache -v

sudo dnf -y clean all

sudo ipsec initnss
sudo ipsec import ~/Documents/jcloriente@interiorvista.net/Google/MyDrive/cert_export_jcloriente@svpn.bathapps.com.p12

sudo dd of=/etc/ipsec.d/roadwarriorclient.conf << EOF
conn awsibikev2
    ikev2=insist
    left=%defaultroute
    leftsubnet=0.0.0.0/0
    leftcert=jcloriente@svpn.bathapps.com
    leftid=%fromcert
    leftmodecfgclient=yes
    right=svpn.bathapps.com
    rightid=%fromcert
    rightsubnet=0.0.0.0/0
    rightca=%same
    authby=rsasig
    narrowing=yes
    mobike=yes
    auto=add
EOF

sudo systemctl enable ipsec
sudo systemctl start ipsec

#sudo ipsec auto --up awsibikev2
#sudo ipsec auto --down awsibikev2

echo ""
echo "# NTP Service"
sudo service ntpd start
sudo systemctl enable ntpd.service
sudo firewall-cmd --permanent --add-service ntp
sudo firewall-cmd --reload

echo ""
echo "# InSync"
sudo dnf -y install https://d2t3ff60b2tol4.cloudfront.net/builds/insync-3.2.6.40863-fc30.x86_64.rpm

echo ""
echo "# Golang"
sudo dnf install golang
mkdir -p $HOME/go
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
source $HOME/.bashrc

echo ""
echo "# Minica"
go get github.com/jsha/minica

echo ""
echo "# Docker"
sudo dd of=/etc/yum.repos.d/docker-ce.repo << EOF
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/31/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF
sudo dnf -y install docker-ce docker-ce-cli containerd.io
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker newgrp docker
sudo systemctl start docker
sudo systemctl enable docker

echo ""
echo "# ChefDK"
sudo dnf -y install https://packages.chef.io/repos/yum/stable/el/7/x86_64/chefdk-4.10.0-1.el7.x86_64.rpm

echo ""
echo "# Vagrant"
sudo dnf -y install https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.rpm
vagrant plugin list # lista los plugins que ya tenemos instalados.
vagrant plugin install vagrant-vbguest vagrant-share

echo ""
echo "# TeamViewer"
sudo dnf -y install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm 

echo ""
echo "# Keybase"
sudo dnf -y install https://prerelease.keybase.io/keybase_amd64.rpm
#run_keybase

sudo gem update --system
sudo gem install jekyll bundler

echo
echo "# NodeJS"
# curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
wget https://rpm.nodesource.com/setup_12.x && bash setup_12.x && sudo dnf install nodejs -y && rm -f setup_12*
sudo pip install nodeenv

echo "- Oracle JDK"
echo "- Oracle JRE"

echo ""
echo "# Terraform"
wget https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip && unzip terraform_0.13.1_linux_amd64.zip && rm -f terraform_0.13.1_linux_amd64.zip
sudo mv terraform /usr/local/bin/

echo ""
echo "# PyCharm"
sudo dnf -y copr enable phracek/PyCharm
sudo dnf install -y pycharm-community pycharm-community-plugins

#echo ""
#echo "# Webserver"
#sudo dnf -y install httpd openssl-devel libffi-devel libjpeg-devel libcurl-devel zlib-devel libevent-devel ImageMagick mod_geoip mod_ssl mod_wsgi php mysql php-devel php-pdo php-soap php-mbstring php-cli php-common php-mcrypt php-soap php-xml php-process php-pear php-curl php-gd php-pecl-imagick
#mkdir $HOME/public_html
#sudo chmod g+s $HOME/public_html
#sudo chmod 750 $HOME/public_html
#sudo chmod -R 755 $HOME/home/*/public_html
#sudo cp modules/*.so /usr/lib64/php/modules/

#sudo setsebool -P httpd_unified 1
#sudo setsebool -P httpd_enable_homedirs on
#sudo setsebool -P httpd_execmem 1
#sudo setsebool -P httpd_can_network_connect 1

#sudo systemctl start httpd.service
#sudo systemctl enable httpd.service

#echo ""
#echo "# Install MariaDB MySQL"
#sudo dnf -y install mariadb mariadb-server mariadb-devel
#sudo systemctl start mariadb.service
#sudo systemctl enable mariadb.service
#/usr/bin/mysql_secure_installation

echo ""
echo "# Install VirtualBox"
src='https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo'
dst='/etc/yum.repos.d/virtualbox.repo'
sudo sh -c "curl ${src} > ${dst}"
sudo dnf -y install VirtualBox

echo ""
echo "# Install yarn"
#curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
src='https://dl.yarnpkg.com/rpm/yarn.repo'
dst='/etc/yum.repos.d/yarn.repo'
sudo sh -c "curl ${src} > ${dst}"
sudo dnf -y install yarn

echo ""
echo "# Install Calibre"
sudo -v && wget -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

echo ""
echo "# Install DBeaver"
sudo dnf -y install https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm

echo ""
echo "# Install Visual Studio Code"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf -y install code

echo ""
echo "# Install PostMan"
cd $HOME
wget https://dl.pstmn.io/download/latest/linux64
tar xzvf linux64
mv Postman .postman

echo ""
echo "# Install mPack"
sudo dnf -y install ftp://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/mpack-1.6-2.el6.rf.x86_64.rpm

echo ""
echo "# Add bookmarks to Nautilus"
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com/Google/MyDrive/Coding" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com/Google/MyDrive/Personal" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net/" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net/Google/MyDrive/INTV_work" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net/Google/TeamDrives/" >> $HOME/.config/gtk-3.0/bookmarks

echo "#Add entries to /etc/hosts"
echo -e "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
echo -e "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo -e "192.168.0.250   server" >> /etc/hosts

echo ""
echo "# Copy config"
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Coding/bashrc .
mv $HOME/bashrc $HOME/.bashrc
rm -f $HOME/bashrc
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Coding/nanorc .
mv $HOME/nanorc $HOME/.nanorc
rm -f $HOME/nanorc

echo ""
echo "# Task data and config"
echo "##ln -ns Documents/carles.loriente@gmail.com/Tasks/.task .task"
echo "##ln -ns Documents/carles.loriente@gmail.com/Tasks/.taskrc .taskrc"

echo ""
echo "# Create symlinks"
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/Books\ and\ manuals/Calibre\ Library/ Calibre\ Library
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/.pwsafe .pwsafe
cd Documents
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/ Conf\ files
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Books\ and\ manuals/ Books\ and\ manuals
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Apps/ Apps
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/AWS_Simple_Icons_svg_eps/ AWS_Simple_Icons
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Coding\ and\ Scripting/ Coding\ and\ Scripting
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/SysAdminCasts/ SysAdminCasts

echo ""
echo "# Copy credentials"
cd $HOME
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/Credentials.7z .
7z e $HOME/Credentials.7z -oCredentials -r
cp -R $HOME/Credentials/*.pem $HOME/.ssh/
chmod 400 $HOME/.ssh/*.pem
cp $HOME/Credentials/jcloriente_api_credentials.csv .
cp $HOME/Credentials/WorkBench_intv.zip .
unzip $HOME/WorkBench_intv.zip
cp $HOME/Credentials/FileZilla_intv.xml .

echo ""
echo "# Copy Wifi and VPN credentials"
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/Credentials/VPN.7z .
7z e $HOME/VPN.7z -oVPN -r
sudo cp -R $HOME/VPN/* /etc/NetworkManager/system-connections/
sudo chown -R root:root /etc/NetworkManager/system-connections/
rm -rf $HOME/VPN
rm -f $HOME/VPN.7z
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/Credentials/Wifi.7z .
7z e $HOME/Wifi.7z -oWifi -r
sudo cp -R $HOME/Wifi/* /etc/sysconfig/network-scripts/
sudo chown -R root:root /etc/sysconfig/network-scripts/
rm -rf $HOME/Wifi
rm -f $HOME/Wifi.7z

echo ""
echo "# Install Pwsafe"
sudo dnf -y install https://netix.dl.sourceforge.net/project/passwordsafe/Linux/1.11.0/passwordsafe-fedora32-1.11-amd64.rpm

echo ""
echo "# Install Slack"
sudo dnf -y install https://downloads.slack-edge.com/linux_releases/slack-4.4.3-0.1.fc21.x86_64.rpm

echo ""
echo "# Install Zoom"
sudo dnf -y install https://hashicorp.zoom.us/client/latest/zoom_x86_64.rpm

echo ""
echo "# Install Zenmap"
sudo dnf -y install https://nmap.org/dist/nmap-7.10-1.x86_64.rpm
sudo dnf -y install https://nmap.org/dist/zenmap-7.10-1.noarch.rpm

echo ""
echo "# Install Serverless"
#curl -o- -L https://slss.io/install | bash
src='https://slss.io/install'
dst=$HOME/'serverless_install.sh'
sudo sh -c "curl ${src} > ${dst}"
sh $HOME/serverless_install.sh

echo ""
echo "# Install httping"
echo "# use: httping -s -Y --threshold-red 100 --threshold-yellow 80 HOST"
git clone https://github.com/flok99/httping.git
cd httping/
sudo make install
rm -rf httping

echo ""
echo "# Install AngryIPScanner"
sudo dnf -y install https://github.com/angryziber/ipscan/releases/download/3.7.1/ipscan-3.7.1-1.x86_64.rpm

echo ""
echo "# Install Rclone"
sudo dnf -y install https://downloads.rclone.org/v1.52.2/rclone-v1.52.2-linux-amd64.rpm

echo ""
echo "# Install Mikrotik Winbox"
wget https://mt.lv/winbox64
mkdir -p $HOME/.winbox
mv $HOME/winbox64 $HOME/.winbox/winbox.exe
cp $HOME/Documents/carles.loriente\@gmail.com/Google/MyDrive/Conf\ files/desktop/winbox.desktop $HOME/.local/share/applications/

echo ""
echo "# Install UMongo"
wget https://s3.amazonaws.com/edgytech/umongo-linux-all_1-6-2.zip
unzip $HOME/umongo-linux-all_1-6-2.zip
mv $HOME/umongo-linux-all_1-6-2/ $HOME/.umongo/
cp $HOME/Documents/carles.loriente@gmail.com/Conf\ files/umongo.desktop $HOME/.local/share/applications/

echo ""
echo "# Install Brave"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf -y install brave-browser

echo ""
echo "# Install Chrome"
sudo dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

echo ""
echo "# Zap"
wget https://github.com/zaproxy/zaproxy/releases/download/v2.9.0/ZAP_2_9_0_unix.sh
bash $HOME/ZAP_2_9_0_unix.sh && rm -f $HOME/ZAP_2_9_0_unix.sh


echo ""
echo "# Burp suite"
wget https://portswigger.net/burp/releases/initiatedownload?product=community&version=2020.9.2&type=Linux
bash $HOME/burpsuite_community_linux_v2020_9_1.sh && rm -f $HOME/burpsuite_community_linux_v2020_9_1.sh
mkdir -p $HOME/.config/burp/extender_libs/
wget https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.2/jython-standalone-2.7.2.jar && mv $HOME/jython-standalone-2.7.2.jar $HOME/.config/burp/extender_libs/
wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.2.13.0/jruby-dist-9.2.13.0-bin.tar.gz && tar xzvf $HOME/jruby-dist-9.2.13.0-bin.tar.gz && mv $HOME/jruby-9.2.13.0/ $HOME/.config/burp/extender_libs/ && rm -f $HOME/jruby-dist-9.2.13.0-bin.tar.gz 


echo ""
echo "# W3af"
sudo git clone --depth 1 https://github.com/andresriancho/w3af.git /opt/w3af
cd /opt/w3af
echo "./w3af_gui"
echo "./w3af_console" 

echo ""
echo "# MITMProxy"
wget https://snapshots.mitmproxy.org/5.2/mitmproxy-5.2-linux.tar.gz
tar xzvf $HOME/mitmproxy-5.2-linux.tar.gz && rm -f $HOME/mitmproxy-5.2-linux.tar.gz
sudo mv $HOME/mitm* /usr/local/bin/

echo "Install packages to access iOS devices"
sudo dnf install -y ifuse libimobiledevice-utils
sudo install -d /mnt/ipad -o $USER
ifuse /mnt/ipad    

echo ""
echo "Install AWS Cli"
#curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
src='https://s3.amazonaws.com/aws-cli/awscli-bundle.zip'
dst=$HOME/'awscli-bundle.zip'
sudo sh -c "curl ${src} > ${dst}"
unzip $HOME/awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf $HOME/awscli-bundle*
rm -f $HOME/jcloriente_api_credentials.csv

sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-service nfs 
sudo firewall-cmd --permanent --add-service={nfs3,mountd,rpc-bind} 
sudo firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p gre -j ACCEPT
sudo firewall-cmd --permanent --zone=public --add-masquerade
sudo firewall-cmd --permanent --add-port=1723/tcp
sudo firewall-cmd --reload
echo "modprobe nf_conntrack_pptp nf_conntrack_proto_gre"

sudo su
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox/" && /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxdrv) && mokutil --import MOK.der && /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetadp) && mokutil --import MOK.der && /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxnetflt) && modprobe vboxdrv && modprobe vboxnetadp && modprobe vboxnetflt
/sbin/vboxconfig
exit

echo #Script finished, reboot...#
