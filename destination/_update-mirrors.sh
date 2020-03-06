#!/bin/bash -e

STARTDIR=$(pwd)
MIRRORDIR=$STARTDIR/_mirrors
BUNDLEDIR=$STARTDIR/_bundles

if [ -d $STARTDIR/_bundles ]
  then
    echo "_bundles folder already exists.  Skipping folder creation."
    rm -rf $STARTDIR/_bundles/*
  else
    echo "Creating _bundles folder..."
    mkdir $STARTDIR/_bundles
  fi

if [ -d $STARTDIR/_mirrors ]
  then
    echo "_mirrors folder already exists.  Skipping folder creation"
  else
    echo "Creating _mirrors folder..."
    mkdir $STARTDIR/_mirrors
  fi

update_mirror(){
REPO=$( echo $1 | sed 's/\.git//g')
REPODIR=$MIRRORDIR/$REPO
BUNDLE=$( echo $1 | sed 's/\.git//g' | sed 's/[^_]*_//' )
BUNDLEFILE=$BUNDLEDIR/$BUNDLE.bundle
echo "Updating $REPODIR from git bundle $BUNDLEFILE..."
if [[ $(git -C $REPODIR remote -v | grep bundle) != *"bundle"* ]]
then
  echo "Adding bundle as remote..."
  git -C $REPODIR remote add bundle $BUNDLEFILE
else  echo "Bundle remote already added.  Continuing..."
fi
git -C $REPODIR pull bundle master
git -C $REPODIR pull bundle master --tags
git -C $REPODIR push origin master
git -C $REPODIR push origin master --tags --force
}

input="$STARTDIR/_repo_destination_list.txt"
while IFS= read -r line
do
  REPO=$(basename $line .git)
  REPODIR=$MIRRORDIR/$REPO
  echo "repofolder is" $REPODIR
  if [ -d $REPODIR ]
  then
    echo "$REPO already exists. Updating $REPO to latest..."
    git -C $REPODIR pull origin master
  elif [ git ls-remote $line && $? == 0 ]
  then
    echo "Cloning $REPO"
    git clone $line $REPODIR
  else
    echo "Creating new repo for $REPO"
    REPONAME=$( echo $REPO | sed 's/\.git//g' | sed 's/[^_]*_//' )
    BUNDLEFILE=$BUNDLEDIR/$REPONAME.bundle
    mkdir $REPODIR
    git clone $BUNDLEFILE $REPODIR
    git -C $REPODIR remote remove origin
    git -C $REPODIR remote add origin $line
    git -C $REPODIR remote add bundle $BUNDLEFILE
fi
update_mirror $REPO
done < "$input"
