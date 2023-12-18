export PATH=/opt/homebrew/bin:$PATH
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

# Enable substitution in the prompt.
setopt prompt_subst

# Config for prompt. PS1 synonym.
PROMPT='%F{cyan}%2/%f $(git_branch_name) %F{cyan}>%f '

# Aliases
alias  ll='ls -lah'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gpl='git pull'
