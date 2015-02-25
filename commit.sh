#!/bin/bash

if [ "$1" == "" ]
then
    echo "Usage: commit.sh commit message"
    exit 1
fi

git add *
git commit -m "$*"
git push origin gh-pages
git checkout master
git merge gh-pages
git push origin master
git checkout gh-pages
