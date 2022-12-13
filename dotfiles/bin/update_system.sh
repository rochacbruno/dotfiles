echo "Updating keyring"
sudo pacman -S archlinux-keyring
echo "DONE keyring update"
echo "-------------"
echo "mirrors cache"
sudo pacman -Syy
echo "Pacman update"
sudo pacman -Syu --noconfirm --needed --overwrite '*'
echo "DONE pacman update"
echo "-------------"
echo "Yay update"
yay
echo "DONE yay update"
echo "-------------"
echo "Grub install"
sudo grub-install
echo "OHH YEAHH IT IS GREAT"
