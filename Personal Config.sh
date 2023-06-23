
# UPDATE SYSTEM CLOCK
timedatectl set-ntp true       
timedatectl status             

# CONNECT TO INTERNET
iwctl                              
station wlan0 show                 
station wlan0 connect Redmi K50i   
exit                               

# DISK PARTITION FOR UEFI
fdisk -l
fdisk /dev/sda
n = New Partition
SIMPLY PRESS ENTER = 1st Partition
SIMPLY PRESS ENTER = As First Sector
+512M = As Last Sector (Boot Partition)
t = Partition StYle
1 = For EFI Partition Table

# AGAIN
n = New Partition 
SIMPLY PRESS ENTER = 2nd Partition
SIMPLY PRESS ENTER = As First Sector 
SIMPLY PRESS ENTER = As Last sector (ROOT Partition Of Remaining Space)
p = Print Partition Configuration 
w = Write & Exit

# FORMATTING PARTITIONS
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# MOUNTING ROOT PARTITION
mount /dev/sda2 /mnt

# INSTALLING BASE SYSTEM 
pacstrap -Ki /mnt base base-devel linux linux-firmware linux-headers intel-ucode

# GENERATING FSTAB
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# CHROOT
arch-chroot /mnt

# INSTALLING EDITOR 
pacman -Sy neovim

# SET TIME & DATE
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# SET LANGUAGE & GENERATE LOCALE
nvim /etc/locale.gen                     # --UNCOMMENT en_US.UTF-8 UTF-8
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen

# SET HOSTNAME
echo iTunes > /etc/hostname

# SET HOST
nvim /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    iTunes.localdomain iTunes

# SET ROOT PASSWORD
passwd      # --SET ROOT PASSWORD

# ADD USER ACCOUNT & PASSWORD
useradd -m Bibhuti
passwd Bibhuti      
usermod -aG wheel,audio,video,optical,storage,disk,network Bibhuti

# CONFIGURING SUDOERS
EDITOR=nvim visudo      # --UNCOMMENT %wheel ALL=(ALL) ALL

# CREATE SWAP FILE 
dd if=/dev/zero of=/swapfile bs=1M count=8192 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
cat /etc/fstab
Free -m

# ONFIGURING PACMAN
nvim /etc/pacman.conf   # --UNCOMMENT Color ParallelDownloads Multilib & ADD ILoveCandy
pacman -Syu

# CONFIGURING GRUB
pacman -Sy grub efibootmgr       # --IF NEEDED dosfstools mtools os-prober
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=ARCH --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# CONFIGURING NETWORK MANAGER
pacman -S networkmanager
systemctl enable NetworkManager

# FINAL STEPS
exit
unmount -a
poweroff


                   # POST INSTALLATION ARCH LINUX #


# RECONNECTING NETWORK
sudo nmtui

# CHECK FOR UPDATES & GIT INSTALL
sudo pacman -Syu
sudo pacman -S --needed git

# CLONING INSTALLER-SCRIPTS REPO
mkdir -p Downloads/Repos
cd Downloads/Repos
git clone https://github.com/Bibhuti1221Bhushan/Installer-Scripts.git
cd Installer-Scripts
chmod +x *
./Aur-Install
./Firmware-Install
./Cutee-Install
./Installer


                   # MANUAL POST INSTALLATION ARCH LINUX #


# RECONNECTING NETWORK
sudo nmtui

# CHECK FOR UPDATES
sudo pacman -Syu

# INSTALLING AUDIO --NEEDED PIPEWIRE
sudo pacman -Sy --needed pipewire pipewire-jack pipewire-pulse pipewire-alsa pavucontrol
systemctl --user --now enable pipewire pipewire-pulse wireplumber

# INSTALLING FROM ARCH REPOSITORY --NEEDED FOR HYPRLAND
sudo pacman -S --needed hyprland xdg-desktop-portal-hyprland
sudo pacman -S --needed wl-clipboard wtype slurp dialog

sudo pacman -S --needed kitty firefox pcmanfm-gtk3

# INTSALLING GIT & AUR HELPER (YAY)
sudo pacman -S git
mkdir -p Downloads/Repos
cd Downloads/Repos
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf yay-bin

# INSTALLING SDDM LOG IN MANAGER
yay -S sddm-git
sudo systemctl enable sddm.service

# INSTALLING MISSING DRIVERS
yay -S --needed aic94xx-firmware wd719x-firmware ast-firmware upd72020x-fw
sudo pacman -S --needed linux-firmware-qlogic

# INSTALLING FROM AUR REPOSITORY --NEEDED FOR HYPRLAND 
yay -S --needed xfce-polkit 
yay -S --needed waybar-hyprland 
yay -S --needed sublime-text-4

# BOOT IN TO WINDOW MANAGER
sudo reboot --r now


                   # MANUAL POST INSTALLATION OF HYPRLAND WINDOWS MANAGER #


# COPING MY KEYBINDINGS
COPY HYPRLAND.CONF --$HOME/.config/hypr/
sudo reboot

# INSTALLING -- NEEDED FOR QT THEME ENGINE
sudo pacman -S --needed qt5-wayland kvantum qt5ct qt6ct qt6-tools qt5-quickcontrols2 qt5-graphicaleffects
echo -e "QT_QPA_PLATFORMTHEME=qt5ct\nQT_QPA_PLATFORMTHEME=qt6ct\nQT_QPA_PLATFORM=wayland\nQT_WAYLAND_DISABLE_WINDOWDECORATION=1\nQT_AUTO_SCREEN_SCALE_FACTOR=1\nMOZ_ENABLE_WAYLAND=1" | sudo tee -a /etc/environment

