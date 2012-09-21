#! /bin/sh

set -e
curl -s http://download.opensuse.org/factory/repo/oss/suse/setup/descr/packages.en.gz | gzip -c -d > packages.en
curl -s http://download.opensuse.org/factory/repo/oss/suse/setup/descr/packages.gz | gzip -c -d > packages
git clone --depth 1 git://gitorious.org/opensuse/package-lists.git
rm -rf lists
mv package-lists/output/opensuse lists
rm -rf package-lists
cd lists
cat gnome_cd.i586.list gnome_cd.x86_64.list | sort -o gnome.list -u
rm gnome_cd.i586.list gnome_cd.x86_64.list
cat kde4_cd.i586.list kde4_cd.x86_64.list | sort -o kde.list -u
rm kde4_cd.i586.list kde4_cd.x86_64.list
cat gnome.list kde.list | sort | uniq -c | grep " 2 " | sed -e "s,.* 2 ,," > base.list
cat base.list kde.list | sort | uniq -u > kde.list.new && mv kde.list.new kde.list
cat base.list gnome.list | sort | uniq -u > gnome.list.new && mv gnome.list.new gnome.list
cat dvd-* | sort -u > dvd.list
# duplicate 
cat base.list kde.list gnome.list >> dvd.list
rm dvd-*
cat base.list dvd.list kde.list gnome.list | sort | uniq -u > dvd.new && mv dvd.new dvd.list
grep =Pkg: ../packages | cut '-d ' -f2 > factory.list
cat base.list dvd.list kde.list gnome.list dvd.list factory.list | sort | uniq -u > factory.new && mv factory.new factory.list

head -n 500 base.list > base1.list
tail -n +501 base.list > base2.list
rm base.list

for i in `seq 1 6`; do
  head -n 500 dvd.list > dvd$i.list
  tail -n +501 dvd.list > new && mv new dvd.list
done
mv dvd.list dvd7.list

for i in `seq 1 6`; do
  head -n 500 factory.list > factory$i.list
  tail -n +501 factory.list > new && mv new factory.list
done
mv factory.list factory7.list

cd ..

perl 50-tools/translate_packages.pl lists/base1.list packages packages.en > 50-pot/base1.pot
perl 50-tools/translate_packages.pl lists/base2.list packages packages.en > 50-pot/base2.pot
perl 50-tools/translate_packages.pl lists/kde.list packages packages.en > 50-pot/kde.pot
perl 50-tools/translate_packages.pl lists/gnome.list packages packages.en > 50-pot/gnome.pot
for i in `seq 1 7`; do
 perl 50-tools/translate_packages.pl lists/dvd$i.list packages packages.en > 50-pot/dvd$i.pot
done
for i in `seq 1 7`; do
 perl 50-tools/translate_packages.pl lists/factory$i.list packages packages.en > 50-pot/factory$i.pot
done

for i in 50-pot/*.pot; do 
  msguniq --use-first -o $i $i 
done

cd 50-pot
prev=base1.pot
for pot in base2.pot kde.pot gnome.pot dvd*.pot factory*.pot; do
  for oldpot in $prev; do
    # first duplicate
    msgcat --use-first -o $pot $pot $oldpot
    # then take uniques
    msgcat -s --use-first -u -o $pot $pot $oldpot
  done
  prev="$prev $pot"
done

for i in *.pot; do echo -n "$i: "; msgfmt --statistics $i; done

cd ..

rm -rf lists packages.en packages
