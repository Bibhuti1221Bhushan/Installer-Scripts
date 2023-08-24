#  ─█▀▀█ ░█▀▀█ ░█▀▀█ ░█─░█    ▀█▀ ░█▄─░█ ░█▀▀▀█ ▀▀█▀▀ ─█▀▀█ ░█─── ░█───  
#  ░█▄▄█ ░█▄▄▀ ░█─── ░█▀▀█    ░█─ ░█░█░█ ─▀▀▀▄▄ ─░█── ░█▄▄█ ░█─── ░█─── 
#  ░█─░█ ░█─░█ ░█▄▄█ ░█─░█    ▄█▄ ░█──▀█ ░█▄▄▄█ ─░█── ░█─░█ ░█▄▄█ ░█▄▄█

# UPDATE SYSTEM CLOCK 
timedatectl set-ntp true       

# CONNECT TO INTERNET
iwctl station wlan0 show                 
iwctl station wlan0 connect SSID-NAME                       

# CHECK INTERNET CONNECTION
ping -c 3 8.8.8.8

# ROOT PARTITION
lsblk
fdisk /dev/sda
g = WARNING --FORMAT WHOLE DISK IN GPT PARTITION TABLE
n = NEW PARTITION 
SIMPLY PRESS ENTER = 2ND PARTITION
SIMPLY PRESS ENTER = AS FIRST SECTOR 
+30G = AS LAST SECTOR (ROOT PARTITION)

# HOME PARTITION
n = NEW PARTITION 
SIMPLY PRESS ENTER = 2ND PARTITION
SIMPLY PRESS ENTER = AS FIRST SECTOR 
-512M = AS LAST SECTOR (HOME PARTITION EXCEPT 500M)

# BOOT PARTITION
n = NEW PARTITION
SIMPLY PRESS ENTER = 1ST PARTITION
SIMPLY PRESS ENTER = AS FIRST SECTOR
SIMPLY PRESS ENTER = AS LAST SECTOR (BOOT PARTITION OF REMAINING SPACE)
t = PARTITION TYPE
1 = FOR EFI PARTITION TABLE
p = PRINT PARTITION CONFIGURATION 
w = WRITE & EXIT

# FORMATTING PARTITIONS
mkfs.ext4 -L ROOT /dev/sda1
mkfs.ext4 -L HOME /dev/sda2
mkfs.fat -F 32 -n BOOT /dev/sda3

# MOUNTING PARTITIONS
mount /dev/sda1 /mnt
mkdir /mnt/home 
mount /dev/sda2 /mnt/home
mkdir -p /mnt/boot/EFI
mount /dev/sda3 /mnt/boot/EFI

# INSTALLING BASE SYSTEM 
pacstrap -Ki /mnt base base-devel linux linux-firmware linux-headers intel-ucode

# GENERATING FSTAB
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# CHROOT
arch-chroot /mnt

# CHECK PACMAN KEYS
pacman-key --init
pacman-key --populate

# INSTALLING EDITOR - NEOVIM
pacman -Sy neovim

# SET LOCAL-TIME
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# SET LANGUAGE & GENERATE LOCALE
nvim /etc/locale.gen                     # --UNCOMMENT [ en_US.UTF-8 UTF-8 ]
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# SET HOSTNAME
echo iTunes > /etc/hostname

# SET HOSTS
nvim /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    iTunes.localdomain iTunes

# SET ROOT PASSWORD
passwd 

# ADD USER ACCOUNT & PASSWORD
useradd -m Bibhuti -c "Bibhuti Bhushan"
passwd Bibhuti      
usermod -aG wheel,audio,video,storage,disk,network,power,input,optical Bibhuti

# CONFIGURING SUDOERS
EDITOR=nvim visudo      # --UNCOMMENT [ %wheel ALL=(ALL) ALL ]

# CREATE SWAP FILE 
# dd if=/dev/zero of=/opt/swapfile bs=1M count=8192 status=progress
# chmod 0600 /opt/swapfile
# mkswap -L SWAP -U clear /opt/swapfile
# swapon /opt/swapfile
# echo '/opt/swapfile none swap sw 0 0' | tee -a /etc/fstab
# cat /etc/fstab
# free -h

# CONFIGURING PACMAN
nvim /etc/pacman.conf   # --UNCOMMENT [ Color ParallelDownloads Multilib ] & ADD [ ILoveCandy ]
pacman -Syu

