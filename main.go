package main

import (
	"log"
	"os"
	"path/filepath"
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

	err = os.Symlink(filepath.Join(wd, ".zshrc"), "$HOME/.zshrc")
	if err != nil {
		return err
	}

	return nil
}
