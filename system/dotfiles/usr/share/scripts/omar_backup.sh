#!/usr/bin/env bash
#
# Run a full system backup. Run as regular user.

set -euo pipefail

MAX_ATTEMPTS=100
WAITING_TIME=300
DRY_RUN=false
SOURCE_LOCKFILE=/.emu/LOCK
SINK_LOCKFILE=/mnt/secondary/backups/.emu/LOCK
EMU_PUSH_ARGS="-v --ignore-errors"
LOGFILE=/var/log/emu.log

usage() {
    echo "Backup filesystem. Usage:"
    echo ""
    echo "    backup [--dry-run]"
}

preexec() {
  sudo /home/cec/.local/etc/emu/preexec.sh
}

postexec() {
  sudo /home/cec/.local/etc/emu/postexec.sh
}

main() {
  local attempt=0

  set +u
  while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --dry-run)
            EMU_PUSH_ARGS="$EMU_PUSH_ARGS --dry-run"
            DRY_RUN=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
  done
  set -u

  if [[ $DRY_RUN == false ]]; then
    preexec
    trap postexec SIGHUP SIGINT SIGTERM
  fi

  while [[ -f "$SOURCE_LOCKFILE" ]] && [[ -f "$SINK_LOCKFILE" ]] ; do
    # Determine a lockfile to check.
    local target_lockfile="$SOURCE_LOCKFILE"
    if [[ -f "$SINK_LOCKFILE" ]]; then
      target_lockfile="$SINK_LOCKFILE"
    fi

    # Check if the PID of the lockfile is still running.
    if ps $(cut -f1 -d' ' "$target_lockfile") &>/dev/null ; then
      attempt=$((attempt+1))
      if [[ $attempt -ge $MAX_ATTEMPTS ]] ; then
        echo "Ran out of patience waiting for the lockfile to become free!"
        exit 1
      fi
      echo -n "Waiting for lockfiles attempt $attempt / $MAX_ATTEMPTS. "
      echo "Sleeping for $WAITING_TIME seconds ..."
      sleep "$WAITING_TIME"
    else
      echo "Removing stale lockfile"
      # A lockfile exists but the PID is not running. Remove it.
      if [[ $DRY_RUN == false ]]; then
        sudo rm -fv "$SOURCE_LOCKFILE" "$SINK_LOCKFILE"
      fi
    fi
  done

  set +e
  cd /
  sudo touch "$LOGFILE"
  sudo chown "$USER" "$LOGFILE"
  date > "$LOGFILE"
  sudo emu push $EMU_PUSH_ARGS >> "$LOGFILE"
  ret=$?
  set -e

  if [[ $DRY_RUN == false ]]; then
    postexec
    exit "$ret"
  fi
}
main $@
