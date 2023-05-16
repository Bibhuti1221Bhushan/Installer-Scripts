
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

# CHECK FOR UPDATES
sudo pacman -Syu

# INSTALLING AUDIO --NEEDED PIPEWIRE
sudo pacman -S pipewire pipewire-jack pipewire-pulse pipewire-alsa pavucontrol
systemctl --user enable pipewire.service pipewire-pulse.service

# INSTALLING FROM ARCH REPOSITORY --NEEDED FOR HYPRLAND
sudo pacman -S hyprland xdg-desktop-portal-hyprland
sudo pacman -S wl-clipboard wtype slurp dialog

sudo pacman -S kitty firefox pcmanfm-gtk3

# INTSALLING GIT & AUR HELPER (YAY)
sudo pacman -S git
mkdir Downloads/Repos
cd Downloads/Repos
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf yay-bin

# INSTALLING SDDM LOG IN MANAGER
yay -S sddm-git
sudo systemctl enable sddm.service

# INSTALLING FROM AUR REPOSITORY --NEEDED FOR HYPRLAND 
yay -S xfce-polkit 
yay -S waybar-hyprland 
yay -S sublime-text-4

# BOOT IN TO WINDOW MANAGER
sudo reboot --r now


                   # POST INSTALLATION OF HYPRLAND WINDOWS MANAGER #


# COPING MY KEYBINDINGS
COPY HYPRLAND.CONF --$HOME/.config/hypr/
sudo reboot

# INSTALLING -- NEEDED FOR QT THEME ENGINE
sudo pacman -S qt5-wayland kvantum qt5ct qt6ct qt6-tools qt5-quickcontrols2 qt5-graphicaleffects

# INSTALLING EXTRAS FROM ARCH REPOSITORY
sudo pacman -S dunst brightnessctl pamixer imv mpv imagemagick swaybg swayidle file-roller p7zip gvfs-mtp mtpfs gvfs-gphoto2 gvfs-afc gvfs-nfs ntfs-3g ffmpegthumbnailer tumbler mesa-utils intel-media-driver
sudo pacman -S gnome-disk-utility gnome-calculator meld obsidian network-manager-applet
sudo pacman -S btop cmatrix bat exa ranger neofetch starship cliphist wget  
sudo pacman -S man-db man-pages pacman-contrib   
  
# IF NEEDED -- thunar thunar-volman thunar-archive-plugin nautilus
# IF NEEDED -- dconf-editor net-tools inetutils

# INSTALLING EXTRAS FROM AUR REPOSITORY
yay -S redshift-wayland-git nwg-look-bin rofi-lbonn-wayland-git grimblast-git hyprpicker-git swaylock-effects jmtpfs hyprprop-git
yay -S tty-clock-git cava 

sudo pacman -S rofi-emoji

# INSTALLING BLUETOOTH 
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# INSTALLING LIBREOFFICE & STUFF
sudo pacman -S libreoffice-fresh
yay -S libreoffice-extension-languagetool    

# INSTALLING VIRTUAL WINDOWS MANAGER
sudo pacman -S virt-manager qemu-desktop dnsmasq bridge-utils
IF NEEDED -- iptables-nft 
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default

# INSTALLING ZSH SHELL 
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# INSTALLING DT COLOR SCRIPT
COPY COLOR-SCRIPT .CONFIG

# CONFIGURING ZSH & STARSHIP PROMPT
COPY PERSONAL .ZSHENV FILE
COPY PERSONAL ZSH CONFIG FILES
COPY PERSONAL STARSHIP.TOML

# INSTALLING PIPES TERMINAL SIMULATION
cd Downloads/Repos
git clone https://github.com/pipeseroni/pipes.sh.git 
cd pipes.sh
sudo make install
cd ..
rm -rf pipes.sh

# INSTALLING ARCH FONTS 
sudo pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra ttf-ubuntu-font-family adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts ttf-roboto
sudo pacman -S otf-font-awesome ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd 

IF NEEDED NERD-FONTS -- ttf-hack-nerd otf-cascadia-code-nerd ttf-mononoki-nerd ttf-terminus-nerd
IF NEEDED AUR -- ttf-ms-fonts

# REGENERATE FONTS CACHE
fc-cache -rv 
sudo fc-cache -rv

# INSTALLING GTK THEME
yay -S pop-gtk-theme

# INSTALLING CURSOR THEME
COPY .ICONS FOLDER >> ~$HOME

# INSTALLING ICONS THEME
sudo pacman -S papirus-icon-theme       

# SET .CONFIG FILE
COPY .CONFIG >> $HOME

# INSTALLING GRUB THEME
cd Grub-Themes
sudo ./install.sh

# INSTALLING SDDM THEME
cd Downloads/Repos
git clone https://github.com/aczw/sddm-theme-corners 
cd sddm-theme-corners
-- # RENAME corners >> Corners
-- # ADD LOCKSCREEN WALLPAPERS >> ~/Corners/backgrounds
-- # EDIT theme.conf --CHANGE Background --REMOVE DATE & TIME
sudo cp -r Corners/ /usr/share/sddm/themes/
-- # CHANGE USER ICONS
sudo cp -r .face.icon root.face.icon /usr/share/sddm/faces 
-- # SET THEME >> CONFIG FILE
cd /usr/lib/sddm/sddm.conf.d/
sudo nvim default.conf   (EDIT Theme Name = Corners)



# INSTALLING VIRTUAL WINDOWS MANAGER
sudo pacman -S gnome-boxes
NOTE --INSTALL spice spice-gtk IN GUEST

# INSTALLING VIRTUAL BOX
sudo pacman -S virtualbox virtualbox-host-modules-arch
sudo usermod -aG vboxusers Bibhuti



                   # SOME IMPORTANT NOTES #
-- SUBLIME TEXT THEME = Gravity One
-- MOSTLY CONFIG FILES ARE IN BASH SYNTAX 
-- MUST CREATE Pictures/Screenshots NEEDED BY SCREENSHOT TOOLS
-- VSCODE EXTENSIONS -- atommaterial.a-file-icon-vscode zhuangtongfa.material-theme naumovs.color-highlight
-- WINDOWS TITLES: Noto Sans Regular 10







# DONE
GRUB-THEMES
CURSOR
ZSHENV
ZSHRC
BASHRC
NERD-FONTS
HYPRLAND
STARSHIP
SDDM-THEMES
ROFI LAUNCHER


# EDITING
ROFI-BEATS
LOCKSCREEN  --SCRIPTS 
WAYBAR BRIGHTNESS ICONS + TOOLTIPS