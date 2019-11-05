#!/bin/bash

STARTDIR=$(pwd)

clone_repo(){
git clone $1
}


input="$STARTDIR/_repo_source_list.txt"
while IFS= read -r line
do
  echo "$line"
  clone_repo $line
done < "$input"

[ -d $STARTDIR/_bundles ] || mkdir $STARTDIR/_bundles

update_repos(){
echo "Entering $1 directory..."
cd $STARTDIR/$1
echo "Fetching updates..."
git fetch --all
echo "Fetching tags..."
git fetch --tags
echo "Exporting git bundle to $STARTDIR/_bundles/$1.bundle..."
git bundle create $STARTDIR/_bundles/$1.bundle --all
}

dirs=$(ls -d */ -1 | sed 's/\///' | sed 's/"_bundles"//')

for i in $dirs
do
  echo "Updating $i repo..."
  update_repos $i
done

