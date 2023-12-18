# Dotfiles &middot; [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/your/your-project/blob/master/LICENSE)

Personal dotfiles to sync installs and configs.


## Install

* On a clean install of macOS:

  * Setup:
    ```bash
    curl --silent https://raw.githubusercontent.com/trosterud/dotfiles/master/bootstrap.sh | bash
    ```

  * Run twice if xcode install exits early. Happens sometimes when quiet keep process alive fails when popup is asking for sudo.

  * Open a Fish shell and execute `compile_vim_plugins` and `install_oh_my_fish` functions.

  * Set delete word in terminal shortcut
    * Open Terminal -> Settings -> Profiles -> Keyboard -> + -> option backspace = \027 Shortcuts

  * Set zsh history-substring up and down key bindings:
    * https://github.com/zsh-users/zsh-history-substring-search

  * Set Rectangle settings
    * choose Spectacle if asked. If not, go to "restore" and choose "spectacle".
    * Set Restore size after snap to false from middle menu

* The script `bootstrap` should be idempotent. Run often, and configure as much as possible here instead of manually
