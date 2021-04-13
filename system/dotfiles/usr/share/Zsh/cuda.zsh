# Set CUDA_VISIBLE_DEVICES.
gpu() {
    if [[ ! -d /usr/local/cuda ]]; then
        echo "/usr/local/cuda not found, aborting" >&2
        return
    fi

    if [[ "$1" == 0 ]] || [[ "$1" == 1 ]]; then
        export CUDA_VISIBLE_DEVICES="$1"
    elif [[ -z "$1" ]]; then
        export CUDA_VISIBLE_DEVICES=
    else
        echo 'Invalid GPU!' >&2
    fi
}

# By default, disable GPU.
if [[ -d /usr/local/cuda ]]; then
    export CUDA_VISIBLE_DEVICES=
fi
