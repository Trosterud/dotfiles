#!/usr/bin/env bash

main() {
    ask_for_sudo
    install_xcode_command_line_tools # to get "git", needed for clone_dotfiles_repo
    install_homebrew
    install_packages_with_brewfile
    change_shell_to_fish
    install_pip_packages
    install_yarn_packages
    install_vscode_extensions
    setup_symlinks
    setup_macOS_defaults
}

DOTFILES_REPO=~/personal/dotfiles

function ask_for_sudo() {
    echo_info "Prompting for sudo password"
    if sudo --validate; then
        # Keep-alive
        while true; do
            sudo --non-interactive true
            sleep 10
            kill -0 "$$" || exit
        done 2>/dev/null &
        echo_success "Sudo password updated"
    else
        error "Sudo password update failed"
        exit 1
    fi
}

function install_xcode_command_line_tools() {
    echo_info "Installing Xcode command line tools"
    if softwareupdate --history | grep --silent "Command Line Tools"; then
        echo_success "Xcode command line tools already exists"
    else
        xcode-select --install
        read -n 1 -s -r -p "Press any key once installation is complete"

        if softwareupdate --history | grep --silent "Command Line Tools"; then
            echo_success "Xcode command line tools installation succeeded"
        else
            error "Xcode command line tools installation failed"
            exit 1
        fi
    fi
}

function install_homebrew() {
    echo_info "Installing Homebrew"
    if hash brew 2>/dev/null; then
        echo_success "Homebrew already exists"
    else
        url=https://raw.githubusercontent.com/Homebrew/install/master/install
        if yes | /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
            echo_success "Homebrew installation succeeded"
        else
            error "Homebrew installation failed"
            exit 1
        fi
    fi
}

function install_packages_with_brewfile() {
    echo_info "Installing Brewfile packages"

    TAP=${DOTFILES_REPO}/brew/Brewfile_tap
    BREW=${DOTFILES_REPO}/brew/Brewfile_brew
    CASK=${DOTFILES_REPO}/brew/Brewfile_cask
    MAS=${DOTFILES_REPO}/brew/Brewfile_mas

    if hash parallel 2>/dev/null; then
        echo_substep "parallel already exists"
    else
        if brew install parallel &>/dev/null; then
            printf 'will cite' | parallel --citation &>/dev/null
            echo_substep "parallel installation succeeded"
        else
            error "parallel installation failed"
            exit 1
        fi
    fi

    if (
        echo $TAP
        echo $BREW
        echo $CASK
        echo $MAS
    ) | parallel --verbose --linebuffer -j 4 brew bundle check --file={} &>/dev/null; then
        echo_success "Brewfile packages are already installed"
    else
        if brew bundle --file="$TAP"; then
            echo_substep "Brewfile_tap installation succeeded"

            export HOMEBREW_CASK_OPTS="--no-quarantine"
            if (
                echo $BREW
                echo $CASK
                echo $MAS
            ) | parallel --verbose --linebuffer -j 3 brew bundle --file={}; then
                echo_success "Brewfile packages installation succeeded"
            else
                error "Brewfile packages installation failed"
                exit 1
            fi
        else
            error "Brewfile_tap installation failed"
            exit 1
        fi
    fi
}

function change_shell_to_fish() {
    echo_info "Fish shell setup"
    if grep --quiet fish <<<"$SHELL"; then
        echo_success "Fish shell already exists"
    else
        user=$(whoami)
        echo_substep "Adding Fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet \
            "/usr/local/bin/fish" /etc/shells; then
            echo_substep "Fish executable already exists in /etc/shells"
        else
            if echo /usr/local/bin/fish | sudo tee -a /etc/shells >/dev/null; then
                echo_substep "Fish executable successfully added to /etc/shells"
            else
                error "Failed to add Fish executable to /etc/shells"
                exit 1
            fi
        fi
        echo_substep "Switching shell to Fish for \"${user}\""
        if sudo chsh -s /usr/local/bin/fish "$user"; then
            echo_success "Fish shell successfully set for \"${user}\""
        else
            error "Please try setting Fish shell again"
        fi
    fi
}

function install_pip_packages() {
    echo_info "Installing pip packages"
    REQUIREMENTS_FILE=${DOTFILES_REPO}/pip/requirements.txt

    if pip3 install -r "$REQUIREMENTS_FILE" 1>/dev/null; then
        echo_success "pip packages successfully installed"
    else
        error "pip packages installation failed"
        exit 1
    fi

}

function install_yarn_packages() {
    # prettier for Neoformat to auto-format files
    # typescript for YouCompleteMe
    yarn_packages=(prettier typescript vmd create-react-app gatsby-cli netlify-cli)
    echo_info "Installing yarn packages \"${yarn_packages[*]}\""

    yarn_list_outcome=$(yarn global list)
    for package_to_install in "${yarn_packages[@]}"; do
        if echo "$yarn_list_outcome" |
            grep --ignore-case "$package_to_install" &>/dev/null; then
            echo_substep "\"${package_to_install}\" already exists"
        else
            if yarn global add "$package_to_install"; then
                echo_substep "Package \"${package_to_install}\" installation succeeded"
            else
                error "Package \"${package_to_install}\" installation failed"
                exit 1
            fi
        fi
    done

    echo_success "yarn packages successfully installed"
}

