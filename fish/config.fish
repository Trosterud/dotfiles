############################################################################
# Fish theme - influences only the colors of what you type
# omf theme will not have any influence as powerline controls fish prompt
############################################################################
source ~/personal/dotfiles/fish/fish_theme.fish

############################################################################
# Environment Variables
############################################################################
set --global --export GIT_GLOBAL_NAME  "Sindre Trosterud"
set --global --export GIT_GLOBAL_EMAIL "sindre.reino.trosterud@gmail.com"
set --global --export GIT_AUTHOR_NAME     $GIT_GLOBAL_NAME
set --global --export GIT_COMMITTER_NAME  $GIT_GLOBAL_NAME
set --global --export GIT_AUTHOR_EMAIL    $GIT_GLOBAL_EMAIL
set --global --export GIT_COMMITTER_EMAIL $GIT_GLOBAL_EMAIL
set --global --export HOMEBREW_BUNDLE_NO_LOCK true
set --global --export HOMEBREW_NO_AUTO_UPDATE true
set --global --export EDITOR code
set --global --export PYTHONDONTWRITEBYTECODE true
set --global --export PYTHONUNBUFFERED true
set --global --export fish_greeting ''
set --global --export HOMEBREW_CASK_OPTS "--no-quarantine"
# set --global --export LC_ALL en_US.UTF-8 # Set locale
# set --global --export LANG en_US.UTF-8   # Set locale

############################################################################
# PATH setup
############################################################################
# /usr/local/bin is where brew symlinks most executables it installs
# /usr/local/sbin is where brew symlinks some of its executables
# /usr/local/opt/ruby/bin is where the symlinked brew Ruby executable lives
# By putting these paths before $fish_user_paths, they will take precedence
# over system provided programs
set --global --export fish_user_paths \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/opt/ruby/bin \
    /usr/local/lib/ruby/gems/2.6.0/bin \
    $fish_user_paths

############################################################################
# Configuration for Powerline
############################################################################
set --global --export \
    POWERLINE_ROOT_REPO /usr/local/lib/python3.7/site-packages
set fish_function_path \
    $fish_function_path "$POWERLINE_ROOT_REPO/powerline/bindings/fish"
# powerline-daemon --quiet
# powerline-setup

############################################################################
# Configuration for Oh-My-Fish!
############################################################################
set -q XDG_DATA_HOME
    and set --global --export OMF_PATH "$XDG_DATA_HOME/omf"
    or set  --global --export OMF_PATH "$HOME/.local/share/omf"
source $OMF_PATH/init.fish

