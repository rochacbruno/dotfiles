cp ~/.bashrc .
cp ~/.zshrc .
cp ~/.profile .
cp ~/.gitconfig .
cp ~/.gitignore .
cp ~/.gtkrc-2.0 .
cp ~/.Xresources .

cp -R  ~/.i3 .

# Config

cp  ~/.config/nvim/init.vim .config/nvim/
cp ~/.config/starship.toml .config/
cp ~/.config/pavucontrol.ini .config/

cp -R  ~/.config/nu .config/
cp -R  ~/.config/key-mon .config/

# Micro
cp -R  ~/.config/micro .config/
rm -rf .config/micro/plug/
rm -rf .config/micro/README.md
rm -rf .config/micro/backups/
rm -rf .config/micro/buffers/

cp -R  ~/.config/rofi .config/
cp -R  ~/.config/clipit .config/

# Tilix
cp -R ~/.config/tilix .config/
dconf dump /com/gexperts/Tilix/ > .config/tilix/tilix.dconf


# Arandr
cp -R ~/.screenlayout .

# Packages 
pacman -Qe > pacman_installed.txt
pacman -Q > pacman_all.txt
pip freeze > pip_install.txt
cargo install --list > cargo_install.txt
npm list -g --depth=0 > npm_install.txt
