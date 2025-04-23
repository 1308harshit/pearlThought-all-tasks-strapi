#!/bin/bash
apt update -y
apt install -y curl git build-essential
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt install -y nodejs
npm install -g yarn
cd /home/ubuntu/
ufw allow 1337
ufw reload
npx create-strapi-app@latest strapi-app --quickstart --no-run
cd strapi-app
yarn build
yarn start &