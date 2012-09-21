#!/bin/bash
# Merging script for bidirectional update of a transifex project with svn
LANGNAME="ru"
# Usage validation
[ $# -ne 0 ] || {
    echo "Usage: tx-merge.sh <language name>"
    exit 1
  }
# Set language's name
LANGNAME=$1

[ -d $LANGNAME/po ] || {
    echo "Specified language not found or invalid! CWD must be in your project's root."
    exit 2
  }

WD="$LANGNAME/po"
#tx pull --> заполнить память переводов --> svn update
echo "Checking for new translations..."
tx pull -l $LANGNAME
msgcat -o $WD/../packages.$LANGNAME.po --no-wrap --use-first $WD/gnome.$LANGNAME.po $WD/kde.$LANGNAME.po $WD/base*.$LANGNAME.po $WD/dvd*.$LANGNAME.po $WD/factory*.$LANGNAME.po
echo "Updating working copy..."
svn update
#использовать память переводов --> svn commit --> tx push
echo "Merging new translations..."
for resource in gnome kde base1 base2 dvd1 dvd2 dvd3 dvd4 dvd5 dvd6 dvd7 factory1 factory2 factory3 factory4 factory5 factory6 factory7;
do
  if [ -f $WD/../p.po ]
  then
    msgmerge --no-wrap -C $WD/../p.po -C $WD/../packages.$LANGNAME.po -U --previous $WD/$resource.$LANGNAME.po 50-pot/$resource.pot
  else
    msgmerge --no-wrap -C $WD/../packages.$LANGNAME.po -U --previous $WD/$resource.$LANGNAME.po 50-pot/$resource.pot
  fi
done
echo "Committing to SVN..."
svn ci -m "Automerged from transifex"
echo "Pushing to transifex..."
tx push -t -l $LANGNAME
echo "All done!"
exit 0
