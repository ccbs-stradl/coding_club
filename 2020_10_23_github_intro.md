## KT Coding Club: Introduction to Git and Github

### Checklist:

1. [Instal Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) on your computer.
<br />
    *Easiest way to do this on UNIX OS is to use the package manager [Homebrew](https://brew.sh/):*
    ``` brew install git ```
<br />
2. Create a Git repository.

    - Change directory to a folder you want to put on Github:
    *NB. Stay in this directory for the commands after this too.*
    ```
    cd path/to/your/folder
    ```
    - Initialise your Git repo:
    ```
    git init
    ```

3. Create a [.gitignore](https://www.pluralsight.com/guides/how-to-use-gitignore-file) file:

    - Create a new file called .gitignore
    <br />
    *Note that any files with a "." in front of them are hidden. On Mac use Command+Shift+Dot to toggle between these files shown or hidden in Finder.*
    ```
    touch .gitignore
    ``` 
    - Open it in a text editor (eg. [vi](https://www.washington.edu/computing/unix/vi.html)) and add any filenames or folders you don't want to commit. Include any large files in this.
    ``` 
    vi .gitignore
    ```

4. Create a README.md file:
    - This is a file that explains the project. We will have a session in the future on what should be included in a good README. 
    - The language this file is written in is ["markdown"](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)
    - Similar to creating our .gitignore file we can create a README.md and edit it in vi or your text editor of choice.
    ```
    touch README.md
    vi README.md
    ```

5. Make your first commit.
    - Add all files in current folder to the staging area:
    ```
    git add .
    ```
    or just some of the files
    ```
    git add file_name
    ```
    - "Commit" these changes to your repository:
    ```
    git commit -m "Short descriptive message detailing the commit. eg. Create repo"
    ```

6. Put your Git repo onto Github:
    - Go to [Github](www.github.com)
    - Click on "New" in the top left.
    <br />
    ![Repo](/Users/aes/OneDrive - University of Edinburgh/PhD/Meetings/Coding Club/markdown_images/github_repo.png)
    - Enter the name of your project and choose whether to make it private or public.
    *NB If you don't have the option to make it private you need to change your settings to a student account associated with your university email address.*
    <br />
    ![Repo](/Users/aes/OneDrive - University of Edinburgh/PhD/Meetings/Coding Club/markdown_images/github_repo2.png)
    - Push your existing repo from the command line:
    ```
    git remote add origin git@github.com:AmeliaES/coding_club.git
    git branch -M main
    git push -u origin main
    ```



7. Now you're set up and your repo is on Github implement this workflow after making changes that you want to commit:

```
git init
git add ProjectFolderName
git commit -m
git remote add origin https://github.com/YourGithubUsername/RepositoryName.git
git push -u origin master
```
<br />
### Other useful links:
- [Github cheatsheet](https://education.github.com/git-cheat-sheet-education.pdf)


<br />