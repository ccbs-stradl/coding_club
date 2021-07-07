# Learn to love the command line
Inspired by this [article](https://www.nature.com/articles/d41586-021-00263-0) on "Five reasons why researchers should learn to love the command line" I thought we could have a session going over some commands that our group may find useful.
Note, the author of that article also wrote some nice code snippets to try out [here](https://github.com/jperkel/nature_bash).

## What can the command line be useful for:
- wrangling files (sometimes quicker than loading large files into R)
- handling big data
- manipulate spreadsheets

## Some useful commands:
### Basic commands
#### Working with directories
`pwd` - prints working directory

`cd ~/Coding\ Club/Sessions/command_line_data` - Change directory. Note that special characters such as spaces have to be escaped with a back slash. "~" denotes your home directory.

`cd ../` - Go back one directory

`cd - ` - Go back to last directory you switched from.

`ls` - List what is inside a directory

`ls -la` - List hidden files (precede with ".")

#### Viewing files using head, less and cat
```
head GeneList.txt
less GeneList.txt
cat GeneList.txt
```
*Q. How do you exit viewing a file with `less`?*

#### Making new folders and files
```
mkdir new_folder
ls
cd new_folder
touch new_file
ls
```
#### Copying or moving files
```
cp new_file ../new_file_copy
ls
ls ../
mv new_file ../
ls
ls ../
```
#### Removing files and folders
```
cd ../
ls
echo new_folder
rm -r new_folder
ls
rm new_*
```
#### Count number of lines in a file/directory
```
wc -l GeneList.txt
```
#### Printing variables or strings using echo
```
ANOTHER_DIR="../../"
cd $ANOTHER_DIR
pwd
cd -
```

### Pipes
```
ls | wc -l
```

### for loops
```
for i in 1 2 3 4 5
do
   echo "Welcome $i times"
done
```
On named variables:
```
files='file1 file2 file3'
for file in $files
do
echo "This $file is printed"
done
```
On output of a linux command:
```
for file in $(ls)
do
echo "This $file is in this directory"
done
```
Example of using for loops to submit jobs on Eddie:
```
for i in {0..5350000..50000}
do
    x=$(($i+1))
    y=$(($i+50000))
    name="GWAS_"
    name=$name$x
    qsub -N $name -v x=$x,y=$y  Scripts/job_scripts/job_GWAS.sh
done
```

### if statements
```
if [ -f GeneList.txt ]
then
echo "This file exists"
fi
```
### Searching files and directories using grep
```
grep "TNFRSF18" GeneList.txt 
grep -r "TNFRSF18" ./
grep -v "TNFRSF18" GeneList.txt 
grep -o "TNFRSF18" GeneList.txt
grep -n "TNFRSF18" GeneList.txt
grep -on "TNFRSF18" GeneList.txt 
```

### Filtering data using awk
Subset file to CHR 6 (2nd column):
```
awk '{ if ($2 == 6) { print } }' dummy_GWAS_sumstats | head
```
Extract genes on any chromosome greater than 6:
```
awk '{ if($2 > 6) { print }}' dummy_GWAS_sumstats | head
```
Save as a new file:
```
awk '{ if($2 > 6) { print }}' dummy_GWAS_sumstats > dummy_GWAS_sumstats_CHR_subset
```
*Note if you use ">>" it will append to a file, if you use ">" it will overwrite if the file exists.*

### Extracting columns using cut
```
cut -d " " -f1-3 dummy_GWAS_sumstats | head
```
*Note if that was a .csv file then you would need `-d ","`*


## Practice questions using some of these commands:
Using the example data [here](command_line_data/) have a go at the answering following:
1. View the first 5 rows of the file to get a feel for what it contains and how it is formatted. Is the file white space or comma separated?
2. How many SNPs are in the file?
3. Create a subset of dummy_GWAS_sumstats including SNPs with MAF > 0.01 and INFO > 0.9 and save with a new filename dummy_GWAS_sumstats_QC. *Advanced - Check for and remove duplicate SNPs.*
4. Extract the first col of dummy_GWAS_sumstats file and save as a new file called dummy_GWAS_sumstats_SNPs.
5. Search for SNP ID "rs110489" and print the whole line in the console. *Advanced - try saving the p-value for that SNP as a new variable.*
6. Create a txt file called `cool_files_list.txt` which lists the paths to all the files in directory `some_cool_files/`.


------------------------------------
## Answers:
1. `head -n 5 dummy_GWAS_sumstats`. White space separated.
2. `wc -l dummy_GWAS_sumstats` returns 501. But be aware this also counts the header as a line, therefore no. of SNPs is actually 501 - 1 = 500.
3. `awk '{ if(($6 > 0.01) && ($7 > 0.9)) { print }}' dummy_GWAS_sumstats | head`
4. cut -d " " -f1 dummy_GWAS_sumstats > dummy_GWAS_sumstats_SNPs
5. `grep "rs110489" dummy_GWAS_sumstats`
6.
``` 
BASE_PATH=$(pwd)
for i in {1..22}
do
echo ${BASE_PATH}/some_cool_files/awesome_coding_file${i} >> cool_files_list.txt
done
```


