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

# Conda setup.
__conda_setup="$($HOME/anaconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
