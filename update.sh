cp ~/.bashrc .
cp ~/.zshrc .
cp ~/.profile .
cp ~/.gitconfig .
cp ~/.gitignore .
cp ~/.gtkrc-2.0 .
cp ~/.Xresources .


cp -R  ~/.i3 .

cp -R /usr/lib/python3.9/sitecustomize.py .

# Tmux

# Only needs local, everything else is in https://github.com/gpakosz/.tmux.git
#cp -R ~/.tmux .
#cp -R ~/.tmux.conf .

cp -R ~/.tmux.conf.local .

cp -R ~/.themes .
rm -rf .themes/gruvbox-gtk/.git
cp -R ~/.icons .
rm -rf .icons/gruvbox-dark-icons-gtk/.git

# Config

cp  ~/.config/nvim/init.vim .config/nvim/
cp  ~/.vim/coc-settings.json .config/.vim/
cp ~/.config/starship.toml .config/
cp ~/.config/pavucontrol.ini .config/

cp -R  ~/.config/pet .config/
sed -i 's/access_token =.*/access_token = GITHUB_API_KEY_HERE/' .config/pet/config.toml

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
cp -R  ~/.config/dunst .config/

# Tilix
cp -R ~/.config/tilix .config/
dconf dump /com/gexperts/Tilix/ > .config/tilix/tilix.dconf

# Terminator
cp -R ~/.config/terminator .config/

# Alacritty
cp -R ~/.config/alacritty .config/

# wtfutil
cp -R ~/.config/wtf/config.yml .config/wtf/config.yml
sed -i 's/apiKey:.*/apiKey: GITHUB_API_KEY_HERE/' .config/wtf/config.yml

# Arandr
cp -R ~/.screenlayout .

# bins
cp -R ~/bin/battery ./bin
cp -R ~/bin/allcolors ./bin
cp -R ~/bin/update_now_playing ./bin
cp -R ~/bin/galaxy ./bin
cp -R ~/bin/galaxy_shell ./bin
cp -R ~/bin/set_windows ./bin
cp -R ~/bin/streamtimer ./bin
cp -R ~/bin/portugal ./bin
cp -R ~/bin/brtime ./bin
cp -R ~/bin/ustime ./bin

# Packages
pacman -Qe > pacman_installed.txt
pacman -Q > pacman_all.txt
pip freeze > pip_install.txt
cargo install --list > cargo_install.txt
npm list -g --depth=0 > npm_install.txt
