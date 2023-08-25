#!/usr/local/bin/bash

if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
export PATH="$HOME/.rbenv/bin:/usr/local/sbin:$PATH"

# rbenv
eval "$(rbenv init -)"

. "$HOME/.cargo/env"
