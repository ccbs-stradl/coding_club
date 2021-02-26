String manipulation and date parsing
================

*Aim: Learn how to extract information from strings (text and character
data) using regular expressions*

We will look at some built-in fucntions for working with strings
(`substr`, `strsplit`, `paste`) as well as their Tidy equivalents from
the [`tidyr`](https://tidyr.tidyverse.org) and
[`stringr`](https://stringr.tidyverse.org) packages. See also: [R For
Data Science Chapter 14: Strings](https://r4ds.had.co.nz/strings.html).

String manipulation
===================

A “string” is a sequence of symbols. In computer languages, strings are
typically a data structure for storing text information as a sequence of
letters, numbers, punctuation, and other language symbols. In R and most
programming languages, strings are demarcated by surrounding them by
single `'` or double `"` quotation marks.

``` r
"I like cats."
```

    ## [1] "I like cats."

``` r
"猫が大好き。"
```

    ## [1] "猫が大好き。"

In R, single or double quotation marks are functionally equivalent but
they have different meanings in other languages. For example in the C
programming language, single quotes are used to demarcate single
characters while double quotes must be used for strings. In bash, a
string in single quotes will be interpreted literally (as-is):

``` bash
echo 'Hi, $USER, the date is $(date +%Y-%m-%d)'
```

    ## Hi, $USER, the date is $(date +%Y-%m-%d)

while a string in double quotes allows string interpolation (where bash
will look through the string for meaningful punctuation and interpret it
as a command)

``` bash
echo "Hi, $USER, the date is $(date +%Y-%m-%d)"
```

    ## Hi, mark, the date is 2021-02-26

In R, strings are stored as type `character`

``` r
typeof("Hello, World")
```

    ## [1] "character"

Outside of string processing and text data storage, the main place in R
that `character` data shows up is in indexing into named elements of
vectors and lists (including `data.frame`s). E.g., a named vector:

``` r
sample_sizes <- c(cases=11795, controls=14084)
```

The elements can either be indexed with string *literals*

``` r
sample_sizes[["cases"]]
```

    ## [1] 11795

``` r
sample_sizes[["controls"]]
```

    ## [1] 14084

or with a variable assigned the value we want to extract

``` r
a <- "cases"
sample_sizes[[a]]
```

    ## [1] 11795

String escapes
--------------

The majority of alphabetic, numeric, and punctuation characters are
represented in a string just as they appear. Strings can also contain
special characters take on a meaning other than a literal character.
These are called “escape characters” (or, if they involve more than one
character, “escape sequences”) and are prepended with `\` (backslash).
The most common escape characters that you’ll encounter in data
processing are:

-   `\"` and `\'` to specify a double or single quote within a string.

``` r
"This double-quoted string needs to escape \"double\" quotes"
```

    ## [1] "This double-quoted string needs to escape \"double\" quotes"

``` r
'This single-quoted string needs to escape \'single\' quotes'
```

    ## [1] "This single-quoted string needs to escape 'single' quotes"

-   `\n` for line breaks (newline)

``` r
string_with_newlines <- "This\nstring\nhas\nseveral\nlines."
```

-   `\t` for tabs

``` r
string_with_tabs <- "This\tstring\tis\ttab\tseparated"
```

-   `\u` and `\U` for Unicode characters.

``` r
string_with_unicode <- "\U0001f978"
```

Displaying strings
==================

When echoed in the terminal, strings in R will be output just as they
appear in the source code, exactly as they were typed, including the
escape characters. To print an interpreted version of the string to the
screen, use the `cat()` function:

**Newlines**

``` r
string_with_newlines
```

    ## [1] "This\nstring\nhas\nseveral\nlines."

``` r
cat(string_with_newlines)
```

    ## This
    ## string
    ## has
    ## several
    ## lines.

**Tabs**

``` r
string_with_tabs
```

    ## [1] "This\tstring\tis\ttab\tseparated"

``` r
cat(string_with_tabs)
```

    ## This string  is  tab separated

**Unicode**

``` r
string_with_unicode
```

    ## [1] "\U0001f978"

``` r
cat(string_with_unicode)
```

    ## 🥸

``` r
"💀👻🐶🐱"
```

    ## [1] "\U0001f480\U0001f47b\U0001f436\U0001f431"

``` r
cat("💀👻🐶🐱")
```

    ## 💀👻🐶🐱

Built-in commands
-----------------

Three common operations that it is worthwhile knowing the built-in
commands for are counting, subsetting, splitting, and combining strings.

### Getting information about strings (`nchar`)

The number of characters in a string can be calculated with `nchar`

``` r
nchar("hello")
```

    ## [1] 5

This function can also processing vectors of characters

``` r
nchar(c("hello", "abracadabra"))
```

    ## [1]  5 11

**Quick question**: What information is `length("hello")` returning?

### Subsetting strings (`substr`)

Parts of a string can be extracted by character position using `subtr`
(substring). The third, fourth, and fifth characters of the word “hello”
can be extracted with

``` r
substr("hello", start=3, stop=5)
```

    ## [1] "llo"

Getting a part of a string using position is useful if all of the
strings you want to work with are of uniform length and formatting. For
example if you have a list of ICD-10 diagnoses:

``` r
icd10 <- c("F410", "F322", "I119", "E112")
```

and you want to extract information about which chapter the diagnoses
are from

``` r
table(substr(icd10, 1, 1))
```

    ## 
    ## E F I 
    ## 1 2 1

`substr` can also be used for assignment

``` r
classic_pub <- "The Sheep Head Inn"
substr(classic_pub, 13, 13) <- 'i'
classic_pub
```

    ## [1] "The Sheep Heid Inn"

### Cleaning up whitespace (`trimws`)

### String substitution (`gsub`)

### String transformation (`toupper` and `tolower`)

### String separation (`strsplit`)

### String concatenation (`paste`)

Tidyverse: `stringr`
--------------------

Parsing dates (`lubridate`)
===========================
