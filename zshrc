# -*- zsh -*-
# history
HISTFILE=~/.zsh_history
HISTORY_IGNORE="(cd|pwd|l[sal])"
HISTSIZE=10000
SAVEHIST=10000

# Emacs keybind
bindkey -e

setopt extended_history
setopt hist_allow_clobber
setopt hist_fcntl_lock
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store

setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history_time

umask 077

# if [ -e ~/.dircolors ]; then
#     eval "$(dircolors -b ~/.dircolors)"
#     alias ls="ls -F --color=auto"
# fi

# homebrew関係
if command -v /usr/local/bin/brew &>/dev/null; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
if command -v /opt/homebrew/bin/brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# zsh-completions
# brew install zsh-completions
if command -v brew &>/dev/null; then
   FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi
autoload -Uz compinit
compinit
zstyle ':completion:*:default' menu select=2

# Ls Color
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# PATH
typeset -U path PATH
path=(./bin(N-/) $path)
path=(~/bin(N-/) $path)
path=(~/.local/bin(N-/) $path)
path=(~/.config/emacs/bin(N-/) $path)
path=(~/go/bin(N-/) $path)

# lesspipe
if command -v lesspipe.sh 1>/dev/null 2>&1; then
    export LESSOPEN="| lesspipe.sh %s"
fi

# タイトルバーにパスを表示する
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }

function history-all { history -E 1 }

# Functions
function rmb {
    find . -name '.*~' -exec rm {} \; -print
    find . -name '*~' -exec rm {} \; -print
}

# alias

## Mac
if [[ $OSTYPE == *darwin* ]]; then
    alias top="top -o cpu"
    alias ldd="otool -L"
    alias strace="dtruss"
fi

## Linux
if [[ $OSTYPE == *linux* ]]; then
    alias open="xdg-open"
fi

## cygwin
if [[ $OSTYPE == cygwin ]]; then
    alias open="cygstart"
fi

alias h=history
alias vi="nvim"
alias wgetg="wget -e robots=off -l 1 -H -r -nd -A .jpg"
alias history='history -E'
alias be="bundle exec"
alias beruby="bundle exec ruby"
alias berspec="bundle exec rspec"
alias berails="bundle exec rails"
alias bl="bundle list"
alias bp="bundle package"
alias bo="bundle open"
alias bout="bundle outdated"
alias bu="bundle update"
alias bi="bundle_install"
alias bcn="bundle clean"
alias ls="eza --icons"

# rbenv
# brew install rbenv
if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

# pyenv
# brew install pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# nodenv
# brew install nodenv
if command -v nodenv 1>/dev/null 2>&1; then
    eval "$(nodenv init -)"
fi

# starship
# brew install starship
if command -v starship 1>/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# zsh-fast-syntax-highlighting
# brew install zsh-fast-syntax-highlighting
source ${HOMEBREW_PREFIX}/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# zsh-autosuggestions
# brew install zsh-autosuggestions
source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

## fzf
# brew install fzf
if command -v fzf 1>/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

## z
source ${HOMEBREW_PREFIX}/etc/profile.d/z.sh

# for Emacs vterm
vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
