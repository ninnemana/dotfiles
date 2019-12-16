package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

var (
	symlinks = []string{
		".aliases",
		".bash_profile",
		".bash_prompt",
		".bashrc",
		".curlrc",
		".editorconfig",
		".exports",
		".functions",
		".gitattributes",
		".gitignore",
		".gitmodules",
		".gvimrc",
		".hgignore",
		".inputrc",
		".macos",
		".osx",
		".screenrc",
		".tmux.conf",
		".tmux.conf.local",
		".wgetrc",
		".zshrc",
	}
)

func main() {
	err := createSymlinks()
	if err != nil {
		log.Fatalf("%v\n", err)
	}
}

func createSymlinks() error {
	wd, err := os.Getwd()
	if err != nil {
		return err
	}

	for _, file := range symlinks {
		err = os.Symlink(filepath.Join(wd, file), fmt.Sprintf("$HOME/%s", file))
		if err != nil {
			log.Printf("[error] failed to set symlink: %v\n", err)
		}
	}

	cmd := exec.Command(
		"/usr/bin/ruby",
		"-e",
		"\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"",
	)

	var brewInstall bytes.Buffer
	cmd.Stdout = &brewInstall

	if err := cmd.Run(); err != nil {
		log.Printf("[error] failed to install Homebrew: %v\n", err)
	}

	fmt.Println(brewInstall.String())

	cmd = exec.Command("brew", "bundle")

	var caskInstall bytes.Buffer
	cmd.Stdout = &caskInstall

	if err := cmd.Run(); err != nil {
		log.Printf("[error] failed to install Homebrew taps and casks: %v\n", err)
	}

	fmt.Println(caskInstall.String())

	return nil
}
