#!/bin/bash
#######################################################################################################
#######################################################################################################
#######################################################################################################
######                                                                                          #######
######                                                                                          #######
######                                                                                          #######
######                                   Install SymLinks                                       #######
######                                     Version-0.1                                          #######
######                                                                                          #######
######                                                                                          #######
#######################################################################################################
#######################################################################################################
#######################################################################################################

## Enable extended globbing for the +(...) pattern
shopt -s extglob

BACKUP_DIR=( ".aws" ".bashrc" ".bash_profile" ".bash_eternal_history" ".bash_history" ".gnupg" ".ssh" ".vpn" );
INPUT_DIR="$HOME/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Automatic";

cd $HOME

echo "Restore credentials";
echo "";

echo "Please enter the decryption password";
stty -echo
read password;
stty echo

list_backup() {

	for i in "${BACKUP_DIR[@]}"; do
		echo $i;
		restore_backup;
	done

}

restore_backup() {

	echo "Restoring archive $INPUT_DIR/$i.tar.gz to $HOME/$i";
	gpg --yes --batch --passphrase=$password --output $INPUT_DIR/$i.tar.gz -d $INPUT_DIR/$i.tar.gz.gpg;
	tar xzvf $INPUT_DIR/$i.tar.gz --strip-components=2 -C $HOME;
	rm -f $INPUT_DIR/$i.tar.gz;

}

clean_env() {

    echo "Script finished";

}

start_env;
list_backup;
restore_backup;
clean_env;
