Using the pipe (%\>%) operator in R
================
Amelia Edmondson-Stait
25/11/2020

### What are pipes?

Only recently discovered how amazingly useful pipes are and finally got
round to figuring out how to start using them and improve my code to
become more efficient and readable.

**“The pipe operator will forward a value, or the result of an
expression, into the next function call/expression.”**

The `magrittr` package contains this useful pipe operator `%>%`
discussed in this doc. Load package and create dummy GWAS summary
statistic data to use in this doc.

``` r
# Load libraries
library(tidyverse) # For %>%, also loads other useful packages (see resources links at end of this doc).
library(stringi) # For creating random character vectors
```

``` r
# Create dummy data
CHR <- unlist(lapply(1:22, function(x) rep(x, 10)))
SNP <- paste("rs", round(runif(220, min=11250701, max=185339560),0), sep = "")
BP <- round(runif(220, min=151476, max=2622752),0)
A1 <- stri_rand_strings(220, 1, pattern = "[ATCG]")
A2 <- rep(NA, 220)
A2[A1 == "A"] <- "T"
A2[A1 == "T"] <- "A"
A2[A1 == "G"] <- "C"
A2[A1 == "C"] <- "G"
OR <- runif(220, min=0, max=1)
P <- runif(220, min=0.000000001, max=0.98347)

# Create dataframe
sumstats <- data.frame("CHR" = CHR, "SNP" = SNP, "BP" = BP, "A1" = A1, "A2" = A2, "OR" = OR, "P" = P)

head(sumstats)
```

    ##   CHR         SNP      BP A1 A2        OR          P
    ## 1   1 rs169577724 1299355  A  T 0.2967200 0.18669086
    ## 2   1  rs20516056 1069105  G  C 0.6981335 0.67922492
    ## 3   1 rs130240283 1330981  A  T 0.2561950 0.77070019
    ## 4   1 rs117293838  682986  G  C 0.4991760 0.55590438
    ## 5   1 rs152731599 1178309  T  A 0.9354692 0.06191494
    ## 6   1  rs74813939 2493199  G  C 0.7158471 0.14075606

### How can we use pipes?

In R, there are many ways of performing the same task. First I’ll
demonstrate a long-winded way without using pipes. I would like to
subset my dataframe to only contain chromosome 1 and sort this new
dataframe based on ascending P values. Sorting a dataframe based on the
order of another column or vector is something I do alot.

``` r
sumstatrs_chr1 <- sumstats[sumstats$CHR == 1,][order(sumstats[sumstats$CHR == 1,]$P), ]
sumstatrs_chr1
```

    ##    CHR         SNP      BP A1 A2        OR          P
    ## 5    1 rs152731599 1178309  T  A 0.9354692 0.06191494
    ## 9    1  rs37912199 1348439  G  C 0.8107235 0.08953468
    ## 6    1  rs74813939 2493199  G  C 0.7158471 0.14075606
    ## 1    1 rs169577724 1299355  A  T 0.2967200 0.18669086
    ## 7    1 rs137895499  995413  C  G 0.3357441 0.25338294
    ## 8    1  rs69467042  639662  C  G 0.6164725 0.32270005
    ## 4    1 rs117293838  682986  G  C 0.4991760 0.55590438
    ## 2    1  rs20516056 1069105  G  C 0.6981335 0.67922492
    ## 3    1 rs130240283 1330981  A  T 0.2561950 0.77070019
    ## 10   1  rs81192722  607216  A  T 0.8698003 0.83427490

You can see that this did what I wanted it to, but it’s really not an
easy to read piece of code. I could overcome this by creating
intermediate variables. Such as:

``` r
sumstatrs_chr1_int <- sumstats[sumstats$CHR == 1,]
sumstatrs_chr1 <- sumstatrs_chr1_int[order(sumstatrs_chr1_int$P), ]
```

But we don’t need these intermediate variables so it’s a bit annoying to
create them. It also makes the code hard to follow in the next line
where we use our intermediate variable.

So what about just overwriting the intermediate variable, like this:

``` r
sumstatrs_chr1 <- sumstats[sumstats$CHR == 1,]
sumstatrs_chr1 <- sumstatrs_chr1[order(sumstatrs_chr1$P), ]
```

But this isn’t really a good idea either, what if you make a mistake you
then have to recreate `sumstats_chr1` which could take a while and also
your prone to getting in a muddle if you do this (I speak from
experience\!).

So let’s try and get the same output but use pipes instead to make our
code much more readable.

``` r
sumstats_chr1 <- sumstats %>%
                 filter(CHR == 1) %>%
                 arrange(P)
```

This is much easier to read and follow.

### Problems I’m still trying to figure out the answers for

As you can see when I created the dummy data I could have used pipes
then to make it easier to understand how I made `SNP`. But I’m having
some issues with this, how can I specify that I want `x` to be the
output from the `round(0)` function?

``` r
SNP <- runif(220, min=11250701, max=185339560) %>%
  round(0) %>%
    paste("rs", x, sep = "") # This line won't work as I haven't defined x.
```

#### Solution

During coding club session Hon Wah helpfully told me you can use `.` in
place of `x` and this will work\!

``` r
SNP <- runif(220, min=11250701, max=185339560) %>%
  round(0) %>%
    paste("rs", ., sep = "") 
SNP[1:10]
```

    ##  [1] "rs114375437" "rs120054546" "rs183978719" "rs156412780" "rs177030363"
    ##  [6] "rs170307882" "rs132546455" "rs155696841" "rs73273762"  "rs122681020"

As I said, only just started playing around with using pipes so would
appreciate any tips or reccomendations of `dplyr` functions to use with
them to wrangle dataframes in R.

### Resources:

  - <https://www.datacamp.com/community/tutorials/pipe-r-tutorial>
  - <https://cfss.uchicago.edu/notes/pipes/>
  - <https://uc-r.github.io/pipe>
  - <https://style.tidyverse.org/pipes.html>
  - <https://www.tidyverse.org/packages/>
