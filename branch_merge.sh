#!/bin/sh
#branch_merge.sh
#add, commit, merge branch, and push
#by Jennifer E Volk
git add -A
git commit -m $1
git branch | grep \* | cut -d ' ' -f2 >$current_branch
git checkout master
git merge $current_branch
git push
