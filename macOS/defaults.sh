#!/usr/bin/env bash

## See https://github.com/albertoqa/dotfiles/blob/master/bin/macos.sh
## See https://github.com/jodylent/dotfiles/blob/master/script/macos.sh

main() {
    configure_accessibility
    configure_calendar
    configure_dock
    configure_finder
    configure_keyboard
    configure_menu_bar
    configure_system
}

function configure_keyboard() {
    echo_substep "Configuring Keyboard Preferences"

    # Configure keyboard repeat https://apple.stackexchange.com/a/83923/200178
    defaults write -g InitialKeyRepeat -int 15
    defaults write -g KeyRepeat -int 2
    # Disable "Correct spelling automatically"
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool true
    # from github.com/mathiasbynens/dotfiles/
    # # Disable automatic capitalization as it’s annoying when typing code
    # defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    # # Disable smart dashes as they’re annoying when typing code
    # defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    # # Disable automatic period substitution as it’s annoying when typing code
    # defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    # # Disable smart quotes as they’re annoying when typing code
    # defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    # # Disable auto-correct
    # defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    # Enable full keyboard access for all controls which enables Tab selection in modal dialogs
    # Basically for multiple choice confirmation boxes, we want tab to work to not use the mouse
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    # Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null

}

function configure_menu_bar() {
    echo_substep "Configuring Menu Bar"

    # Show Bluetooth in menu bar
    defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

    # Show volume in menu bar
    defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Volume.menu"
    
    # Enable show in menu bar
    defaults write com.dmitrynikolaev.numi menuBarMode -int 1

}


function configure_accessibility() {
    echo_substep "Configuring accesibility preferences"

    # Enable three finger moving of windows
    # System Preferences > Accessibility > Mouse & Trackpad > Trackpad Potions
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
}

function configure_system() {
    LOGIN_HOOK_PATH=~/personal/dotfiles/macOS/login_hook_script.sh
    LOGOUT_HOOK_PATH=~/personal/dotfiles/macOS/logout_hook_script.sh

    # Disable Gatekeeper for getting rid of unknown developers error
    sudo spctl --master-disable

    # Disable natural scrolling
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Disable macOS startup chime sound
    sudo defaults write com.apple.loginwindow LoginHook $LOGIN_HOOK_PATH
    sudo defaults write com.apple.loginwindow LogoutHook $LOGOUT_HOOK_PATH

    # Enable tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
}

function configure_dock() {
    quit "Dock"

    # Don’t show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false

    # Set the icon size of Dock items to 60 pixels
    defaults write com.apple.dock tilesize -int 60

    # Show only open applications in the Dock
    # defaults write com.apple.dock static-only -bool false

    # Remove all (default) app icons from the Dock
    defaults delete com.apple.dock persistent-apps

    # Add Apps to Dock
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Utilities/Terminal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/Calendar.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
    defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/omnifocus.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

    # Don’t animate opening applications from the Dock
    defaults write com.apple.dock launchanim -bool false

    # Disable Dashboard
    defaults write com.apple.dashboard mcx-disabled -bool true

    # Don’t show Dashboard as a Space
    defaults write com.apple.dock dashboard-in-overlay -bool true

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true

    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0

    # Don’t automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool false

    ## Hot corners
    ## Possible values:
    ##  0: no-op
    ##  2: Mission Control
    ##  3: Show application windows
    ##  4: Desktop
    ##  5: Start screen saver
    ##  6: Disable screen saver
    ##  7: Dashboard
    ## 10: Put display to sleep
    ## 11: Launchpad
    ## 12: Notification Center

    ## Top left screen corner → Mission Control
    defaults write com.apple.dock wvous-tl-corner -int 0
    defaults write com.apple.dock wvous-tl-modifier -int 0

    ## Top right screen corner → Nothing
    defaults write com.apple.dock wvous-tr-corner -int 0
    defaults write com.apple.dock wvous-tr-modifier -int 0

    ## Bottom left screen corner → Nothing
    defaults write com.apple.dock wvous-bl-corner -int 0
    defaults write com.apple.dock wvous-bl-modifier -int 0
    open "Dock"
}

function configure_calendar() {
    echo_substep "Configuring calendar options"

    # Show birthdays Calendar
    defaults write com.apple.iCal "display birthdays calendar" -bool true

    # Show week numbers
    defaults write com.apple.iCal "Show Week Numbers" -bool true

    # Make text smaller
    defaults write com.apple.iCal "CalUICanvasOccurrenceFontSize" -int 14

}

###############################################################################
# Finder                         	                                      #
###############################################################################
function configure_finder() {
    echo_substep "Configuring finder options"

    # Save screenshots to Downloads folder
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"

    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # allow quitting via ⌘ + q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true

    # disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Set Downloads as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string \
        "file://${HOME}/Downloads/"

    # disable status bar
    defaults write com.apple.finder ShowStatusBar -bool false

    # disable path bar
    defaults write com.apple.finder ShowPathbar -bool false

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages \
        skip-verify -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-remote -bool true

    # Use list view in all Finder windows by default
    # Four-letter codes for view modes: icnv, clmv, Flwv, Nlsv
    defaults write com.apple.finder FXPreferredViewStyle -string clmv

    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
}

function quit() {
    app=$1
    killall "$app" >/dev/null 2>&1
}

function open() {
    app=$1
    osascript <<EOM
tell application "$app" to activate
tell application "System Events" to tell process "Terminal"
set frontmost to true
end tell
EOM
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

function echo_substep() {
    coloredEcho "$1" magenta "===="
}

main "$@"
