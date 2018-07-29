#!/bin/bash

# First get oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


# Then get some keys for us to use for git
wget https://s3.us-east-2.amazonaws.com/jsck-deploy-keys/dfiledep -O $HOME/.ssh/dotfilepull

echo "Host github.com\n HostName github.com\n IdentityFile ~/.ssh/dotfilepull" >> $HOME/.ssh/config


# Pull down dotfiles
git clone --bare git@github.com:OneMoreByte/Datfiles.git $HOME/.cfg

function gdt {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
gdt checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  gdt checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
gdt checkout
gdt config status.showUntrackedFiles no

