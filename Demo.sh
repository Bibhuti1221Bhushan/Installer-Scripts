#!/bin/sh

# Colors :
Green='\033[0;32m'        # Green
Cyan='\033[1;36m'        # Cyan
No='\e[0m'

# Installing Packages :
# Packages :
clear

# WM :
echo -e "${Cyan}Installing Login Manager Theme ...${No}"
sudo cp -r faces /usr/share/sddm/
sudo cp -r Corners /usr/share/sddm/themes
echo ""
echo -e "${Green}Installation Done ${No}"
echo ""
echo -e "EDIT = /usr/lib/sddm/sddm.conf.d/default.conf"


echo -e "Hello"