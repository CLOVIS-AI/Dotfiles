# Git commands & aliases

This document is a list of aliases to help with Git management. When multiple commands are given, they are equivalent.

This file does not document *all* aliases, but only those that reflect a 'nice' workflow.

## Common

Display the list of aliases:

    git aliases

Display the list of collaborators:

    git shortlog -sn --no-merges
    git authors

Display the list of people who committed to the repository:

    git shortlog -esnc --no-merges
    git committers

## Staging & commiting

Display the status of the project (short):

    git status -sb
    git st

Display the status of the project (full):

    git status
    git sta

Select interactively which files you want to stage (red → green in `git status`):

    git add -p
    git ap

Note that new files do not appear in `git ap`. To add them:

    git add --intent-to-add [files...]
    git add-new-files [files...]
    git anf [files...]

Display changes that have not been added yet (red in `git status`):

    git diff
    git d

Displays changes that will be committed (green in `git status`):

    git diff --cached
    git dc

Commit the currently added files (green in `git status`) with help to follow the supported commit conventions:

    git ci

Edit the last commit:

    git commit --amend
    git ca

## Branches

Create a branch from the current HEAD and switch to it:

    git branch [name] && git checkout [name]
    git checkout -b [name]
    git switch -b [name]
    git co [name]

List local branches:

    git branch -vv
    git bl

List all (local & remote) branches:

    git branch -vva
    git bla

Switch branch:

    git checkout [name]
    git switch [name]
    git co [name]

Remove a branch safely:

    git branch -d [name]
    git bd [name]

Remove a branch (unsafe):

    git branch -D [name]

Remove a remote branch (unsafe):

    git bdr [remote] [branch]

Remove a branch on all remotes (unsafe):

    git bdrr [branch]

Remove a branch locally and on all remotes (unsafe):

    git bdrra [branch]

## Changing the history

Displaying the full history:

    git glog

Displaying the last 5 commits:

    git glog -5

Displaying the full history since yesterday:

    git glog --since yesterday

Displaying a simplified history:

    git glog --first-parent -10
    git g

Completely display the contents of a single commit:

    git show [commit]
    git s [commit]

Display the history, but sorted as a changelog:

    git changelog

Display the last merge-request/pull-request that was merged:

    git changelog --incoming

Smart merging of branches (local and/or remote):

    git review

Merge a branch into the current branch:

    git merge [other branch]

Abort the current merge:

    git merge --abort

Rebase the current branch onto another one:

    git rebase [other branch]

Edit the current branch:

    git rebase-me

Abort the current rebase:

    git rebase --abort
    git ra

Continue the current rebase:

    git rebase --continue
    git rc

Skip the current commit in the current rebase:

    git rebase --skip
    git rs

Copy a commit from another branch into the current branch (will probably create conflicts, only use if you're sure it's a good idea):

    git cherry-pick [commit]
    git cp [commit]

Remove the last commits:

    git remote-last-n-commits [number]

## Connecting to remotes

Add a remote:

    git remote add [name] [url]
    git r add [name] [url]

Rename a remote:

    git remote rename [name] [url]
    git rr [name] [url]

Update the local database of a remote:

    git fetch -p [remote]
    git f [remote]

Update the local database of all remotes:

    git fetch -a -p
    git fr

Link the current branch with a remote branch:

    git branch -u [remote/branch]
    git bu [remote/branch]

(for example: `git bu origin/master`)

Pull from a remote, using the default strategy (rebase by default):

    git pull
    git pl

Pull from a remote, but only if it's a fast-forward (no conflicts):

    git pull --ff-only --no-rebase
    git p

Pull from a remote, and create a merge if there is a conflict:

    git pull --no-rebase
    git pm

Pull from a remote, and create a merge even if there are no conflicts:

    git pull --no-rebase --no-ff
    git pm --no-ff

Merge by default in this project:

    git config pull.rebase false

Merge by default in this branch:

    git config branch.[name].rebase false
    git policy-merge

Rebase by default in this project:

    git config pull.rebase true

Rebase by default in this branch:

    git config branch.[name].rebase true
    git policy-rebase

Push to a remote:

    git push
    git ps

Push tags to a remote:

    git push --tags
    git pst

Push all branches to a remote:

    git push --all
    git ps --all

Force push to a remote (dangerous):

    git push -f
    git psf

Push to a remote and remember it:

    git push -u [remote] [branch]
    git psu [remote] [branch]

## Miscellaneous

List tags in chronological order:

    git tag --list --sort=-committerdate -n1
    git tags

Work with submodules:

    git submodule [commands...]
    git sub [commands...]

Initialize and update all submodules recursively:

    git submodule update --init --recursive
    git subi

Why is this file ignored?

    git check-ignore -v --no-index
    git why-ignore [file]
