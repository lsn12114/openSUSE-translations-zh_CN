#!/bin/bash

# Runs 'svn up' per language by default

WANTED_LANGS="cs de es fr hu pl"
# I'd probably better use a dedicated (fresh?) checkout every time
SVN_OUT=~ke/src/suse-i18n/trunk/packages
MERGE_CMD=../lcn/50-tools/lcn-merge.sh

cd $SVN_OUT || {
  echo $0 $SVN_OUT not avaialble
  exit 1
}

[ -x $MERGE_CMD ] || {
  echo $0 $MERGE_CMD not avaialble
  exit 1
}

# skip init (-s)
# commit automatically (-c)
$MERGE_CMD --commit --skip-init --lang $WANTED_LANGS

exit 0
