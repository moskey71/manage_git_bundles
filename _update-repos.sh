#!/bin/bash

STARTDIR=$(pwd)

if [ -d $STARTDIR/_bundles ]
  then
    echo "_bundles folder already exists.  skipping folder creation"
  else
    echo "Creating _bundles folder..."
    mkdir $STARTDIR/_bundles
  fi

clone_repo(){
git clone $1
}


input="$STARTDIR/_repo_source_list.txt"
while IFS= read -r line
do

  REPO=$(basename $line .git)
  REPOFOLDER=$STARTDIR/$REPO
  echo "repofolder is" $REPOFOLDER
  if [ -d $REPOFOLDER ]
  then
    echo "$REPO already exists. Skipping folder creation..."
  else
    echo "Cloning $REPO"
    clone_repo $line
fi
done < "$input"

update_repos(){
echo "Entering $1 directory..."
cd $STARTDIR/$1
echo "Fetching updates..."
git fetch --all
echo "Exporting git bundle to $STARTDIR/_bundles/$1.bundle..."
git bundle create $STARTDIR/_bundles/$1.bundle --all
}

dirs=$(ls -d */ -1 | sed 's/\///' | sed 's/\<_bundles\>//')

for i in $dirs
do
  echo "Updating $i repo..."
  update_repos $i
done

