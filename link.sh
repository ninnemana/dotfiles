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
		"alacritty.toml"
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
		"zprofile"
                )

for f in "${links[@]}"
do
   ln -s /Users/ninnemana/code/dotfiles/.${f} /Users/ninnemana/.${f}
done

mkdir -p /Users/ninnemana/.config/ghostty
ln -s /Users/ninnemana/code/dotfiles/ghostty/config /Users/ninnemana/.config/ghostty/config

touch $HOME/.z

