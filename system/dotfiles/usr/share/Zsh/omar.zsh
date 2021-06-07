#!/usr/bin/env zsh

alias omar-on='wakeonlan b4:2e:99:9f:d1:39'
alias omar-off="ssh omar 'sudo shutdown -h now'"
alias pingo='ping 192.168.0.204'

_wrapped_rsync() {
  # Rsync with a default list of excludes for common filesystem junk.
  rsync -avh \
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

omar_have_my_photos() {
  _wrapped_rsync --delete ~/Pictures/photos/ omar:Pictures/photos/ $@
  _wrapped_rsync --delete ~/Pictures/catalogs/ omar:Pictures/catalogs/ $@
  _wrapped_rsync --delete ~/Pictures/ omar:Pictures/ \
    --exclude '/photos' \
    --exclude '/catalogs' \
    --exclude '*.lrcat-journal' \
    --exclude '*.lrcat.lock' \
    --exclude '*.lrdata' \
    --exclude '*.lrfprev' \
    $@
}

omar_have_my_music() {
  _wrapped_rsync --delete ~/Music/Music/ omar:Music/Music/ $@
  _wrapped_rsync --delete ~/Music/Audiobooks/ omar:Music/Audiobooks/ $@
}

omar_have_my_movies() {
  _wrapped_rsync -P ~/Movies/Movies/ omar:Videos/movies/ $@
  _wrapped_rsync -P ~/Movies/TV\ Shows/ omar:Videos/tv/ $@
}

omar_have_my_files() {
  _wrapped_rsync --delete / omar:Backups/bodie/Latest/ \
    --exclude "/.file" \
    --exclude "/.PKInstallSandboxManager-SystemSoftware" \
    --exclude "/Applications" \
    --exclude "/dev" \
    --exclude "/Library/Application Support/Apple/AssetCache/Data" \
    --exclude "/Library/Application Support/Apple/AssetCache/Data" \
    --exclude "/Library/Application Support/Apple/ParentalControls/Users" \
    --exclude "/Library/Application Support/ApplePushService" \
    --exclude "/Library/Application Support/ApplePushService" \
    --exclude "/Library/Application Support/Tunnelblick" \
    --exclude "/Library/Caches" \
    --exclude "/Library/DropboxHelperTools" \
    --exclude "/Library/Logs/DiagnosticReports" \
    --exclude "/Library/NordVPN" \
    --exclude "/Library/OSAnalytics/Preferences/Library" \
    --exclude "/Library/Preferences/com.apple.apsd.plist" \
    --exclude "/Library/Preferences/OpenDirectory/opendirectoryd.plist" \
    --exclude "/Library/Server" \
    --exclude "/Library/SystemMigration/History" \
    --exclude "/private/etc/aliases.db" \
    --exclude "/private/etc/cups/certs" \
    --exclude "/private/etc/krb5.keytab" \
    --exclude "/private/etc/master.passwd" \
    --exclude "/private/etc/openldap/DB_CONFIG.example" \
    --exclude "/private/etc/openldap/slapd.conf.default" \
    --exclude "/private/etc/racoon/psk.txt" \
    --exclude "/private/etc/security/audit_control" \
    --exclude "/private/etc/security/audit_user" \
    --exclude "/private/etc/sudo_lecture" \
    --exclude "/private/etc/sudoers" \
    --exclude "/private/tmp" \
    --exclude "/private/var" \
    --exclude "/System" \
    --exclude "/System/Library/Caches" \
    --exclude "/System/Library/DirectoryServices" \
    --exclude "/System/Library/User Template" \
    --exclude "/tmp" \
    --exclude "/Users/cec/.cache" \
    --exclude "/Users/cec/.local/share/Trash" \
    --exclude "/Users/cec/.npm/_cacache" \
    --exclude "/Users/cec/.Trash" \
    --exclude "/Users/cec/.viminfo" \
    --exclude "/Users/cec/Dropbox/.dropbox.cache" \
    --exclude "/Users/cec/Library/Application Support/Google/Chrome" \
    --exclude "/Users/cec/Library/Application Support/Steam/appcache" \
    --exclude "/Users/cec/Library/Caches" \
    --exclude "/Users/cec/Library/Containers/com.apple.geod/Data/Library/Caches" \
    --exclude "/Users/cec/Library/Safari" \
    --exclude "/Users/cec/Library/Suggestions" \
    --exclude "/Users/cec/Library/VoiceTrigger/SAT" \
    --exclude "/Users/cec/Music" \
    --exclude "/Users/cec/Pictures" \
    --exclude "/Users/cec/Movies" \
    --exclude "/Users/cec/tmp" \
    --exclude "/Users/Guest" \
    --exclude "/usr/bin/sudo" \
    --exclude "/usr/libexec/cups/backend" \
    --exclude "/usr/libexec/firmwarecheckers" \
    --exclude "/usr/libexec/security_authtrampoline" \
    --exclude "/usr/libexec/ssh-keysign" \
    --exclude "/usr/local/texlive" \
    --exclude "/usr/sbin" \
    --exclude "/Volumes" \
    --exclude "Library/Backblaze.bzpkg" \
    --exclude "Library/Containers/com.docker.docker" \
    $@
}

omar_full_backup() {
  omar_have_my_photos
  omar_have_my_music
  omar_have_my_movies
  omar_have_my_files
}
