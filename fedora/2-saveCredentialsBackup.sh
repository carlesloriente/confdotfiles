#!/bin/bash
#######################################################################################################
#######################################################################################################
#######################################################################################################
######                                                                                          #######
######                                                                                          #######
######                                                                                          #######
######                                   Save Credentials                                       #######
######                                     Version-0.1                                          #######
######                                                                                          #######
######                                                                                          #######
#######################################################################################################
#######################################################################################################
#######################################################################################################

## Enable extended globbing for the +(...) pattern
shopt -s extglob

# define variables
DATE=$(date +\%Y\%m\%d);
BACKUP_DIR=( ".aws" ".bashrc" ".bash_profile" ".bash_eternal_history" ".bash_history" ".gnupg" ".ssh" ".vpn" )
OUTPUT_DIR="$HOME/Documents/carles.loriente@gmail.com/Google/Drive/Backup/Automatic/"
password="pro61cld"
cd $HOME

echo "Save credentials";
echo "";

#echo "Please enter your encryption password";
#stty -echo
#read password;
#stty echo

start_env() {

    echo "Checking environment";
	if [ ! -d $OUTPUT_DIR/$DATE ]; then
		mkdir -p $OUTPUT_DIR/$DATE;
	fi

}

list_backup() {

	for i in "${BACKUP_DIR[@]}"; do
		if [ -d "${HOME}/${i}" ] || [ -f "${HOME}/${i}" ]; then
			echo $i;
			create_backup;
		fi
	done

}

create_backup() {

	echo "Creating archive $OUTPUT_DIR/$i.tar.gz from $HOME/.config/$i";
	tar -czvf $OUTPUT_DIR/$i.tar.gz $HOME/$i;
	gpg --yes --batch --passphrase=$password -c $OUTPUT_DIR/$i.tar.gz
	cp $OUTPUT_DIR/$i.tar.gz.gpg $OUTPUT_DIR/$DATE/$i.tar.gz.gpg && rm -f $OUTPUT_DIR/$i.tar.gz;

}

clean_env() {

    echo "Script finished";

}

start_env;
list_backup;
create_backup;
clean_env;
