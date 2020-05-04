* On a clean install of macOS:

  * Setup:
    ```bash
    curl --silent https://raw.githubusercontent.com/trosterud/dotfiles/master/bootstrap.sh | bash
    ```

  * Open a Fish shell and execute `compile_vim_plugins` and `install_oh_my_fish` functions.

  * Set Switch Window shortcut manually:
    * Settings -> Keyboard -> Shortcuts -> Keyboard -> Move focus to next window -> (set to Cmd+<)

* The script `bootstrap` should be idempotent. Run often, and configure as much as possible here instead of manually

* Known issues:
  * Struggles with finnish name of default macOS apps when adding them as persistent-apps in the dock
