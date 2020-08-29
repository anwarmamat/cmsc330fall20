# Git Cheatsheet

## Introduction

Welcome to CMSC330! This semester we will be using git to distribute projects,
and we urge you to use it locally in order to track your progress as you work.
This cheat sheet will show you the basics you will need for the semester.

## Working With git Locally

### Staging Changes

Use `git add` to stage changes. Staged changes will be committed in the next
commit.

`git add <file_name>` --- Stage the `example.txt` file

`git add .` --- Stage everything in the working directory (and below)

### Unstaging Files

If you stage some changes and later decide that you don't want to commit them,
you can unstage them (so that it will not be committed in the next commit) using

`git reset HEAD <file_name>`

### Seeing Your Status

To see the status of your git repository, use the `git status` command. This
command helpfully tells you what changes are currently uncommitted in your
repository, and which of those changes are staged to be committed.

### Viewing Changes

After you've changed and/or staged some files, you may want to see the exact
changes that were made. You can do this using the `git diff` command.

`git diff [<file_name>]` --- Show the changes that have been made (**but not
staged**) in the repository. If you specify `<file_name>`, only the changes for
that file will be shown. You can also specify a directory or multiple files.

`git diff --staged [<file_name>]` --- Show the exact changes that have been
staged in the repository (i.e. all the changes that will be committed in the
next commit). If you specify `<file_name>`, only the changes for that file will
be shown. You can also specify a directory or multiple files.

### Committing changes

Once you've made and staged some changes, you can commit your changes using the
`git commit` command.

`git commit` --- Commit your staged changes. After running this command, you
will be given the opportunity to enter a message.

`git commit -v` --- Commit your changes, and also show your changes while
writing your commit message.

`git commit -m 'Test commit, please ignore'` --- The `-m` flag allows you to
specify a short commit message directly on the command line. Remember to keep
your commit messages descriptive when possible.

`git commit -a` --- Commit all changes in the repo, whether or not they have
been staged.

### Viewing Old Commits

When working on a large project, it is often useful to revisit old commit
messages to remind yourself of previous work. You can do this with the `git log`
command.

`git log` --- See the commit log for the repository.

`git log --oneline` --- See the abbreviated commit log for the repository. With
this option, you will only see one line from the commit message for each commit,
and extra information such as the date of the commit and its author will not be
shown.

## Working With git Remotely

So far we have covered how to use git on your own machine to track your changes
and progress on a project, however git is also useful for distributed version
control. In this class, you will use git to get the starter files for each
project.

### Cloning a Repository

To acquire starter files in this class, you will be using the `git clone`
command.

`git clone <url_of_repository> [<local_name>]` --- Clone the repository at the
URL. If `local_name` is given, the repository will be cloned into a directory
with that name. Otherwise, the remote name of the repository will be used.

For example, to clone the main repository for this class, you could run

```
git clone https://github.com/anwarmamat/cmsc330spring18-public.git cmsc330
```

### Updating a Cloned Repository

Cloning a repository only gives you the repository at the time of cloning, it
does not keep your local repository in sync with the remote repository. The
simplest way to update the state of your repository to reflect that of the
remote repository is using the `git pull` command.

For example, when the starter files for the second project are posted, you will
want to run `git pull` inside of your cmsc330 directory to get the new files.

# Important Note

Please recall that you may not under any circumstances post code for this course
to a public github/bitbucket/gitlab repository under any circumstances, and that
doing so will be considered academic dishonesty even if the code was posted by
accident.

# Additional Resources

This cheatsheet has everything you need to know about git for CMSC330, but there
is much more to learn! If you are interested, check out the
[git book](https://git-scm.com/book/en/v2) for a complete reference.
Specifically, you may want to look into branching and merging---two **very**
powerful features of git. If you want to know more about a specific git
subcommand (such as `git add`), you can also refer to their man pages. The
entries for these commands can be found by joining git and the name of the
subcommand with a dash, like so: `man git-add`, `man git-commit`, `man
git-diff`.
