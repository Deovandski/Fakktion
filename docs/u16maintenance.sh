#!/bin/bash
# u16maintenance.sh v1.5
# Ubuntu Server 16.04 maintenance

# Colors for Scrip Messages.
warn=$(tput setaf 5; tput bold; tput setab 0)
inform=$(tput setaf 6; tput bold; tput setab 0)
reset=$(tput sgr0)

# Error Detection
watchForErrors(){
  exitStatus="$1"
  step="$2"
  action="$3"
  if [ "$exitStatus" -eq 0 ]
  then
    echo "${inform}OK${reset} | $step"
  else
    echo "${warn}ERROR ${inform} $exitStatus ${reset} |$step"
    echo "${warn}$action${reset}"
    exit
  fi
}

surfaceUpdate(){
  deployingUser="$1"

  # Backup Section
  sudo service puma stop
  watchForErrors $? "Stop PUMA" ""
  mkdir /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Create Fakktion Backed up config" "Make sure that /home/"$deployingUser"/Fakktion_backup does not exist before trying again."
  cp /home/"$deployingUser"/Fakktion/config/database.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up database.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/secrets.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up secrets.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/puma.rb /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up puma.rb" ""

  # Git syncing
  cd .. || return
  git reset HEAD --hard
  watchForErrors $? "Sync to last commit" ""
  git pull origin ubuntu
  watchForErrors $? "Sync with remote ubuntu branch" ""

  # Restore Section
  cp /home/"$deployingUser"/Fakktion_backup/database.yml /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore database.yml" ""
  cp /home/"$deployingUser"/Fakktion_backup/secrets.yml /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore secrets.yml" ""
  cp /home/"$deployingUser"/Fakktion_backup/puma.rb /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore puma.rb" ""
  rm -rf  /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Delete Fakktion Backed up config" ""
  rake assets:precompile
  watchForErrors $? "Precompile Assets" ""
  sudo service puma start
  watchForErrors $? "Start PUMA" ""
}

deepUpdate(){
  deployingUser="$1"

  # Backup Section
  sudo service puma stop
  watchForErrors $? "Stop PUMA" ""
  mkdir /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Create Fakktion Backed up config" "Make sure that /home/"$deployingUser"/Fakktion_backup does not exist before trying again."
  cp /home/"$deployingUser"/Fakktion/config/database.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up database.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/secrets.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up secrets.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/puma.rb /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up puma.rb" ""

  # Git syncing
  cd .. || return
  git reset HEAD --hard
  watchForErrors $? "Sync to last commit" ""
  git pull origin ubuntu
  watchForErrors $? "Sync with remote ubuntu branch" ""

  # Restore Section
  bundle install
  watchForErrors $? "Bundle install new gemset" ""
  sudo bundle clean --force
  watchForErrors $? "Bundle clear old gemset" ""
  cd frontend || return
  rm -rf node_modules bower_components dist tmp
  watchForErrors $? "NPM and BOWER cache clear" ""
  sudo n stable
  watchForErrors $? "NODE install" ""
  npm install
  watchForErrors $? "NPM dependencies install" "install Fakktion NPM dependencies mannually"
  bower install
  watchForErrors $? "Bower dependencies install" "install Fakktion Bower dependencies mannually"
  cp /home/"$deployingUser"/Fakktion_backup/database.yml /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore database.yml" ""
  cp /home/"$deployingUser"/Fakktion_backup/secrets.yml /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore secrets.yml" ""
  cp /home/"$deployingUser"/Fakktion_backup/puma.rb /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore puma.rb" ""
  rm -rf  /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Delete Fakktion Backed up config" ""
  rake assets:precompile
  watchForErrors $? "Precompile Assets" ""
  sudo service puma start
  watchForErrors $? "Start PUMA" ""
}

