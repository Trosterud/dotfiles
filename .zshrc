# export PATH=/opt/homebrew/bin:$PATH # the version depends on where homebrew is installed
export PATH=/usr/local/bin:$PATH # Also check the git/gitconfig file
# export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/Contents/Home
export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jbr/Contents/Home
# eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(brew shellenv)"
ZSH_AUTOSUGGEST_CASE_SENSITIVE="false"
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Lazy Load NVM
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    source "$(brew --prefix nvm)/nvm.sh"
    nvm "$@"
}
node() {
    unset -f node
    source "$(brew --prefix nvm)/nvm.sh"
    node "$@"
}
npm() {
    unset -f npm
    source "$(brew --prefix nvm)/nvm.sh"
    npm "$@"
}

# Find and set branch name var if in git repository.
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '- ('$branch')'
  fi
}

# Enable substitution in the prompt.
setopt prompt_subst

# Config for prompt. PS1 synonym.
PROMPT='%F{cyan}%2/%f $(git_branch_name) %F{cyan}>%f '

# Path
export ANDROID_HOME=/Users/be/Library/Android/sdk

# Aliases
alias bootstrap="bash ~/personal/dotfiles/bootstrap.sh"
branch() {
    git checkout -b "$1"
    git push --set-upstream origin "$1"
}
alias c="clear"
alias chats="open /Applications/WhatsApp.app/ /Applications/Telegram.app/ /Applications/Signal.app/"
clojure() {
    java -jar "$@"
}
alias dot="cd ~/personal/dotfiles/"
alias dotfiles="cd ~/personal/dotfiles/"
alias emails="open https://www.gmail.com https://mail.aalto.fi https://webmail.numanconsult.com https://linkedin.com"
extract() {
    for file in "$@"; do
        if [[ -f $file ]]; then
            echo "Extracting $file"
            case $file in
                *.7z) 7z x "$file";;
                *.tar) tar -xvf "$file";;
                *.tar.bz2 | *.tbz2) tar --bzip2 -xvf "$file";;
                *.tar.gz | *.tgz) tar --gzip -xvf "$file";;
                *.bz | *.bz2) bunzip2 "$file";;
                *.gz) gunzip "$file";;
                *.rar) unrar x "$file";;
                *.zip) unzip -uo "$file" -d "$(basename "$file" .zip)";;
                *.Z) uncompress "$file";;
                *.pax) pax -r < "$file";;
                *) echo "Extension not recognized, cannot extract $file";;
            esac
        else
            echo "$file is not a valid file"
        fi
    done
}
g() {
    open "https://www.google.com/search?tbm=isch&q=$1"
}
alias ga='git add'
alias gb='git branch'
gc() {
    git commit -m "$1"
}
gch() {
    git checkout "$1"
    git push --set-upstream origin "$1"
}
alias gd='clear && git diff'
alias git_branch_cleanup='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d && git remote prune origin'
alias gl='git pull'
alias gpl='git pull'
alias gp='clear && git push'
alias go='clear && git push && gh pr create --fill'
alias grm='git rebase master'
alias gs='clear && git status'
alias gum='git checkout master && git pull && git checkout -'
alias gurm='git checkout master && git rebase master && git pull && git checkout -'
gif_compress() {
    case $2 in
        high) gifsicle --interlace $1 -O3 --colors 64 --output compressed.gif;;
        medium) gifsicle --interlace $1 -O3 --colors 128 --output compressed.gif;;
        low) gifsicle --interlace $1 -O3 --colors 256 --output compressed.gif;;
        *) echo "Usage: gif_compress FILE high/medium/low";;
    esac
}
alias ii='clear && http ipinfo.io --print=b'
alias lint='lein bikeshed && clj-kondo --lint src test && lein cljstyle fix'
ll() {
    clear
    ls -lah "$@"
}
personal_hotspot() {
    networksetup -setairportnetwork en0 "Nordic Roadshow" $1
}
pomodoro() {
    sleep 1500
    notification "Pomodoro over" "25 minutes have passed, you are aware"
}
alias r='lein run || bin/serve'
up() {
    echo -e "####################################\n# Software Update \n####################################"
    sudo softwareupdate --install --all
    echo -e "####################################\n# Brew \n####################################"
    brew update
    brew upgrade
    mas upgrade
    brew cask outdated --greedy --verbose | ack --invert-match latest | awk "{print \$1;}" | xargs brew cask upgrade
    brew cleanup
    brew doctor
    echo -e "####################################\n# Pip \n####################################"
    pip-sync ~/personal/dotfiles/pip/requirements.txt
    echo -e "####################################\n# Npm \n####################################"
    npm update -g
    echo -e "\n####################################\n# Oh-My-Fish \n####################################"
    omf install
    omf update
    echo -e "####################################\n# Done \n####################################"
}

ws() {
    open -na "/Users/be/Applications/WebStorm.app" --args "$@"
}
export PATH=$PATH:$HOME/.maestro/bin
