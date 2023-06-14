#!/bin/bash

# Grub2 Theme

ROOT_UID=0
THEME_DIR="/boot/grub/themes"
THEME_NAME=CyberRe
MAX_DELAY=20                                        # MAX DELAY FOR USER TO ENTER ROOT PASS

#COLORS
CDEF=" \033[0m"                                     # DEFAULT COLOR
CCIN=" \033[0;36m"                                  # INFO COLOR
CGSC=" \033[0;32m"                                  # SUCCESS COLOR
CRER=" \033[0;31m"                                  # ERROR COLOR
CWAR=" \033[0;33m"                                  # WARNING COLOR
b_CDEF=" \033[1;37m"                                # BOLD DEFAULT COLOR
b_CCIN=" \033[1;36m"                                # BOLD INFO COLOR
b_CGSC=" \033[1;32m"                                # BOLD SUCCESS COLOR
b_CRER=" \033[1;31m"                                # BOLD ERROR COLOR
b_CWAR=" \033[1;33m"                                # BOLD WARNING COLOR

# ECHO LIKE...  WITH FLAG TYPE AND DISPLAY MESSAGE COLORS
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # PRINT SUCCESS MESSAGE
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;          # PRINT ERROR MESSAGE
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # PRINT WARNING MESSAGE
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # PRINT INFO MESSAGE
    *)
    echo -e "$@"
    ;;
  esac
}

# WELCOME MESSAGE
prompt -s "\n\t************************\n\t*  ${THEME_NAME} - Grub2 Theme  *\n\t************************"

# CHECK COMMAND AVALIBILITY
function has_command() {
  command -v $1 > /dev/null
}

# CHECKING FOR ROOT ACCESS AND PROCEED IF IT IS PRESENT
if [ "$UID" -eq "$ROOT_UID" ]; then

  # CREATE THEMES DIRECTORY IF NOT EXISTS
  prompt -i "\nChecking Directory...\n"
  [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
  mkdir -p "${THEME_DIR}/${THEME_NAME}"

  # COPY THEME
  prompt -i "\nInstalling Theme...\n"

  cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}

  # SET THEME
  prompt -i "\nSetting The Theme as Default...\n"

  # BACKUP GRUB CONFIG
  cp -an /etc/default/grub /etc/default/grub.bak

  grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub

  echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub

  # UPDATE GRUB CONFIG
  echo -e "Updating Grub..."
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command grub2-mkconfig; then
    if has_command zypper; then
      grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
  fi

  # SUCCESS MESSAGE
  prompt -s "\n\t          ***************\n\t          *  Installed!  *\n\t          ***************\n"

else

  # ERROR MESSAGE
  prompt -e "\n [ Error! ] -> Run as Root "

  # PERSISTED EXECUTION OF THE SCRIPT AS ROOT
  read -p "[ Trusted ] Specify The Root Password : " -t${MAX_DELAY} -s
  [[ -n "$REPLY" ]] && {
    sudo -S <<< $REPLY $0
  } || {
    prompt  "\n Operation Canceled"
    exit 1
  }
fi
