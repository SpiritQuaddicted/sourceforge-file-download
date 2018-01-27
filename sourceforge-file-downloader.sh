#!/bin/sh

project=$1
echo "Downloading $project's files"

# download all the pages on which direct download links are
# be nice, sleep a second
wget -w 1 -np -m -A download http://sourceforge.net/projects/$project/files/

# extract those links
grep -Rh refresh sourceforge.net/ | grep -o "https[^\\?]*" > urllist

# remove temporary files, unless you want to keep them for some reason
rm -r sourceforge.net/

# download each of the extracted URLs, put into $projectname/
while read url; do wget --content-disposition -x -nH --cut-dirs=1 "${url}"; done < urllist

rm urllist
