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

Four common operations that it is worthwhile knowing the built-in
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

Extraneous whitespace is usually not a problem in well-curated datasets,
but it can crop up in older and ad-hoc files, particularly when data has
been copied and pasted into a spreadsheet. `trimws()` can be used to
*trim* whitespace at the start or end of a string

``` r
icd10_with_ws <- c("F41 ", " F32", "I11  ", "   E112")
trimws(icd10_with_ws)
```

    ## [1] "F41"  "F32"  "I11"  "E112"

### Finding strings (`grep`)

Strings can be searched with `grep()` (\_g\_lobally search for a
\_r\_egular \_e\_xpression and \_p\_rint matching lines). For now we
will just search for string literals. In a future session, we will look
at more flexible searching using regular expressions.

Unlike most commands, the object that `grep()` operates on (a character
vector) is the second argument. The first argument is the thing being
search for. For example, to find diagnoses inthe `icd10` vector that
start with “F”:

``` r
grep(pattern="F", x=icd10)
```

    ## [1] 1 2

Grep returns the indices of the elements that match, so it can be used
to subset the array being searched through

``` r
icd10[grep("F", icd10)]
```

    ## [1] "F410" "F322"

A shortcut for doing the same thing is with the `value=TRUE` argument

``` r
grep("F", icd10, value=TRUE)
```

    ## [1] "F410" "F322"

`grepl()` returns `TRUE` or `FALSE` for each match

``` r
grepl("F", icd10)
```

    ## [1]  TRUE  TRUE FALSE FALSE

`grepl()` is therefore useful for things like `ifelse()` statements

``` r
ifelse(grepl("F", icd10), yes='mental health', no='physical health')
```

    ## [1] "mental health"   "mental health"   "physical health" "physical health"

### String substitution (`gsub`)

Finding and replace can be done with `sub()` (which will replace the
first match) and `gsub()` (which will replace all matches).

``` r
sub(pattern="Head", replacement="Heid", x=classic_pub)
```

    ## [1] "The Sheep Heid Inn"

### String transformation (`toupper` and `tolower`)

Capitals can be converted to lowercase and vice-versa:

``` r
tolower("BE QUIET!!")
```

    ## [1] "be quiet!!"

``` r
toupper("evertything looks like shouting when it's in allcaps")
```

    ## [1] "EVERTYTHING LOOKS LIKE SHOUTING WHEN IT'S IN ALLCAPS"

String transformation and substitution can be useful for turning plain
labels into variable names or filenames. For example, a list of names:

``` r
buildings <- c("Ashworth Laboratories", "7 George Square", "Kennedy Tower")
building_labels <- tolower(gsub(" ", "_", buildings))
building_labels
```

    ## [1] "ashworth_laboratories" "7_george_square"       "kennedy_tower"

For a more advanced version of this, see the
[snakecase](https://cran.r-project.org/web/packages/snakecase/vignettes/caseconverters.html)
package.

### String separation (`strsplit`)

### String concatenation (`paste`)

Tidyverse: `stringr`
--------------------

Parsing dates (`lubridate`)
===========================
