#!/bin/bash -e

STARTDIR=$(pwd)
DAYS=

while [ "$1" != "" ]; do
    case $1 in
        -d | --days )           shift
                                DAYS=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ -z "$DAYS" ]
then
      DAYPARAM=
      echo "DAYS Parameter not set.  Will retrieve full git history"
else
      DAYPARAM="--since=$DAYS.days"
      echo "DAYS Parameter set to download last $DAYS days of commits.  Removing cached repos"
      rm -rf $STARTDIR/_reposource/*
fi

if [ -d $STARTDIR/_bundles ]
  then
    echo "_bundles folder already exists.  Skipping folder creation."
    echo "Removing existing bundles"
    rm -rf $STARTDIR/_bundles/*
  else
    echo "Creating _bundles folder..."
    mkdir $STARTDIR/_bundles
  fi

if [ -d $STARTDIR/_reposource ]
  then
    echo "_reposource folder already exists.  Skipping folder creation"
  else
    echo "Creating _reposource folder..."
    mkdir $STARTDIR/_reposource
  fi

update_repos(){

REPO=$(basename $line)
REPOFOLDER=$STARTDIR/_reposource/$REPO
BUNDLE=$(basename $line .git)
BUNDLEFILE=$STARTDIR/_bundles/$BUNDLE.bundle
echo "Exporting git bundle to $BUNDLEFILE..."
git -C $REPOFOLDER bundle create $BUNDLEFILE --tags --branches $DAYPARAM
}

input="$STARTDIR/_repo_source_list.txt"
while IFS= read -r line
do
  REPO=$(basename $line .git)
  REPOFOLDER=$STARTDIR/_reposource/$REPO.git
  echo "repofolder is" $REPOFOLDER
  if [ -d $REPOFOLDER ]
  then
    echo "$REPO already exists. Updating $REPO to latest..."
    git -C $REPOFOLDER fetch --all --prune
  else
    echo "Cloning $REPO"
    git clone $line $REPOFOLDER --mirror
fi
update_repos $line
done < "$input"
