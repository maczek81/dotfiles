#!/usr/bin/env bash

DOTFILES=`pwd`

# Colors
ESC_SEQ="\x1b["
RESET=$ESC_SEQ"39;49;00m"
RED=$ESC_SEQ"31;01m"
GREEN=$ESC_SEQ"32;01m"
YELLOW=$ESC_SEQ"33;01m"
BLUE=$ESC_SEQ"34;01m"
MAGENTA=$ESC_SEQ"35;01m"
CYAN=$ESC_SEQ"36;01m"

install_git () {
    echo -e "${BLUE}Installing git${RESET}"

    USER_NAME=`git config --global user.name`
    if [ "$USER_NAME" = "" ]; then
        read -e -p "Your name: " USER_NAME
    fi

    USER_EMAIL=`git config --global user.email`
    if [ "$USER_EMAIL" = "" ]; then
        read -e -p "Your email: " USER_EMAIL
    fi

    CONFIG=$HOME/.gitconfig
    cp .gitconfig $CONFIG
    sed -i.bak s/%USER_NAME%/"$USER_NAME"/g $CONFIG
    sed -i.bak s/%USER_EMAIL%/"$USER_EMAIL"/g $CONFIG
    
    rm "${CONFIG}.bak"
}

install_screen () {
   echo -e "${BLUE}Installing screen${RESET}"
   ln -sf $DOTFILES/.screenrc $HOME/.screenrc
}

install_vim () {
   echo -e "${BLUE}Installing vim${RESET}"
   ln -sf $DOTFILES/.vimrc $HOME/.vimrc
}

install_ohmyzsh () {
    ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
    if [ ! $ZSH_INSTALLED -ge 1 ]; then
        echo -e "${YELLOW}Zsh is not installed!${RESET} Please install zsh first!"
        exit
    fi
    if [ ! -d $HOME/.oh-my-zsh ]; then
        echo -e "${YELLOW}Please install oh-my-zsh first!${RESET}"
        exit
    fi
    ln -sf $DOTFILES/.zshrc $HOME/.zshrc
}

install () {
   install_git
   install_screen 
   install_vim
   install_ohmyzsh
   echo -e "${GREEN}Done${RESET}"
}

echo "Do you wish to install dotfiles?"
echo -e "${RED}Warning: This may override dotfiles existing in your $HOME directory!${RESET}"
read -p "(Y/n): "  RESP
if [ "$RESP" = "Y" ]; then
    install
fi    

