#!/bin/sh
set -e

display_usage() {
  echo "Downloads all of a SourceForge project's files."
  echo -e "\nUsage: ./sourceforge-file-download.sh [project name]\n"
}

if [ $# -eq 0 ]
then
  display_usage
  exit 1
fi

project=$1
echo "Downloading $project's files"

# download all the pages on which direct download links are
# be nice, sleep a second
wget -w 1 -np -m -A download https://sourceforge.net/projects/$project/files/

# find the files (ignore "latest" link, that should be included as another URL already)
find sourceforge.net/ | sed "s#.*${project}/files/##" | grep download$ | grep -v "latest/download" | sed -e "s#^#https://master.dl.sourceforge.net/project/${project}/#" -e "s#/download#?viasf=1#" > urllist

# download each of the extracted URLs, put into $projectname/
while read url; do wget --content-disposition -x -nH --cut-dirs=1 "${url}"; done < urllist

# remove ?viasf=1 suffix
find . -name '*?viasf=1' -print0 | xargs -0 rename --verbose "?viasf=1" ""

# remove temporary files, unless you want to keep them for some reason
rm -ri sourceforge.net/
rm -i urllist
