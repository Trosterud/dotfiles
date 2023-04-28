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

  * Set Switch Window shortcut manually:
    * Settings -> Keyboard -> Shortcuts -> Keyboard -> Move focus to next window -> (set to Cmd+<)

* The script `bootstrap` should be idempotent. Run often, and configure as much as possible here instead of manually
