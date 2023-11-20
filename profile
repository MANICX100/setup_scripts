if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
. "$HOME/.cargo/env"

export PATH=$PATH:/home/dkendall/.local/bin:/usr/sbin/:/home/dkendall/pypy/bin:/usr/racket/bin:/usr/local/go/bin:/home/dkendall/go/bin:/var/lib/flatpak/exports/bin