function install_vscode_extensions() {
    extensions=(
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        ms-vsliveshare.vsliveshare
        humao.rest-client
        eamodio.gitlens
        yzhang.markdown-all-in-one
        skyapps.fish-vscode
        idleberg.applescript
        foxundermoon.shell-format
        shd101wyy.markdown-preview-enhanced
    )
    echo_info "Installing vscode extensions \"${extensions[*]}\""

    extensions_outcome=$(code --list-extensions)
    for extension_to_install in "${extensions[@]}"; do
        if echo "$extensions_outcome" |
            grep --ignore-case "$extension_to_install" &>/dev/null; then
            echo_substep "\"${extension_to_install}\" already exists"
        else
            if code --install-extension "$extension_to_install"; then
                echo_substep "Extension \"${extension_to_install}\" installation succeeded"
            else
                error "Extension \"${extension_to_install}\" installation failed"
                exit 1
            fi
        fi
    done

    echo_success "vscode extensions successfully installed"
}

function clone_dotfiles_repo() {
    echo_info "Cloning dotfiles repository into ${DOTFILES_REPO}"
    if test -e $DOTFILES_REPO; then
        echo_substep "${DOTFILES_REPO} already exists"
        pull_latest $DOTFILES_REPO
        echo_success "Pull successful in ${DOTFILES_REPO} repository"
    else
        url=https://github.com/sam-hosseini/dotfiles.git
        if git clone "$url" $DOTFILES_REPO &&
            git -C $DOTFILES_REPO remote set-url origin git@github.com:sam-hosseini/dotfiles.git; then
            echo_success "Dotfiles repository cloned into ${DOTFILES_REPO}"
        else
            error "Dotfiles repository cloning failed"
            exit 1
        fi
    fi
}

function pull_latest() {
    echo_substep "Pulling latest changes in ${1} repository"
    if git -C $1 pull origin master &>/dev/null; then
        return
    else
        error "Please pull latest changes in ${1} repository manually"
    fi
}

function setup_symlinks() {
    APPLICATION_SUPPORT=~/Library/Application\ Support
    POWERLINE_ROOT_REPO=/usr/local/lib/python3.7/site-packages

    echo_info "Setting up symlinks"
    symlink "git" ${DOTFILES_REPO}/git/gitconfig ~/.gitconfig
    # symlink "hammerspoon" ${DOTFILES_REPO}/hammerspoon ~/.hammerspoon
    # symlink "karabiner" ${DOTFILES_REPO}/karabiner ~/.config/karabiner
    # symlink "powerline" ${DOTFILES_REPO}/powerline ${POWERLINE_ROOT_REPO}/powerline/config_files
    # symlink "tmux" ${DOTFILES_REPO}/tmux/tmux.conf ~/.tmux.conf
    # symlink "vim" ${DOTFILES_REPO}/vim/vimrc ~/.vimrc

    # Disable shell login message
    symlink "hushlogin" /dev/null ~/.hushlogin

    symlink "fish:completions" ${DOTFILES_REPO}/fish/completions ~/.config/fish/completions
    symlink "fish:functions" ${DOTFILES_REPO}/fish/functions ~/.config/fish/functions
    symlink "fish:config.fish" ${DOTFILES_REPO}/fish/config.fish ~/.config/fish/config.fish
    symlink "fish:oh_my_fish" ${DOTFILES_REPO}/fish/oh_my_fish ~/.config/omf

    # Visual Studio Code
    symlink "vscode:settings.json" ${DOTFILES_REPO}/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
    # symlink "vscode:keybindings.json" ${DOTFILES_REPO}/vscode/keybindings.json /Users/pawelgrzybek/Library/Application\ Support/Code/User/keybindings.json
    # symlink "vscode:snippets"         ${DOTFILES_REPO}/vscode/snippets/ /Users/pawelgrzybek/Library/Application\ Support/Code/User

    echo_success "Symlinks successfully setup, skipped hammerspoon karabiner powerline tmux vim"
}

function symlink() {
    application=$1
    point_to=$2
    destination=$3
    destination_dir=$(dirname "$destination")

    if test ! -e "$destination_dir"; then
        echo_substep "Creating ${destination_dir}"
        mkdir -p "$destination_dir"
    fi
    if rm -rf "$destination" && ln -s "$point_to" "$destination"; then
        echo_substep "Symlinking for \"${application}\" done"
    else
        error "Symlinking for \"${application}\" failed"
        exit 1
    fi
}

function setup_macOS_defaults() {
    echo_info "Updating macOS defaults"

    current_dir=$(pwd)
    cd ${DOTFILES_REPO}/macOS
    if bash defaults.sh; then
        cd $current_dir
        echo_success "macOS defaults updated successfully"
    else
        cd $current_dir
        error "macOS defaults update failed"
        exit 1
    fi
}

function update_login_items() {
    echo_info "Updating login items"

    if osascript ${DOTFILES_REPO}/macOS/login_items.applescript &>/dev/null; then
        echo_success "Login items updated successfully "
    else
        error "Login items update failed"
        exit 1
    fi
}

function coloredEcho() {
    local exp="$1"
    local color="$2"
    local arrow="$3"
    if ! [[ $color =~ '^[0-9]$' ]]; then
        case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white | *) color=7 ;; # white or invalid color
        esac
    fi
    tput bold
    tput setaf "$color"
    echo "$arrow $exp"
    tput sgr0
}

function echo_info() {
    coloredEcho "$1" blue "========>"
}

function echo_substep() {
    coloredEcho "$1" magenta "===="
}

function echo_success() {
    coloredEcho "$1" green "========>"
}

function error() {
    coloredEcho "$1" red "========>"
}

main "$@"
