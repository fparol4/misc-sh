if [ ! -d "$HOME/.linuxbrew" ]; then
    mkdir -p "$HOME/.linuxbrew"
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$HOME/.linuxbrew"
fi

if [ -d "$HOME/.linuxbrew" ]; then
	eval "$($(command -v brew) shellenv)"
	export PATH="$HOME/.local/bin/zed/bin:$PATH"
fi
