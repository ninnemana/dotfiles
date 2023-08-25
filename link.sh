#!/bin/bash

declare -a links=("bash_profile" 
                "tmux.conf.local"
		"aliases"
		"functions"
		"editorconfig"
		"screenrc"
		"wgetrc"
		"inputrc"
		"curlrc"
		"gitmodules"
		"alacritty.yml"
		"bash_prompt"
		"gitattributes"
		"gvimrc"
		"bashrc"
		"macos"
		"tmux.conf"
		"zshrc"
		"oh-my-zsh"
		"exports"
		"gitignore"
		"hgignore"
                )

for f in "${links[@]}"
do
   ln -s /Users/alexninneman/code/dotfiles/.${f} /Users/alexninneman/.${f}
done