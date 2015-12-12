#!/bin/sh

#args
repoName=$1
oldEmail=$2
correctName=$3
correctEmail=$4

git clone --bare https://github.com/zypherman/$repoName.git
cd $repoName.git

git filter-branch --env-filter '

OLD_EMAIL="'$oldEmail'"
CORRECT_NAME="'$correctName'"
CORRECT_EMAIL="'$correctEmail'"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

git push --force --tags origin 'refs/heads/*'

cd ..
rm -rf $repoName.git

