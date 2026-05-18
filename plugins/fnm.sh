FNM_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"

if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
