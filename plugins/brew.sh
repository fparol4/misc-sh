if [ ! -d "$HOME/.linuxbrew" ]; then
    mkdir -p "$HOME/.linuxbrew"
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$HOME/.linuxbrew"
fi

eval "$($HOME/.linuxbrew/bin/brew shellenv)"
