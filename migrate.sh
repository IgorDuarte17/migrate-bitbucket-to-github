#!/bin/bash

# set this as your github credentials
GITHUB_USER=user@domain.com 
GITHUB_PASSWORD=password  
GITHUB_USERNAME=UserName 

# set this as your bitbuckt credentials
BITBUCKET_USER=user@domain.com 
BITBUCKET_PASSWORD=password
BITBUCKET_USERNAME=UserName

set -e
repos=$(bb list -u $BITBUCKET_USER -p $BITBUCKET_PASSWORD --private | grep $BITBUCKET_USERNAME | cut -d' ' -f3 | cut -d'/' -f2)
for repo in $repos; do
  echo
  echo "* Processing $repo..."
  echo
  git clone --bare git@bitbucket.org:$BITBUCKET_USERNAME/$repo.git 
  cd $repo.git
  echo
  echo "* $repo cloned, now creating on github..."  
  echo
  curl -u $GITHUB_USER:$GITHUB_PASSWORD https://api.github.com/user/repos -d "{\"name\": \"$repo\", \"private\": true}"
  echo
  echo "* mirroring $repo to github..."  
  echo
  git push --mirror git@github.com:$GITHUB_USERNAME/$repo.git && \
  bb delete -u $BITBUCKET_USER -p $BITBUCKET_PASSWORD --owner $BITBUCKET_USERNAME $repo    
  cd ..  
done
