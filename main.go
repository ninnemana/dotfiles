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

	home = os.Getenv("HOME")
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
		_ = os.Remove(fmt.Sprintf("%s/%s", home, file))

		err = os.Symlink(filepath.Join(wd, file), fmt.Sprintf("%s/%s", home, file))
		if err != nil {
			fmt.Printf("[error] failed to set symlink: %v\n", err)
		}
	}

	fmt.Println("[success] finished symlinks")

	macSource := home + "/.macos"

	cmd := exec.Command("source", macSource)

	var source bytes.Buffer
	cmd.Stdout = &source

	if err := cmd.Run(); err != nil {
		fmt.Printf("[error] failed to source .macos: %v\n", err)
	}

	fmt.Println(source.String())

	cmd = exec.Command(
		"/usr/bin/ruby",
		"-e",
		"\"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"",
	)

	var brewInstall bytes.Buffer
	cmd.Stdout = &brewInstall

	if err := cmd.Run(); err != nil {
		fmt.Printf("[error] failed to install Homebrew: %v\n", err)
	}

	fmt.Println(brewInstall.String())

	cmd = exec.Command("brew", "bundle")

	var caskInstall bytes.Buffer
	cmd.Stdout = &caskInstall

	if err := cmd.Run(); err != nil {
		fmt.Printf("[error] failed to install Homebrew taps and casks: %v\n", err)
	}

	fmt.Println(caskInstall.String())

	return nil
}
