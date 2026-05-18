FNM_PATH="/home/fabricio.parola/.local/share/fnm"

if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
