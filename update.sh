#!/usr/bin/bash

./dotdrop.sh update -f


# clean passwords and tokens
sed -i 's/export GITHUB_TOKEN=.*/export GITHUB_TOKEN=GITTOKENHERE/' dotfiles/zshrc
sed -i 's/export GITHUB_TOKEN=.*/export GITHUB_TOKEN=GITTOKENHERE/' dotfiles/bashrc

sed -i 's/password = pypi-.*/password = pypi-PYPITOKEN/' dotfiles/pypirc


# remove unwanted files
rm -rf dotfiles/config/obs-studio/basic/profiles/Untitled/service.json
touch dotfiles/config/obs-studio/basic/profiles/Untitled/service.json

rm -rf dotfiles/config/obs-studio/basic/profiles/2024/service.json
touch dotfiles/config/obs-studio/basic/profiles/2024/service.json

rm -rf dotfiles/config/obs-studio/basic/profiles/default/service.json
touch dotfiles/config/obs-studio/basic/profiles/default/service.json

# Packages
pacman -Qe > pacman_installed.txt
pacman -Qm > pacman_manually.txt
pacman -Q > pacman_all.txt
cargo install --list > cargo_install.txt
micro -plugin list > micro_plugins.txt
code --list-extensions | xargs -L 1 echo code --install-extension > code_extensions.txt
/usr/bin/python -m pip freeze > "system_python$(python -V).txt"

# Commit
git add dotfiles
git commit -m "Update dotfiles"

# Gitleaks
gitleaks detect --source dotfiles -v
