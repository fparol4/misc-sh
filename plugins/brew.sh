BREW_HOME="$HOME/.linuxbrew"
BREW_BIN="$BREW_HOME/bin/brew"

if [ ! -d "$BREW_HOME" ]; then
    mkdir -p "$BREW_HOME"
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_HOME"
fi

if [ -x "$BREW_BIN" ]; then
    eval "$("$BREW_BIN" shellenv)"
fi
