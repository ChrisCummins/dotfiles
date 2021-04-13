# Git configuration

# In conjunction with ohmyzsh git plugin
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git/

# No arguments: `git status`. With arguments: acts like `git`
# Extended from: https://github.com/thoughtbot/dotfiles
unalias g
g() {
    if [ -n "$1" ]; then
        git "$@"
    else
        git status
    fi
}

# alias ga='git add'
alias gap='git add -p'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git flow'
alias gfr='git pull --rebase'
alias gl='git log'
alias glp='git log -p'
alias gp='git push'
alias gfp='git pull --rebase && git push'
alias gz='git fetch'
alias gza='git fetch --all'

# Delete branches that have been merged.
# See: https://stackoverflow.com/a/6127884
alias git-prune-merged='git branch --merged| egrep -v "(^\*|master|stable|development)" | xargs --no-run-if-empty git branch -d'

# Run this to pull up a fzf window to select branches to delete.
# Requires 'fzf', install using 'brew install fzf'.
function git-rm-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}

# Run this to pull up a fzf window to select a pull request to checkout.
# Requires 'gh' and 'fzf', install using 'brew install gh fzf'.
function git-checkout-pr() {
  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}
