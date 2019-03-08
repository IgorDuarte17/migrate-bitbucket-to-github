#!/bin/bash

# set this as your github credentials
GH_USER=user@domain.com 
GH_PASSWORD=password  
GH_USERNAME=UserName 

# set this as your bitbuckt credentials
BB_USER=user@domain.com 
BB_PASSWORD=password
BB_USERNAME=UserName

set -e
repos=$(bb list -u $BB_USER -p $BB_PASSWORD --private | grep $BB_USERNAME | cut -d' ' -f3 | cut -d'/' -f2)
for repo in $repos; do
  echo
  echo "* Processing $repo..."
  echo
  git clone --bare git@bitbucket.org:$BB_USERNAME/$repo.git 
  cd $repo.git
  echo
  echo "* $repo cloned, now creating on github..."  
  echo
  curl -u $GH_USER:$GH_PASSWORD https://api.github.com/user/repos -d "{\"name\": \"$repo\", \"private\": true}"
  echo
  echo "* mirroring $repo to github..."  
  echo
  git push --mirror git@github.com:$GH_USERNAME/$repo.git && \
  bb delete -u $BB_USER -p $BB_PASSWORD --owner $BB_USERNAME $repo    
  cd ..  
done
