#!/bin/bash
#######################################################################################################
#######################################################################################################
#######################################################################################################
######                                                                                          #######
######                                                                                          #######
######                                                                                          #######
######                                   Restore settings                                       #######
######                                     Version-0.1                                          #######
######                                                                                          #######
######                                                                                          #######
#######################################################################################################
#######################################################################################################
#######################################################################################################

## Enable extended globbing for the +(...) pattern
shopt -s extglob

# define variables
#DATE=$(date +%F-%a-%H.%M); # year-month-date-day-hour.minute format

BACKUP_DIR=( "BraveSoftware" "Code" "evolution" "gnome-gmail" "Insync" "rclone" "remmina" "Slack" "teamviewer" "VirtualBox" );
INPUT_DIR="$HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Automatic";

function pause {
	read -n 1 -s -r -p "Press any key to continue"
}

cd $HOME

echo "Restore settings:"
echo ""
echo "Please goto http://extensions.gnome.org"
echo "Install: Drop Down Terminal X, Jenkins CI Server Indicator, IP Finder, Keyman, OpenWeather, Screenshot tool, Clipboard indicator"

pause

echo ""
echo "Please configure Insync"

pause

echo ""
echo "# Add bookmarks to Nautilus"
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com/Google/MyDrive/Coding" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/carles.loriente@gmail.com/Google/MyDrive/Personal" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net/Google/MyDrive/INTV_work" >> $HOME/.config/gtk-3.0/bookmarks
echo -e "file:///home/$USER/Documents/jcloriente@interiorvista.net/Google/TeamDrives" >> $HOME/.config/gtk-3.0/bookmarks

echo ""
echo "# Restore some files"
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/nanorc $HOME/.nanorc
cp $HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/taskrc $HOME/.taskrc

#sudo su
#echo "#Add entries to /etc/hosts"
#echo -e "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
#echo -e "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
#exit

pause

echo ""
echo "# Task data and config"
echo "##ln -ns Documents/carles.loriente@gmail.com/Tasks/.task .task"
echo "##ln -ns Documents/carles.loriente@gmail.com/Tasks/.taskrc .taskrc"

echo ""
echo "# Create symlinks"
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/Books\ and\ manuals/Calibre\ Library/ Calibre\ Library
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/.pwsafe .pwsafe
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/1-saveSettings.sh backupSettings.sh
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/2-saveCredentialsBackup.sh backupCredentials.sh
ln -ns Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/3-backupInteriorvista.sh backupInteriorvista.sh
cd Documents
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Conf\ files/ Conf\ files
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Books\ and\ manuals/ Books\ and\ manuals
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Apps/ Apps
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/AWS_Simple_Icons_svg_eps/ AWS_Simple_Icons
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Coding/ Coding
ln -ns ../Documents/carles.loriente@gmail.com/Google/MyDrive/Videos/SysAdminCasts/ SysAdminCasts

ln -ns ../Documents/jcloriente@interiorvista.net/Google/MyDrive/INTV_work/ INTV_work

cd $HOME

echo "Restore settings";
echo "";

echo "Please enter the dencryption password";
stty -echo
read password;
stty echo

start_env() {

    echo "Checking environment";
	if [ ! -d $HOME/backup-logs ]; then
		mkdir -p $HOME/backup-logs
	fi

}

list_backup() {

	for i in "${BACKUP_DIR[@]}"; do
		echo $i;
		restore_backup;
	done

}

restore_backup() {

	echo "Restoring archive $INPUT_DIR/$i.tar.gz to $HOME/.config/$i";
	gpg --yes --batch --passphrase=$password --output $INPUT_DIR/$i.tar.gz -d $INPUT_DIR/$i.tar.gz.gpg;
        tar xzvf $INPUT_DIR/$i.tar.gz --strip-components=2 -C $HOME;
	rm -f $INPUT_DIR/$i.tar.gz;

}

add_crontab() {

    echo "Do you wish to create a crontab entry for backup scripts?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) crontab -l | { cat; echo '01 9 * * 1-5 /usr/bin/sh $HOME/backupSettings.sh >> $HOME/backup-logs/`date +\%Y\%m\%d\%H\%M\%S`-backupSettings.log 2>&1'; } | crontab -; crontab -l | { cat; echo '20 9 * * 1-5 /usr/bin/sh $HOME/backupCredentials.sh >> $HOME/backup-logs/`date +\%Y\%m\%d\%H\%M\%S`-backupCredentials.log 2>&1'; } | crontab -; crontab -l | { cat; echo '50 9 * * 1-5 /usr/bin/sh $HOME/backupInteriorvista.sh >> $HOME/backup-logs/`date +\%Y\%m\%d\%H\%M\%S`-backupInteriorvista.log 2>&1'; } | crontab -; exit;;
            No ) break;;
        esac
    done
    echo "Adding job to crontab";

}

clean_env() {

    echo "Script finished";

}

start_env;
list_backup;
restore_backup;
add_crontab;
clean_env;
