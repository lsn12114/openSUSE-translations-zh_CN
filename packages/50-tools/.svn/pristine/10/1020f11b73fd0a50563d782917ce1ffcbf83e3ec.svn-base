pots=$(cd 50-pot && ls -1 *.pot | sed -e 's,\.pot,,')
# either merge languages given at the command line or all available directories
wanted_lang=${@:-*}
langs=
for i in $wanted_lang; do
  if test -d $i/po; then
    langs="$langs $i"
  fi
done

for lang in $langs; do
  msgcat --use-first -o $lang.po $lang/po/*.po
  for i in $pots; do
    perl 50-tools/extract_header.pl < $lang/po/$i.$lang.po  > $i.header
    msgmerge -C $lang.po $lang/po/$i.$lang.po 50-pot/$i.pot -o $lang/po/$i.$lang.po --previous
    msgcat -o $lang/po/$i.$lang.po  --use-first $i.header $lang/po/$i.$lang.po
    rm $i.header
  done
  rm $lang.po
done
