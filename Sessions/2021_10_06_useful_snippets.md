## Useful code snippets:

**Short cut connecting to Eddie**
Instead of typing out the really long ssh command to connect to eddie you could do something like this:
```
history | grep ssh
```
1. `history` shows you the history of commands you have used.
2. `|` this is a pipe which puts the output of `history` into `grep`.
3. `grep` is a search command which searches all the commands in your history for the term `ssh`.
4. This returns some numbers and the command. We can now choose the number in our history assigned to the command we want to run and use `!`. eg: `! 497` and that will run the command next to the number 497.

**Removing multiple files from git**
I've found when I have both files to `git add` and `git rm` in the same directory I can't give the directory path to add them all because of the deleted files. Annoyingly this means copying and pasting each file to `git rm` manually. This command will `git rm` all removed files. Just be careful that you do want to `git rm` all these files!
```
git rm `git status | grep deleted | awk '{print $3}'`
```

**Size of directories**
Useful for seeing how much space you are using on Eddie. The first command returns the total size of the folder "PRS_project/" the seccond command uses `*` which returns the size of everything withint the "PRS_project/" folder, ie. all the subdirectories.
```
du -sh /exports/igmm/eddie/GenScotDepression/amelia/PRS_project/
du -sh /exports/igmm/eddie/GenScotDepression/amelia/PRS_project/* | sort -h
```



