#!/usr/bin/env zsh

alias tbs-on='wakeonlan 90:09:D0:06:3F:9F'
alias tbs-ssh="ssh cummins@TheBananaStand.local -t '/usr/local/bin/tmux -u -CC new -A -s main'"

_banana_stand_rsync() {
  # Run rsync as root to prevent local read errors. Then omit permissions
  # bits as those can fail on the remote, and use a default list of excludes
  # for common filesystem junk.
  rsync -avh \
    --no-perms --omit-dir-times \
    -e "ssh -i /Users/cummins/.ssh/id_ed25519 -F /Users/cummins/.ssh/config" \
    --exclude ._.DS_Store \
    --exclude .com.apple.timemachine.supported \
    --exclude .DS_Store \
    --exclude .sync.ffs_db \
    --exclude /.DocumentRevisions-V100 \
    --exclude /.fseventsd \
    --exclude /.Spotlight-V100 \
    --exclude /.TemporaryItems \
    --exclude /.Trashes \
    --exclude /.VolumeIcon.icns \
    --exclude /.VolumeIcon.ico \
    --exclude /autorun.inf \
    $@
}

banana_stand_have_my_photos() {
  _banana_stand_rsync --delete ~/Pictures/Photos/ TheBananaStand.local:/volume1/Photos/ $@
}

banana_stand_have_my_music() {
  _banana_stand_rsync --delete ~/Music/Music/ 'TheBananaStand.local:/volume1/Media\ Library/Music/' $@
  _banana_stand_rsync --delete ~/Music/Audiobooks/ 'TheBananaStand.local:/volume1/Media\ Library/Audiobooks/' $@
}

banana_stand_have_my_movies() {
  _banana_stand_rsync -P ~/Movies/Movies/ 'TheBananaStand.local:/volume1/Media\ Library/Movies/' $@
  _banana_stand_rsync -P ~/Movies/TV\ Shows/ 'TheBananaStand.local:/volume1/Media\ Library/TV\ Shows/' $@
}

banana_stand_full_backup() {
  banana_stand_have_my_photos
  banana_stand_have_my_music
  banana_stand_have_my_movies
  banana_stand_have_my_files
}

backup() {
  tmutil startbackup
  banana_stand_have_my_photos $@
  banana_stand_have_my_music $@
  banana_stand_have_my_movies $@
}
