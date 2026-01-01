# dotfiles

My personal Emacs configuration managed with [Doom Emacs](https://github.com/hlissner/doom-emacs).

This configuration is tailored for a development workflow heavily involving **Lisp (Emacs Lisp, Clojure, Racket)**, **Org mode**, **AI tooling (GPT/Gemini via `gptel`)**, and **version control (Magit)**, optimized for a Japanese language environment (`SKK`).

## Features

- **Emacs Distribution:** Doom Emacs
- **Theme:** Dracula (`doom-dracula`)
- **Font:** UDEV Gothic NF
- **Line Numbers:** Relative
- **AI Integration:** `gptel` configured for a mix of Copilot (at office) and Gemini/Claude (remote).
- **SKK Configuration:** Custom activation hooks for smooth input switching.
- **Keybindings:** Heavily customized, particularly around `C-h` (backspace) and leader bindings for `p2s` (social posting) and `gt` (translation).
- **Org Mode:** Integration with `org-roam` and `pandoc` for conversion.

## Setup

1.  **Clone/Link:** Clone this repository to your desired location (e.g., `~/.dotfiles`).
2.  **Doom Emacs Setup:** Ensure you have Doom Emacs installed.
3.  **Configuration Location:** Make sure your Doom Emacs configuration directory points to this repository's `doom` directory (usually `~/.doom.d/` or equivalent).
4.  **Sync Packages:** Run `doom sync` in the terminal.
5.  **Environment Variables:** Set up necessary API keys (e.g., for `gptel`) in your environment or configuration files if required.

### System-Specific Configurations

This setup includes logic for different environments:

-   **macOS:** Handles file system encoding (`utf-8-hfs`).
-   **WSL/Windows:** Configures `browse-url` and `PATH` environment variables for accessing Windows executables/paths from the Linux environment.
-   **Display Scaling:** Custom frame sizes are set based on screen height (e.g., for 5K monitors).

## Custom Packages

The following external packages are managed in `packages.el`:

-   `p2s`: For posting text regions to social media services.
-   `copilot`: GitHub Copilot integration.
-   `llm-tool-collection`: Tools collection for `gptel`.
-   `gt`: Translation utility (using DeepL).
