Using the pipe (%\>%) operator in R
================
Amelia Edmondson-Stait
25/11/2020

<style type="text/css">

body{ /* Normal  */
      font-size: 15px;
      font-family: Arial;
  }

code.r{ /* Code block */
    font-size: 15px;
}

</style>

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
    ## 1   1  rs16697717  403078  A  T 0.7708777 0.86231598
    ## 2   1  rs78186288  396013  C  G 0.8007381 0.75944668
    ## 3   1 rs164519684 2424170  T  A 0.9650990 0.00574205
    ## 4   1  rs12328485 1694320  T  A 0.5628832 0.86228896
    ## 5   1  rs56370834 2146365  G  C 0.2284547 0.29305531
    ## 6   1 rs161795206 1724189  A  T 0.8517711 0.07225551

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
    ## 3    1 rs164519684 2424170  T  A 0.9650990 0.00574205
    ## 6    1 rs161795206 1724189  A  T 0.8517711 0.07225551
    ## 9    1 rs101768370 1569996  T  A 0.7799010 0.23721997
    ## 5    1  rs56370834 2146365  G  C 0.2284547 0.29305531
    ## 2    1  rs78186288  396013  C  G 0.8007381 0.75944668
    ## 8    1  rs90491425 1522105  G  C 0.6604887 0.79129549
    ## 4    1  rs12328485 1694320  T  A 0.5628832 0.86228896
    ## 1    1  rs16697717  403078  A  T 0.7708777 0.86231598
    ## 10   1  rs87672412 1662268  A  T 0.4008049 0.90103415
    ## 7    1 rs124325976 1341914  G  C 0.8583100 0.94779839

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
                 arrange(match(P, sort(P)))
```

This is much easier to read and follow. However, I still don’t like the
third line where I am clustering `match` within `arrange`.

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

As I said, only just started playing around with using pipes so would
appreciate any tips or reccomendations of `dplyr` functions to use with
them to wrangle dataframes in R.

### Resources:

  - <https://www.datacamp.com/community/tutorials/pipe-r-tutorial>
  - <https://cfss.uchicago.edu/notes/pipes/>
  - <https://uc-r.github.io/pipe>
  - <https://style.tidyverse.org/pipes.html>
  - <https://www.tidyverse.org/packages/>
