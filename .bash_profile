# Move to home directory (fix WSL2)
cd $HOME

# Add `~/bin` and `~/.local/bin` to the `$PATH`
homebrew=/usr/local/bin:/usr/local/sbin
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.local/bin/depot_tools:$homebrew:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Load the bash_prompt if we have a non-dumb terminal system (i.e. not emacs)
case "$TERM" in
"dumb")
    PS1="> "
    ;;
xterm*|rxvt*|eterm*|screen*)
    [ -r ".bash_prompt" ] && source ".bash_prompt"
    ;;
*)
    PS1="> "
    ;;
esac

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Add Surveyor Completions
[ -e $HOME/.local/bin/surveyor ] && source $HOME/.local/bin/surveyor

# Node Repl
export NODE_REPL_HISTORY_FILE=~/.node_reply_history
