devonthink-open-databases() {
  # Open all of the DEVONthink databases.
  # Usage: $ devonthink-open-databases
  local database_dir=~/Applications/DEVONthink

  for f in $(ls "$database_dir"); do
    echo $f
    open $f
  done
}