# INSTALLING GRUB BOOT MANAGER
pacman -S grub efibootmgr       
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id="Boot Manager" --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# CONFIGURING NETWORK MANAGER
pacman -S networkmanager
systemctl enable NetworkManager

# NO WATCH-DOG
nvim /etc/modprobe.d/nowatchdog.conf
blacklist iTCO_wdt      # --ADD THIS LINE

# CONSOLE KEY-MAP
nvim /etc/vconsole.conf   
KEYMAP=us				# --ADD THIS LINE
FONT=default8x16		# --ADD THIS LINE

# RE-BUILDING MKINITCPIO - CONSOLE FONT
nvim /etc/mkinitcpio.conf
BINARIES=(setfont)    	# --EDIT THIS LINE
mkinitcpio -P

# FINAL STEPS
exit
unmount -R /mnt
poweroff


                   # POST INSTALLATION ARCH LINUX ON TTY #


# RECONNECTING INTERNET
sudo nmtui

# CHECK FOR UPDATES
sudo pacman -Syu

# INSTALLING -- AUDIO PACKAGES - PIPEWIRE
sudo pacman -S pipewire pipewire-jack pipewire-pulse pipewire-alsa pavucontrol
systemctl --user enable pipewire pipewire-pulse wireplumber

# INSTALLING -- HYPRLAND NEEDED STUFF
sudo pacman -S hyprland xdg-desktop-portal-hyprland wl-clipboard 

# INSTALLING -- COMMON ESSENTIAL PACKAGES
sudo pacman -S kitty firefox pcmanfm-gtk3

# INSTALLING -- SDDM WINDOW MANAGER
sudo pacman -S sddm
sudo systemctl enable sddm

# INSTALLING -- GIT & AUR HELPER (PARU)
sudo pacman -S git
mkdir -p Downloads/Repos
cd Downloads/Repos
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin
paru --gendb  

# INSTALLING -- MISSING DRIVERS 
# paru -S mkinitcpio-firmware

# INSTALLING -- COMMON ESSENTIAL PACKAGES 
paru -S xfce-polkit 
paru -S visual-studio-code-bin

# BOOT IN TO WINDOW MANAGER
sudo reboot --r now


                   # MANUAL POST INSTALLATION ON HYPRLAND WINDOWS MANAGER #


# CLONING PERSONAL DOTS FILES
mkdir -p Documents/Github
cd Documents/Github
git clone https://github.com/Bibhuti1221Bhushan/Personal-Dots
git clone https://github.com/Bibhuti1221Bhushan/Personal-Backups
git clone https://github.com/Bibhuti1221Bhushan/Installer-Scripts

# COPING PERSONAL KEY-BINDINGS
COPY HYPRLAND CONFIG
sudo reboot -r now

# INSTALLING -- ESSENTIAL PACKAGES FOR HYPRLAND
sudo pacman -S --needed waybar swayidle swaybg dunst cliphist

# INSTALLING -- ESSENTIAL SYSTEM PACKAGES  
sudo pacman -S --needed brightnessctl pamixer acpi imagemagick ffmpegthumbnailer tumbler wtype dialog 

# INSTALLING -- ARCHIVE SUPPORT
sudo pacman -S --needed file-roller p7zip unrar

# INSTALLING -- MOUNTING SUPPORT FOR DEVICES
sudo pacman -S --needed mtpfs gvfs-mtp gvfs-nfs gvfs-gphoto2 gvfs-afc

# INSTALLING -- DIFFERENT FILE-SYSTEM SUPPORT
sudo pacman -S --needed usbutils f2fs-tools ntfs-3g exfatprogs udftools xfsprogs btrfs-progs 

# INSTALLING -- FILE-SYSTEM SUPPORT FOR GRUB
sudo pacman -S --needed dosfstools mtools

# INSTALLING -- NEEDED FOR SYSTEM
sudo pacman -S --needed wget pacman-contrib xorg-xhost gnome-keyring libgnome-keyring

# INSTALLING -- NEEDED VIDEO DRIVERS
sudo pacman -S  mesa-utils

# INSTALLING -- MAN PAGES
sudo pacman -S --needed man-db man-pages 

# INSTALLING -- PYTHON THINGS
sudo pacman -S --needed python-pillow python-pip python-requests

# INSTALLING -- YOUTUBE DOWNLOAD SUPPORT
sudo pacman -S --needed yt-dlp youtube-dl

