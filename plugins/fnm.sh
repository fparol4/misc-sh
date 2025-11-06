FNM_PATH="/home/fparol4/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
