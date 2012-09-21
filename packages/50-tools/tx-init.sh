#!/bin/bash
# Initialisation script for maintaining a transifex project
project="openSUSE-packages"
# Usage validation
[ $# -ne 0 ] || {
    echo "Usage: tx-init.sh <project name>"
    exit 1
  }
# Set project's name
project=$1
# Check we are in the 'root' directory of a project
[ -d ?0-pot ] || {
    echo "Pot directory not found! CWD must be in your project's root."
    exit 2
  }
# Get the list of resources' names
pots=$(cd ?0-pot && ls -1 *.pot | sed -e 's,\.pot,,')
# Get the list of existing languages
langs= #Clear langs
# Every dir with a /po subdirectory gives us a language code
for i in *; do
  if test -d $i/po; then
    langs="$langs $i"
  fi
done

# Transifex initialisation
tx init
# Dealing with transifex resources
for pot in $pots; do
# Set all available resources
 tx set --source -r $project.$pot -l en 50-pot/$pot.pot
 for lang in $langs; do
#  Set all available languages
  tx set -r $project.$pot -l $lang $lang/po/$pot.$lang.po
 done
done
echo Done!
exit 0
