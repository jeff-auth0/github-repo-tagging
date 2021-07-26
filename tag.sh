#!/bin/sh
set -e

version_type=$1
version_number=''
new_tag=''

branch=$(git branch --show-current)
if [ $branch != 'master' || $branch != 'main' ]
then
  tput setaf 1; echo 'Checkout master branch before proceeding'
  exit -1
fi

echo "Checking out master branch"
# make sure we are on master branch
git checkout $branch

echo "Pulling new changes for master branch"
#   # we are upto date with master branch
git pull --rebase origin $branch

## Get current version 
current_tag=$(git describe --tags --abbrev=0)
current_tag="${current_tag:1}"
if [ $version_type == 'major' ]
then
  version_number=0
elif [ $version_type == 'minor' ]
then
    version_number=1
elif [ $version_type == 'patch' ]
then
    version_number=2
else
  tput setaf 1; echo 'Usage:  ./build-new-tag.sh [major,minor,patch]'
  exit -1
fi

increment_version() {
  local delimiter=.
  local array=($(echo "$1" | tr $delimiter '\n'))
  array[$2]=$((array[$2]+1))
  if [ $2 -lt 2 ]; then array[2]=0; fi
  if [ $2 -lt 1 ]; then array[1]=0; fi
  new_tag=$(local IFS=$delimiter ; echo "${array[*]}")
}

confirm() {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}


release_new_tag(){
  # release a new tag
  echo "Releasing a new tag: v${new_tag}"
  git tag "v$new_tag"
  sleep 5

  # Push the new tag
  echo "Pushing tag: v${new_tag}"
  git push --tags origin

  echo "New tag v$new_tag pushed."
}

increment_version "$current_tag" "$version_number"

confirm "New tag will be: v${new_tag}. Do you want to continue ?" && release_new_tag
