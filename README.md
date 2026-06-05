# dotfiles

My personal configuration files (dotfiles) for a productive development environment on macOS and Linux.

This repository contains configurations for various tools including **Doom Emacs**, **Zsh**, **Tmux**, **Vim**, and modern terminal emulators like **WezTerm** and **Ghostty**. The environment is optimized for Japanese input (`SKK`), AI-assisted development, and Lisp-centric workflows.

## Features

- **Shell:** Zsh with [Starship](https://starship.rs/) prompt.
- **Terminal:** [WezTerm](https://wezfurlong.org/wezterm/) and [Ghostty](https://ghostty.org/) with UDEV Gothic NF font.
- **Editor:** [Doom Emacs](https://github.com/hlissner/doom-emacs) (Primary) and Vim (Secondary).
- **Multiplexer:** Tmux with [TPM](https://github.com/tmux-plugins/tpm).
- **Theme:** Consistent [Dracula](https://draculatheme.com/) theme across most tools.
- **Japanese Input:** Custom SKK configuration.
- **AI Integration:** `gptel` in Emacs for Gemini/Claude/Copilot.

## Repository Structure

- `doom/`: Doom Emacs configuration (`init.el`, `config.el`, `packages.el`).
- `zshrc`: Zsh configuration.
- `tmux.conf`: Tmux configuration.
- `vimrc`: Vim configuration.
- `wezterm/`: WezTerm configuration.
- `ghostty/`: Ghostty configuration.
- `starship.toml`: Starship prompt configuration.
- `bat/`: `bat` (cat clone with wings) configuration.
- `skk`: SKK dictionary and behavior settings.

## Setup

1.  **Clone:**
    ```bash
    git clone https://github.com/ozzie3775/dotfiles.git ~/.dotfiles
    ```
2.  **Symlink (Example):**
    You can use a tool like `stow` or manually link files:
    ```bash
    ln -s ~/.dotfiles/zshrc ~/.zshrc
    ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
    # etc.
    ```

## Tool Specifics

### Doom Emacs

My primary environment tailored for **Lisp (Emacs Lisp, Clojure, Racket)**, **Org mode**, **AI tooling**, and **version control (Magit)**.

- **AI Integration:** `gptel` configured for a mix of Copilot (at office) and Gemini/Claude (remote).
- **Keybindings:** Heavily customized, particularly around `C-h` (backspace) and leader bindings for `p2s` (social posting) and `gt` (translation).
- **Org Mode:** Integration with `org-roam` and `pandoc` for conversion.

For more details, see the `doom/` directory.

### Zsh & Starship

- **Keybindings:** Emacs-style keybindings (`bindkey -e`).
- **Prompt:** Managed by Starship, providing a fast and informative status line.

### Tmux

- **Prefix:** Changed from `C-b` to `C-t`.
- **Plugins:** Managed via TPM, including `tmux-sensible`, `tmux-open`, and `tmux-pain-control`.

### Terminal (WezTerm / Ghostty)

- **Font:** UDEV Gothic NF.
- **Theme:** Dracula.
- **Features:** Optimized for high-resolution displays (e.g., 5K monitors).

### Vim

- **Plugins:** Managed by `vim-plug`.
- **LSP:** Configured with `vim-lsp` for intelligent coding support.

## License

This project is licensed under the [MIT License](LICENSE).
