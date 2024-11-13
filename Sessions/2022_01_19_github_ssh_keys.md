## Setting up SSH keys on Eddie to use with github

### Resources:
- Instructions on [github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

--------------------------------
1. Connect to Eddie

2. Generate key
Use the email address associated with your github account.
You can also add email addresses to your github account, by going to settings - Emails add email address.
```
# Have a look to see if you have existing keys.
ls .ssh/

# Generate a new key
ssh-keygen -t ed25519 -C "amelia.edmondson-stait@ed.ac.uk"

# Add the SSH key to the ssh-agent
ssh-add ~/.ssh/id_ed25519
```

Leave blank, or enter a file name, eg. github.
Leave passphrase blank.

3. Add ssh key to github account

```
cat .ssh/id_ed25519.pub
```
Manually copy the outputs from this. 

4. Go onto github.
5. Navigate to settings, click on SSH and GPG Keys.
6. Click on new ssh and add new, and add a title like "Eddie".
7. Paste contents of `cat .ssh/id_ed25519.pub` (including the email address).
7. Add the new key.

8. Try it to see if it works:
This will work if you have access to ccbs-stradl.
```
qlogin -l h_vmem=8G
git clone git@github.com:ccbs-stradl/genscot_linkage.git
cd genscot_linkage
```
If you get an error about not having permissions check you used the right email address when creating a key and also that you have access to the repository you are trying to clone.

Then get started using git! Here are some basic git commands from an earlier session: https://github.com/ccbs-stradl/coding_club/blob/main/Sessions/2020_10_23_github_intro.md

-------
There's also a way to add a key to your local computer and put the public key on Eddie so you don't have to type your password every time you want to log into Eddie. Some notes on that on [Eddie wiki](https://www.wiki.ed.ac.uk/display/ResearchServices/SSH+keys+best+practice+guide). **Please do not remove any keys from authorised_keys that are called "Alces HPC Cluster Key" as it will break your access to Eddie.**

