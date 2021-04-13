#!/usr/bin/env zsh

# Run this command to pull up a GUI to select a virtual environment.
function venv-activate() {
  local selected_env
  selected_env=$(ls ~/.venv/ | fzf)

  if [ -n "$selected_env" ]; then
    source "$HOME/.venv/$selected_env/bin/activate"
  fi
}

# Run this command to pull up a GUI to select a conda environment.
function conda-activate() {
  local selected_env
  selected_env=$(ls ~/anaconda3/envs/ | fzf)

  if [ -n "$selected_env" ]; then
    conda activate "$selected_env"
  fi
}

function git-rm-branches() {
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}