backupConfig(){
  deployingUser="$1"
  # Backup Section
  sudo service puma stop
  watchForErrors $? "Stop PUMA" ""
  mkdir /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Create Fakktion Backed up config" "Make sure that /home/"$deployingUser"/Fakktion_backup does not exist before trying again."
  cp /home/"$deployingUser"/Fakktion/config/database.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up database.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/secrets.yml /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up secrets.yml" ""
  cp /home/"$deployingUser"/Fakktion/config/puma.rb /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up puma.rb" ""
  sudo cp /etc/nginx/sites-available/default /home/"$deployingUser"/Fakktion_backup
  watchForErrors $? "Back up NGINX config" ""
}

restoreDBConfig(){
  deployingUser="$1"
  cp /home/"$deployingUser"/Fakktion_backup/database.yml /home/"$deployingUser"/Fakktion/config
  watchForErrors $? "Restore database.yml" ""
}

restoreOtherConfig(){
  deployingUser="$1"
  # Restore PUMA?
  if [ "$2" = "y" ] || [ "$2" = "yes" ]
  then
    cp /home/"$deployingUser"/Fakktion_backup/puma.rb /home/"$deployingUser"/Fakktion/config
    watchForErrors $? "Restore puma.rb" ""
  else
    echo "skipped restoring PUMA"
  fi

  # Restore Previous Secrets?
  if [ "$2" = "y" ] || [ "$2" = "yes" ]
  then
    cp /home/"$deployingUser"/Fakktion_backup/secrets.yml /home/"$deployingUser"/Fakktion/config
    watchForErrors $? "Restore secrets.yml" ""
  else
    echo "skipped restoring previous secrets"
  fi
  sudo cp /home/"$deployingUser"/Fakktion_backup/default /etc/nginx/sites-available/default
  watchForErrors $? "Restore NGINX config" ""
}

if [ $# -eq 0 ]
then
  echo "${warn}No arguments provided. See Below for Usage according to each step:${reset}"
  echo "1 User"
  echo "2 User"
else
  if [ "$1" = 1 ]
  then
    if [ $# -eq 1 ]
    then
      if [ "$(whoami)" != "root" ];
      then
        surfaceUpdate "$(whoami)"
      else
        echo "${warn}Running as sudo... Please remove it from the call and try again.${reset}"
      fi
    else
      echo "${warn}Incorrect # of arguments...${reset}"
      echo "Usage: Step"
      echo "Example: 1"
    fi
  elif [ "$1" = 2 ]
  then
    if [ $# -eq 1 ]
    then
      deepUpdate "$(whoami)"
    else
      echo "${warn}Incorrect # of arguments...${reset}"
      echo "Usage: Step"
      echo "Example: 2"
    fi
  elif [ "$1" = 3 ]
  then
    if [ $# -eq 1 ]
    then
      if [ "$(whoami)" != "root" ];
      then
        backupConfig "$(whoami)"
      else
        echo "${warn}Running as sudo... Please remove it from the call and try again.${reset}"
      fi
    else
      echo "${warn}Incorrect # of arguments...${reset}"
      echo "Usage: Step"
      echo "Example: 3"
    fi
  elif [ "$1" = 4 ]
  then
    if [ $# -eq 1 ]
    then
      if [ "$(whoami)" != "root" ];
      then
        restoreDBConfig "$(whoami)"
      else
        echo "${warn}Running as sudo... Please remove it from the call and try again.${reset}"
      fi
    else
      echo "${warn}Incorrect # of arguments...${reset}"
      echo "Usage: Step"
      echo "Example: 4"
    fi
  elif [ "$1" = 5 ]
  then
    if [ $# -eq 3 ]
    then
      if [ "$(whoami)" != "root" ];
      then
        restoreOtherConfig "$(whoami)" "$2" "$3"
      else
        echo "${warn}Running as sudo... Please remove it from the call and try again.${reset}"
      fi
    else
      echo "${warn}Incorrect # of arguments...${reset}"
      echo "Usage: Step restorePuma? restorePreviousSecrets?"
      echo "Example: 5 y y"
    fi
  fi
fi
