#!/usr/bin/bash

./dotdrop.sh update -f


# clean passwords and tokens
sed -i 's/export GITHUB_TOKEN=.*/export GITHUB_TOKEN=GITTOKENHERE/' dotfiles/zshrc

sed -i 's/password = pypi-.*/password = pypi-PYPITOKEN/' dotfiles/pypirc


rm -rf dotfiles/config/obs-studio/basic/profiles/Untitled/service.json
touch dotfiles/config/obs-studio/basic/profiles/Untitled/service.json
rm -rf dotfiles/config/obs-studio/profiler_data/*
rm -rf dotfiles/config/obs-studio/logs/*


git add dotfiles
git commit -m "Update dotfiles"

# Gitleaks
gitleaks detect --source dotfiles -v