# INSTALLING -- TERMINAL PACKAGES
sudo pacman -S --needed bat exa htop neofetch ranger starship

# INSTALLING -- NEEDED FOR QT THEME ENGINE
sudo pacman -S --needed qt5-graphicaleffects qt5-svg qt5-quickcontrols2
sudo pacman -S --needed kvantum qt5ct qt5-tools qt5-wayland  

# INSTALLING -- GUI PACKAGES
sudo pacman -S --needed imv mpv evince galculator pinta gnome-disk-utility
sudo pacman -S --needed font-manager meld catfish baobab network-manager-applet  

# INSTALLING -- EXTRAS FROM AUR REPOSITORY
paru -S --needed jmtpfs
paru -S --needed redshift-wayland-git
paru -S --needed grimblast-git
paru -S --needed hyprpicker
paru -S --needed swaylock-effects
paru -S --needed hyprprop-git

# INSTALLING -- TERMINAL PACKAGES
paru -S --needed tty-clock-git
paru -S --needed cava
paru -S --needed pipes.sh
paru -S --needed neo-matrix

# INSTALLING -- GUI PACKAGES
paru -S --needed nwg-look-bin
paru -S --needed brave-bin

# INSTALLING -- ROFI & ROFI-EMOJI
paru -S --needed rofi-lbonn-wayland-git
sudo pacman -S --needed rofi-emoji

# INSTALLING -- BLUETOOTH 
sudo pacman -S --needed bluez bluez-utils
paru -S --needed blueberry-wayland
sudo systemctl --now enable bluetooth

# INSTALLING -- LIBRE OFFICE 
sudo pacman -S --needed libreoffice-fresh hunspell hunspell-en_us

# INSTALLING -- VIRTUAL WINDOWS MANAGER
sudo pacman -S --needed qemu-base virt-manager libguestfs dnsmasq bridge-utils openbsd-netcat iptables
sudo systemctl enable libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default
sudo usermod -aG libvirt $(whoami)
newgrp libvirt
sudo nvim /etc/libvirt/libvirtd.conf     
unix_sock_group = "libvirt"      # -- UNCOMMENT THIS LINE
unix_sock_rw_perms = "0770"      # -- UNCOMMENT THIS LINE

# INSTALLING -- ZSH SHELL 
sudo pacman -S --needed zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
chsh -s $(which zsh)  -- FOR NORMAL USER
sudo su
chsh -s $(which zsh)  -- FOR ROOT USER

# INSTALLING -- GOOGLE FONTS 
sudo pacman -S --needed noto-fonts noto-fonts-emoji noto-fonts-cjk

# INSTALLING -- NECESSARY FONTS
sudo pacman -S --needed ttf-ubuntu-font-family inter-font ttf-carlito ttf-dejavu ttf-liberation

# INSTALLING -- ADOBE FONTS
sudo pacman -S --needed adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts

# INSTALLING -- ICONS-SYMBOLS FONTS
sudo pacman -S --needed ttf-monofur ttf-hanazono otf-font-awesome awesome-terminal-fonts powerline-fonts

# INSTALLING -- NERD FONTS
sudo pacman -S --needed ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd ttf-nerd-fonts-symbols

# REGENERATE FONTS CACHE
fc-cache -fv 
sudo fc-cache -fv

# POWER MANAGEMENT
sudo pacman -S --needed tlp
sudo systemctl enable --now tlp

# CREATING DIRECTORIES
mkdir -p ~/Videos
mkdir -p ~/Musics
mkdir -p ~/Pictures/Screenshots

# INSTALLING MPD & NCMPCPP
sudo pacman -S mpd ncmpcpp
systemctl --user enable mpd


                   # MANUAL CONFIG AND THEMEING #


# SET CONFIG ONE-BY-ONE

# SET GTK THEME

# SET ICONS THEME   
cd ~/Documents/Github/Personal-Dots/Root
sudo cp -r Breeze /usr/share/icons/

# SET CONFIG FOR ROOT - STARSHIP & NEOVIM
sudo su
cp -r Documents/Github/Personal-Dots/Root/.config /root/

# SET ZSH THEME FOR ROOT
sudo su
cp -r Documents/Github/Personal-Dots/Root/.zshrc /root/ 

# EDIT HYPRLAND.DESKTOP
sudo nvim /usr/share/wayland-sessions/hyprland.desktop   # --EDIT [ Name=Window Manager ]

