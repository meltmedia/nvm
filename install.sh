#!/bin/bash

NVM_TARGET="$HOME/.nvm"

if [ -d "$NVM_TARGET" ]; then
  echo "=> NVM is already installed in $NVM_TARGET, trying to update"
  echo -ne "\r=> "
  cd $NVM_TARGET && git pull
  exit
fi

# Cloning to $NVM_TARGET
git clone git://github.com/meltmedia/nvm.git $NVM_TARGET

echo 

# Detect profile file, .bash_profile has precedence over .profile
# Detect specified version either as first argument or as second
#   if a profile is also specified
if [ ! -z "$1" ] && [ ${1:0:1} != "v" ]; then
  PROFILE="$1"

  if [ ! -z "$2" ] && [ ${2:0:1} == "v" ]; then
    VERSION=$2
  fi
else
  if [ -f "$HOME/.bash_profile" ]; then
  PROFILE="$HOME/.bash_profile"
  elif [ -f "$HOME/.profile" ]; then
  PROFILE="$HOME/.profile"
  fi
fi

if [ ! -z "$1" ] && [ ${1:0:1} == "v" ]; then
  VERSION=$1
fi

SOURCE_STR="[[ -s "$NVM_TARGET/nvm.sh" ]] && . "$NVM_TARGET/nvm.sh"  # This loads NVM"

if [ -z "$PROFILE" ] || [ ! -f "$PROFILE" ] ; then
  if [ -z $PROFILE ]; then 
	echo "=> Profile not found"
  else
	echo "=> Profile $PROFILE not found"
  fi
  echo "=> Append the following line to the correct file yourself"
  echo
  echo -e "\t$SOURCE_STR"
  echo  
  echo "=> Close and reopen your terminal to start using NVM"
  exit
fi

if ! grep -qc 'nvm.sh' $PROFILE; then
  echo "=> Appending source string to $PROFILE"
  echo $SOURCE_STR >> "$PROFILE"
  source "$NVM_TARGET/nvm.sh"
else
  echo "=> Source string already in $PROFILE"
fi

if [ -z "$VERSION" ]; then
  echo "=> Installing $VERSION as default"
  nvm install $VERSION
  nvm alias default $VERSION
fi
