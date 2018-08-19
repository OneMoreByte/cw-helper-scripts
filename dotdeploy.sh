#!/bin/bash

# First get oh-my-zsh if we haven't
if [ ! -d $HOME/.oh-my-zsh ]; then
        sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
else
        echo "Oh my ZSH is already installed!"
fi

# Then get some keys for us to use for git
wget https://gist.githubusercontent.com/OneMoreByte/4f421559b4817f7798ccbdd4dd0002fb/raw/3a8709949d8b8358312ce3950a9dc0be69e85cd6/dfiledep -O $HOME/.ssh/dotfilepull

chmod 700 $HOME/.ssh/dotfilepull

echo "Host github.com
 HostName github.com
 IdentityFile ~/.ssh/dotfilepull" > $HOME/.ssh/config


# Pull down dotfiles
git clone --bare git@github.com:OneMoreByte/Datfiles.git $HOME/.cfg

function gdt {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p $HOME/.home-bak
gdt checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  gdt checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.config-backup/{}
fi;
gdt checkout
gdt config status.showUntrackedFiles no