# INSTALLING GRUB THEME
cd ~/Documents/Github/Personal-Dots/Themes/Grub-Theme
sudo ./Install.sh

# INSTALLING SDDM THEME
cd ~/Documents/Github/Personal-Dots/Themes/Login-Manager-Theme
./Install.sh

# HIDE VENTOY-EFI PARTITION 
lsblk -f  -- TO VIEW DISK LABEL
sudo nvim /etc/udev/rules.d/hide-ventoy.rules
KERNEL=="sdb2", ENV{UDISKS_IGNORE}="1"  # -- ADD IN FILE
sudo udevadm trigger

# EDIT MENU DESKTOP FILE

                   # IF NEEDED #


# CHANGE DNS SERVER
sudo nvim /etc/resolv.conf
-- ADD BELOW LINES
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 8.8.4.4

# INSTALLING VIRTUAL WINDOWS MANAGER
sudo pacman -S gnome-boxes
NOTE --INSTALL spice spice-gtk IN GUEST

# INSTALLING VIRTUAL BOX
sudo pacman -S virtualbox virtualbox-host-modules-arch
sudo usermod -aG vboxusers Bibhuti


                   # SOME IMPORTANT NOTES #


-- SUBLIME TEXT THEME = Gravity
-- MOSTLY CONFIG FILES ARE IN BASH SYNTAX 

-- VSCODE EXTENSIONS -- atommaterial.a-file-icon-vscode
-- VSCODE EXTENSIONS -- zhuangtongfa.material-theme 
-- VSCODE EXTENSIONS -- naumovs.color-highlight
-- VSCODE EXTENSIONS -- streetsidesoftware.code-spell-checker

-- WINDOWS TITLES: Noto Sans Regular 10

-- FIREFOX about:config -- devtools.accessibility.enabled False
-- FIREFOX about:config -- extensions.pocket.enabled False 
-- FIREFOX about:config -- identity.fxaccounts.enabled False
-- FIREFOX about:config -- browser.preferences.moreFromMozilla False   
-- FIREFOX about:config -- full-screen-api.warning.timeout 0


# NOT INSTALLED - FUTURE 
BLUEMAN
LF
SUBLIME-TEXT-4 
OS-PROBER
NAUTILUS
THUNAR 
THUNAR-VOLMAN 
THUNAR-ARCHIVE-PLUGIN 
OBSIDIAN 
PRAGHA 
DCONF-EDITOR 
NET-TOOLS 
INETUTILS
GOTOP-BIN
BTOP
LIBREOFFICE-EXTENSION-LANGUAGETOOL
QEMU-AUDIO-JACK 
QEMU-AUDIO-PA
TTF-MS-FONTS


# DONE CONFIG - FULLY
NEOVIM
GRUB-THEME
SDDM-THEME
KITTY
FIREFOX
PARU
SWAYIDLE
SWAYBG

# PROGRESS CONFIG - TO BE CONTINUED
HYPRLAND
PCMANFM     --ICONS ONLY
VISUAL STUDIO CODE



# ICONS CHANGE
MELD
PCMANFM
PINTA
CATFISH

# AFTER INSTALL
LIBMTP
LIBVA-INTEL-DRIVER
GTK-ENGINE-MURRINE
WIREPLUMBER
PIPEWIRE-AUDIO
GST-PLUGIN-PIPEWIRE


# FONT CONFIG  -- /etc/fonts/local.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<match>
		<edit mode="prepend" name="family">
			<string>Inter</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>serif</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Serif</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>sans-serif</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Sans</string>
		</edit>
	</match>
	<match target="pattern">
		<test qual="any" name="family">
			<string>monospace</string>
		</test>
		<edit name="family" mode="assign" binding="same">
			<string>Noto Mono</string>
		</edit>
	</match>
</fontconfig>


# MINITCPIO.CONF
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block filesystems fsck)


echo -e "QT_QPA_PLATFORMTHEME=qt5ct\nQT_QPA_PLATFORM=wayland\nQT_WAYLAND_DISABLE_WINDOWDECORATION=1\nQT_AUTO_SCREEN_SCALE_FACTOR=1\nMOZ_ENABLE_WAYLAND=1" | sudo tee -a /etc/environment


echo "KEYMAP=us" > /etc/vconsole.conf




usbutils

modprobe.blacklist=iTCO_wdt
