#!/bin/sh

#          #
#  BACKUP  #
#          #

rsync -avzu --delete "${HOME}/Documents/jcloriente@interiorvista.net/Google/Drive/" "${HOME}/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Interiorvista/MyDrive";

#Team Drives
rsync -avzu --delete "${HOME}/Documents/jcloriente@interiorvista.net/Google/TeamDrives/IT/" "${HOME}/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Interiorvista/TeamDrives/IT/";
rsync -avzu --delete "${HOME}/Documents/jcloriente@interiorvista.net/Google/TeamDrives/IT - Shared/" "${HOME}/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Interiorvista/TeamDrives/IT - Shared/";
rsync -avzu --delete "${HOME}/Documents/jcloriente@interiorvista.net/Google/TeamDrives/Customer contracts/" "${HOME}/Documents/carles.loriente@gmail.com/Google/MyDrive/Backup/Interiorvista/TeamDrives/Customer contracts/";
