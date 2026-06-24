# -*- sh -*-

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

# homebrew関係
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

typeset -U fpath FPATH
fpath=(
    "$HOMEBREW_PREFIX/share/zsh-completions"(N-/)
    $fpath
)

autoload -Uz compinit
compinit
zstyle ':completion:*:default' menu select=2

# Ls Color
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# プラグインを安全に読み込むための共通関数
function _source_if_exists() {
    local target_path="$1"
    [[ -f "$target_path" ]] && source "$target_path"
}

# zsh-syntax-highlighting
# brew install zsh-syntax-highlighting
_source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
_source_if_exists "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-autosuggestions
# brew install zsh-autosuggestions
_source_if_exists "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
_source_if_exists "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-history-substring-search
# brew install zsh-history-substring-search
_source_if_exists "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
if (( ${+widgets[history-substring-search-up]} )); then
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
fi

# OpenClaw Completion
_source_if_exists "$HOME/.openclaw/completions/openclaw.zsh"

# ghostty integratoin
_source_if_exists "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"


# 使い終わった関数を削除してシェル環境を汚さないようにする
unfunction _source_if_exists

# PATH
typeset -U path PATH
path=(
    ./bin(N-/)
    ~/bin(N-/)
    ~/.local/bin(N-/)
    ~/.config/emacs/bin(N-/)
    ~/go/bin(N-/)
    $path
)

# lesspipe
if (( ${+commands[lesspipe.sh]} )); then
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

case "$OSTYPE" in
    *darwin*)
        alias top="top -o cpu"
        alias ldd="otool -L"
        alias strace="dtruss"
        ;;
    *linux*)
        alias open="xdg-open"
        ;;
    *cygwin*)
        alias open="cygstart"
        ;;
esac

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
alias ls="eza --time-style=long-iso --icons"

# mise
if (( ${+commands[mise]} )); then
    eval "$(mise activate zsh)"
fi

# starship
# brew install starship
if (( ${+commands[starship]} )); then
    eval "$(starship init zsh)"
fi

# zoxide
# brew install zoxide
if (( ${+commands[zoxide]} )); then
    eval "$(zoxide init zsh)"
fi

## fzf
# brew install fzf
if (( ${+commands[fzf]} )); then
    eval "$(fzf --zsh)"

    local -a fzf_opts=(
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
        --preview-window=down
    )
    export FZF_DEFAULT_OPTS="${(j: :)fzf_opts}"
    export FZF_CTRL_T_COMMAND="fd -t f"
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind '?:toggle-preview'"
    export FZF_ALT_C_COMMAND="fd -t d"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"
    export FZF_TMUX=1
    export FZF_TMUX_OPTS="-p 80%"
fi

# uv
# brew install uv
if (( ${+commands[uv]} )); then
    eval "$(uv generate-shell-completion zsh)"
fi

# for Emacs vterm
vterm_printf() {
    if [ -n "$TMUX" ] && { [ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# Yazi
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
