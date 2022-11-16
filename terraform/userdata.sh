#!/bin/bash

  #Install webserver for reverse proxy
  apt-get update
  apt-get install -y nginx
  
  #Install docker
  apt-get install ca-certificates curl gnupg lsb-release -y
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

  #Install node
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  command -v nvm
  nvm install --lts
  npm install -g yarn

  #Clone repository
  git clone https://github.com/CareerFoundry-Engineering/practicum-devops.git
  
  #Deploy API
  cd practicum-devops/api
  make build
  make up &> /var/log/careerfoundry.log &
  make prepare

  #Deploy frontend
  cd ../learning
  yarn
  yarn build
  cp -rvf dist/* /var/www/html/

  #Reload nginx
  systemctl restart nginx.service