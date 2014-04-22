# ~/.profile: executed by the command interpreter for login shells.

# If running bash, drag in the rc.
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

