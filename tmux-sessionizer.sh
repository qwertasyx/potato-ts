#!/bin/sh

# List of parent directories where your projects are stored.
# You can modify this list to fit your needs.
PROJECT_DIRECTORIES="$HOME/workspace"

# Find all subdirectories (up to 2 levels deep) in the project parent directories.
# Errors are hidden to prevent noise from non-existent directories.
selected=$(find $PROJECT_DIRECTORIES -mindepth 1 -maxdepth 4 -type d 2>/dev/null | fzf)

# Exit if no directory was selected.
if [ -z "$selected" ]; then
    exit 0
fi

# Create a valid tmux session name from the directory's basename.
selected_name=$(basename "$selected" | tr . _)

# Create the tmux session in the background if it doesn't already exist.
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -d -s "$selected_name" -c "$selected"
fi

# Attach to the session if outside tmux, otherwise switch to it.
if [ -z "$TMUX" ]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
