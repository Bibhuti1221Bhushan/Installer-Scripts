#!/bin/sh

# COLORS :
# ~~~~~~~~
Green='\033[0;32m'        # GREEN
Cyan='\033[1;36m'         # CYAN
Yellow='\e[1;33m'         # YELLOW  
No='\e[0m'

# CLEAR TERMINAL :
# ~~~~~~~~~~~~~~~~
clear

# INSTALLING SDDM THEME :
# ~~~~~~~~~~~~~~~~~~~~
echo -e "${Cyan}INSTALLING SDDM THEME...${No}"
sudo cp -r faces /usr/share/sddm/
sudo cp -r Corners /usr/share/sddm/themes
echo ""
sudo sed -i 's/Current=/Current=Corners/g' /usr/lib/sddm/sddm.conf.d/default.conf
sudo sed -i 's/Numlock=none/Numlock=on/g' /usr/lib/sddm/sddm.conf.d/default.conf
sudo sed -i 's/CursorTheme=/CursorTheme=Breeze/g' /usr/lib/sddm/sddm.conf.d/default.conf
sudo sed -i 's/CursorSize=/CursorSize=24/g' /usr/lib/sddm/sddm.conf.d/default.conf
echo ""
echo -e "${Green}INSTALLATION - DONE ${No}"
echo ""
echo ""

# REBOOTING :
# ~~~~~~~~~~~
read -rep $'\e[1;33mWOULD YOU LIKE TO REBOOT NOW (Y,N)  \e[0m' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec systemctl reboot --no-wall
else
    exit
fi

