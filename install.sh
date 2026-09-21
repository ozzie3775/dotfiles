#!/usr/bin/env bash
#
# ~/.dotfiles 配下のファイル/ディレクトリを $HOME (または ~/.config) に
# シンボリックリンクする。何度実行しても安全(冪等)で、意図しない実体
# ファイルは上書きしない。
#
# 使い方: ~/.dotfiles/install.sh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# "リポジトリ内のパス:リンク先の絶対パス" の形式で列挙する
LINKS=(
    "zshrc:$HOME/.zshrc"
    "zsh_plugins.txt:$HOME/.zsh_plugins.txt"
    "zsh:$HOME/.config/zsh"
    "tmux.conf:$HOME/.tmux.conf"
    "skk:$HOME/.skk"
    "vimrc:$HOME/.vimrc"
    "starship.toml:$HOME/.config/starship.toml"
    "bat:$HOME/.config/bat"
    "doom:$HOME/.config/doom"
    "ghostty:$HOME/.config/ghostty"
    "nvim:$HOME/.config/nvim"
    "wezterm:$HOME/.config/wezterm"
)

link_one() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"

    if [[ ! -e "$src" ]]; then
        echo "SKIP  $dest (リポジトリに $1 がありません)"
        return
    fi

    if [[ -L "$dest" ]] && [[ -e "$dest" ]] && [[ "$dest" -ef "$src" ]]; then
        echo "OK    $dest (リンク済み)"
        return
    fi

    if [[ -L "$dest" ]] && [[ ! -e "$dest" ]]; then
        echo "WARN  $dest は壊れたシンボリックリンクです ($(readlink "$dest")) -- 手動確認してください"
        return
    fi

    if [[ -e "$dest" ]]; then
        echo "WARN  $dest は別の実体として既に存在します -- 上書きしません"
        return
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "LINK  $dest -> $src"
}

for entry in "${LINKS[@]}"; do
    link_one "${entry%%:*}" "${entry#*:}"
done
