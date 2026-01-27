#!/bin/bash

CUR_DIR=$(cd $(dirname $0); pwd)

cd $CUR_DIR/tomato-can2eth-doc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm alias default 20.11.1

nvm use 20.11.1

npm install

npm run build_github

cd $CUR_DIR

git config --global core.autocrlf true
git config --global user.name "tomato-ros"
git config --global user.email "smartros@foxmail.com"

git add -A .
git commit -m "update"
git push