# INSTALLING EXTRAS FROM ARCH REPOSITORY
sudo pacman -S --needed dunst brightnessctl pamixer imv mpv imagemagick swaybg swayidle file-roller p7zip gvfs-mtp mtpfs gvfs-gphoto2 gvfs-afc gvfs-nfs ntfs-3g ffmpegthumbnailer tumbler mesa-utils intel-media-driver
sudo pacman -S --needed gnome-disk-utility gnome-calculator meld obsidian network-manager-applet evince
sudo pacman -S --needed btop cmatrix bat exa ranger python-pillow neofetch starship cliphist wget python-pip python-requests
sudo pacman -S --needed man-db man-pages pacman-contrib   
  
# IF NEEDED -- thunar thunar-volman thunar-archive-plugin nautilus
# IF NEEDED -- dconf-editor net-tools inetutils

# INSTALLING EXTRAS FROM AUR REPOSITORY
yay -S --needed redshift-wayland-git nwg-look-bin rofi-lbonn-wayland-git grimblast-git hyprpicker-git swaylock-effects jmtpfs hyprprop-git
yay -S --needed tty-clock-git cava brave-bin pipes.sh

sudo pacman -S rofi-emoji

# INSTALLING BLUETOOTH 
sudo pacman -S --needed bluez bluez-utils blueman
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# INSTALLING LIBREOFFICE & STUFF
sudo pacman -S --needed libreoffice-fresh hunspell hunspell-en_us
yay -S libreoffice-extension-languagetool    

# INSTALLING VIRTUAL WINDOWS MANAGER
sudo pacman -S --needed qemu-base virt-manager dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default
sudo usermod -aG libvirt $(whoami)
newgrp libvirt
sudo nvim /etc/libvirt/libvirtd.conf     
unix_sock_group = "libvirt"       --UNCOMMENT
unix_sock_rw_perms = "0770"       --UNCOMMENT

# INSTALLING ZSH SHELL 
sudo pacman -S zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
chsh -s (which zsh)

# INSTALLING ARCH FONTS 
sudo pacman -S sudo pacman -S --needed adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-ubuntu-font-family otf-font-awesome ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd ttf-joypixels ttf-nerd-fonts-symbols-common ttf-liberation ttf-monofur ttf-dejavu powerline-fonts
yay -S --needed ttf-meslo-nerd-font-powerlevel10k ttf-material-design-icons otf-bebas-neue-git

IF NEEDED NERD-FONTS -- ttf-hack-nerd otf-cascadia-code-nerd ttf-mononoki-nerd ttf-terminus-nerd
IF NEEDED AUR -- ttf-ms-fonts

# REGENERATE FONTS CACHE
fc-cache -fv 
sudo fc-cache -fv

                   # MANUAL CONFIG AND THEMEING #


# INSTALLING GTK THEME
yay -S pop-gtk-theme

# INSTALLING ICONS THEME
sudo pacman -S papirus-icon-theme       

# SET .CONFIG FILE
COPY .CONFIG >> $HOME

# INSTALLING GRUB THEME
cd Grub-Themes
sudo ./install.sh

# INSTALLING SDDM THEME
cd Login-Manager-Themes
./Install.sh

                   # IF NEEDED #


# INSTALLING VIRTUAL WINDOWS MANAGER
sudo pacman -S gnome-boxes
NOTE --INSTALL spice spice-gtk IN GUEST

# INSTALLING MPD & NCMPCPP
sudo pacman -S mpd ncmpcpp
systemctl enable mpd

# INSTALLING VIRTUAL BOX
sudo pacman -S virtualbox virtualbox-host-modules-arch
sudo usermod -aG vboxusers Bibhuti


                   # SOME IMPORTANT NOTES #


-- SUBLIME TEXT THEME = Gravity
-- MOSTLY CONFIG FILES ARE IN BASH SYNTAX 
-- VSCODE EXTENSIONS -- atommaterial.a-file-icon-vscode zhuangtongfa.material-theme naumovs.color-highlight
-- VSCODE KEYBINDS -- uppercase CTRL+K,CTRL+U lowercase CTRL+U,CTRL+K
-- WINDOWS TITLES: Noto Sans Regular 10
-- FIREFOX about:config -- devtools.accessibility.enabled False
-- FIREFOX about:config -- extensions.pocket.enabled False 
-- FIREFOX about:config -- identity.fxaccounts.enabled False
-- FIREFOX about:config -- browser.preferences.moreFromMozilla False   
-- FIREFOX about:config -- full-screen-api.warning.timeout 0






# DONE EVERYTHING
GRUB-THEMES
SDDM-THEMES
CURSOR

# DONE SLOWLY
WAYBAR
HYPRLAND
ZSHENV
ZSHRC
BASHRC
NERD-FONTS
STARSHIP
ROFI LAUNCHER
ROFI POWERMENU
ROFI CLIPBOARD
ROFI EMOJI
ROFI-BEATS
DUNST 
VSCODE
SUBLIME TEXT 4
KITTY 
NEOFETCH 
RANGER
NEOVIM
MPV
HTOP
BTOP
NEO-MATRIX
SWAYLOCK

# EDITING
MPD
NCMPCPP

# EXCLUDE FROM AUTO INSTALLER SCRIPTS
ranger
tlp
meld
unix_sock_group = "libvirt"        /etc/libvirt/libvirtd.conf
unix_sock_rw_perms = "0770"
