#!/bin/bash

STARTDIR=$(pwd)

if [ -d $STARTDIR/_bundles ]
  then
    echo "_bundles folder already exists.  Skipping folder creation"
  else
    echo "Creating _bundles folder..."
    mkdir $STARTDIR/_bundles
  fi

input="$STARTDIR/_repo_source_list.txt"
while IFS= read -r line
do

  REPO=$(basename $line .git)
  REPOFOLDER=$STARTDIR/$REPO.git
  echo "repofolder is" $REPOFOLDER
  if [ -d $REPOFOLDER ]
  then
    echo "$REPO already exists. Updating $REPO to latest..."
    git -C $REPOFOLDER fetch --all --prune
  else
    echo "Cloning $REPO"
    git clone $line --mirror
fi
done < "$input"

update_repos(){
REPO=$( echo $1 | sed 's/\.git//g')
echo "Exporting git bundle to $STARTDIR/_bundles/$REPO.bundle..."
git -C $STARTDIR/$1 bundle create $STARTDIR/_bundles/$REPO.bundle --tags --branches --since=10.days
}

dirs=$(ls -d */ -1 | sed 's/\///' | sed 's/\<_bundles\>//')

for i in $dirs
do
  echo "Creating bundle from $i repo..."
  update_repos $i
done
