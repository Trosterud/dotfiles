# export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin:$PATH # Also check the git/gitconfig file
# eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(brew shellenv)"
ZSH_AUTOSUGGEST_CASE_SENSITIVE="false"
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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

# Load NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Enable substitution in the prompt.
setopt prompt_subst

# Config for prompt. PS1 synonym.
PROMPT='%F{cyan}%2/%f $(git_branch_name) %F{cyan}>%f '

# Aliases
alias bootstrap="bash ~/personal/dotfiles/bootstrap.sh"
alias branch='f() { git checkout -b $1; git push --set-upstream origin $1; }; f'
alias c="clear"
alias chats="open /Applications/WhatsApp.app/ /Applications/Telegram.app/ /Applications/Signal.app/"
alias clojure='f() { java -jar "$@"; }; f'
alias dot="cd ~/personal/dotfiles/"
alias dotfiles="cd ~/personal/dotfiles/"
alias emails="open https://www.gmail.com https://mail.aalto.fi https://webmail.numanconsult.com https://linkedin.com"
alias extract='f() {
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
}; f'
alias g='f() { open "https://www.google.com/search?tbm=isch&q=$1"; }; f'
alias ga='git add'
alias gb='git branch'
alias gc='f() { git commit -m "$1"; }; f'
alias gch='f() { git checkout $1; git push --set-upstream origin $1; }; f'
alias gd='clear && git diff'
alias git_branch_cleanup='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d && git remote prune origin'
alias gl='git pull'
alias gpl='git pull'
alias gp='clear && git push'
alias grm='git rebase master'
alias gs='clear && git status'
alias gum='git checkout master && git pull && git checkout -'
alias gif_compress='f() {
    case $2 in
        high) gifsicle --interlace $1 -O3 --colors 64 --output compressed.gif;;
        medium) gifsicle --interlace $1 -O3 --colors 128 --output compressed.gif;;
        low) gifsicle --interlace $1 -O3 --colors 256 --output compressed.gif;;
        *) echo "Usage: gif_compress FILE high/medium/low";;
    esac
}; f'
alias ii='clear && http ipinfo.io --print=b'
alias lint='lein bikeshed && clj-kondo --lint src test && lein cljstyle fix'
alias ll='f() { clear; ls -lah "$@"; }; f'
alias personal_hotspot='f() { networksetup -setairportnetwork en0 "Nordic Roadshow" $1; }; f'
alias pomodoro='f() { sleep 1500; notification "Pomodoro over" "25 minutes have passed, you are aware"; }; f &'
alias r='lein run || bin/serve'
alias up='echo -e "####################################\n# Software Update \n####################################"; sudo softwareupdate --install --all; echo -e "####################################\n# Brew \n####################################"; brew update; brew upgrade; mas upgrade; brew cask outdated --greedy --verbose | ack --invert-match latest | awk "{print \$1;}" | xargs brew cask upgrade; brew cleanup; brew doctor; echo -e "####################################\n# Pip \n####################################"; pip-sync ~/personal/dotfiles/pip/requirements.txt; echo -e "####################################\n# Npm \n####################################"; npm update -g; echo -e "\n####################################\n# Oh-My-Fish \n####################################"; omf install; omf update; echo -e "####################################\n# Done \n####################################"'
alias ws='f() { open -na "/Users/be/Applications/WebStorm.app" --args "$@"; }; f'
