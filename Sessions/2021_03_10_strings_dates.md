String manipulation and date parsing
================

*Aim: Learn how to process strings (text and character data) and parse
dates*

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

    ## Hi, mark, the date is 2021-03-10

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
sample_sizes
```

    ##    cases controls 
    ##    11795    14084

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
special characters that take on a meaning other than a literal
character. These are called “escape characters” (or, if they involve
more than one character, “escape sequences”) and are prepended with `\`
(backslash). The most common escape characters that you’ll encounter in
data processing are:

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
screen, use the `cat()` (“concatenate and print”) function:

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
=================

Five common operations that it is worthwhile knowing the built-in
commands for are counting, subsetting, splitting, searching, and
combining strings.

Getting information about strings (`nchar`)
-------------------------------------------

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

Subsetting strings (`substr`)
-----------------------------

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

Cleaning up whitespace (`trimws`)
---------------------------------

Extraneous whitespace is usually not a problem in well-curated datasets,
but it can crop up in older and ad-hoc files, particularly when data has
been copied and pasted into a spreadsheet. `trimws()` can be used to
*trim* whitespace at the start or end of a string

``` r
icd10_with_ws <- c("F41 ", " F32", "I11  ", "   E112")
trimws(icd10_with_ws)
```

    ## [1] "F41"  "F32"  "I11"  "E112"

Finding strings (`grep`)
------------------------

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

String substitution (`gsub`)
----------------------------

Finding and replace can be done with `sub()` (which will replace the
first match) and `gsub()` (which will replace all matches).

``` r
sub(pattern="Head", replacement="Heid", x=classic_pub)
```

    ## [1] "The Sheep Heid Inn"

String transformation (`toupper` and `tolower`)
-----------------------------------------------

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

String separation (`strsplit`)
------------------------------

A string can be divided into parts based on a specified `split`
sequence. For example, splitting a sentence into separate words.

``` r
strsplit("The quick brown fox jumps over the lazy dog", split=" ")
```

    ## [[1]]
    ## [1] "The"   "quick" "brown" "fox"   "jumps" "over"  "the"   "lazy"  "dog"

It can be useful for extracting parts of strings that are formatted in a
uniform way.

``` r
sessions <- c('2020-09-30', '2020-10-23', '2020-10-28', '2020-11-11', '2020-12-09', '2021-01-27', '2021-02-24', '2021-03-10')
sessions_ymd <- strsplit(sessions, split='-')
sessions_ymd
```

    ## [[1]]
    ## [1] "2020" "09"   "30"  
    ## 
    ## [[2]]
    ## [1] "2020" "10"   "23"  
    ## 
    ## [[3]]
    ## [1] "2020" "10"   "28"  
    ## 
    ## [[4]]
    ## [1] "2020" "11"   "11"  
    ## 
    ## [[5]]
    ## [1] "2020" "12"   "09"  
    ## 
    ## [[6]]
    ## [1] "2021" "01"   "27"  
    ## 
    ## [[7]]
    ## [1] "2021" "02"   "24"  
    ## 
    ## [[8]]
    ## [1] "2021" "03"   "10"

`strsplit` returns a list of character vectors.

String concatenation (`paste`)
------------------------------

Strings can be combined together using paste.

``` r
paste('This', 'is', 'a', 'sentence.')
```

    ## [1] "This is a sentence."

By default the combined strings will be separated by a space but this
can be changed with the `sep` argument.

``` r
paste('2020', '09', '30', sep='-')
```

    ## [1] "2020-09-30"

The arguments can also be vectors to produce multiple output strings

``` r
paste(c('2020', '2021'), c('09', '02'), c('30', '24'), sep='-')
```

    ## [1] "2020-09-30" "2021-02-24"

Note how the first elements of each input get combined together, then
the second element of each input. If the inputs are of different
lengths, the shorter ones will be recycled. This is useful for example
when you need to add a prefix to a vector of strings:

``` r
paste('chr', 1:22, sep='')
```

    ##  [1] "chr1"  "chr2"  "chr3"  "chr4"  "chr5"  "chr6"  "chr7"  "chr8"  "chr9" 
    ## [10] "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18"
    ## [19] "chr19" "chr20" "chr21" "chr22"

The vector of strings output by `paste` can themselves be concatenated
together using the `collapse` argument

``` r
paste(c('2020', '2021'), c('09', '02'), c('30', '24'), sep='-', collapse=', ')
```

    ## [1] "2020-09-30, 2021-02-24"

A useful shortcut for `paste(..., sep='')` in the common instance where
you don’t want the elements to be separated by a character is
`paste0(...)`

``` r
paste0('chr', 1:22)
```

    ##  [1] "chr1"  "chr2"  "chr3"  "chr4"  "chr5"  "chr6"  "chr7"  "chr8"  "chr9" 
    ## [10] "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18"
    ## [19] "chr19" "chr20" "chr21" "chr22"

Tidyverse: `stringr` and `tidyr`
================================

The built-in string manipulation functions can be a bit clunky to work
with because they don’t all follow the same argument ordering
conventions. Some functions are of the form `f(string, pattern)` while
others are of the form `f(pattern, string)`. The
[`stringr`](https://stringr.tidyverse.org) package is a great
alternative because all the functions follow the format
`f(string, pattern)`

``` r
library(stringr)
```

| Built-in                            | `stringr`                                   |
|-------------------------------------|---------------------------------------------|
| `substr(string, start, stop)`       | `str_sub(string, start, stop)`              |
| `trimws(string, which='both')`      | `str_trim(string)`                          |
| `grep(pattern, string)`             | `str_which(string, pattern)`                |
| `grepl(pattern, string)`            | `str_detect(string, pattern)`               |
| `grep(pattern, string, value=TRUE)` | `str_subset(string, pattern)`               |
| `sub(pattern, replacement, string)` | `str_replace(string, pattern, replacement)` |
| `toupper(string)`                   | `str_to_upper(string)`                      |
| `tolower(string)`                   | `str_to_lower(string)`                      |
| `strsplit(string, split)`           | `str_split(string, pattern)`                |
| `paste(string, sep, collapse)`      | `str_c(string, sep, collapse)`              |

**Exercise**: revise these built-in commands with their `stringr`
equivalents

``` r
substr("hello", start=3, stop=5)
trimws(icd10_with_ws) 
grep("F", icd10, value=TRUE)
sub(pattern="Head", replacement="Heid", x=classic_pub)
strsplit("The quick brown fox jumps over the lazy dog", split=" ")
paste('2020', '09', '30', sep='-')
```

String interpolation: `str_glue`
--------------------------------

Another feature that comes with the `stringr` package is interpolation,
where part of a string is substituted with the value from a variable.
The variable is specified by surrounding in curly braces `{varname}`:

``` r
session_name = 'Strings and Dates'
str_glue("This coding club is the {session_name} session.")
```

    ## This coding club is the Strings and Dates session.

`str_glue_data` can be used to create interpolated strings where the
variable values are pipped from a `data.frame` or `tibble`

``` r
mtcars_tb <- tibble::as_tibble(mtcars, rownames='car')
mtcars_tb %>% str_glue_data("The {car} gets {mpg} miles per gallon.")
```

    ## The Mazda RX4 gets 21 miles per gallon.
    ## The Mazda RX4 Wag gets 21 miles per gallon.
    ## The Datsun 710 gets 22.8 miles per gallon.
    ## The Hornet 4 Drive gets 21.4 miles per gallon.
    ## The Hornet Sportabout gets 18.7 miles per gallon.
    ## The Valiant gets 18.1 miles per gallon.
    ## The Duster 360 gets 14.3 miles per gallon.
    ## The Merc 240D gets 24.4 miles per gallon.
    ## The Merc 230 gets 22.8 miles per gallon.
    ## The Merc 280 gets 19.2 miles per gallon.
    ## The Merc 280C gets 17.8 miles per gallon.
    ## The Merc 450SE gets 16.4 miles per gallon.
    ## The Merc 450SL gets 17.3 miles per gallon.
    ## The Merc 450SLC gets 15.2 miles per gallon.
    ## The Cadillac Fleetwood gets 10.4 miles per gallon.
    ## The Lincoln Continental gets 10.4 miles per gallon.
    ## The Chrysler Imperial gets 14.7 miles per gallon.
    ## The Fiat 128 gets 32.4 miles per gallon.
    ## The Honda Civic gets 30.4 miles per gallon.
    ## The Toyota Corolla gets 33.9 miles per gallon.
    ## The Toyota Corona gets 21.5 miles per gallon.
    ## The Dodge Challenger gets 15.5 miles per gallon.
    ## The AMC Javelin gets 15.2 miles per gallon.
    ## The Camaro Z28 gets 13.3 miles per gallon.
    ## The Pontiac Firebird gets 19.2 miles per gallon.
    ## The Fiat X1-9 gets 27.3 miles per gallon.
    ## The Porsche 914-2 gets 26 miles per gallon.
    ## The Lotus Europa gets 30.4 miles per gallon.
    ## The Ford Pantera L gets 15.8 miles per gallon.
    ## The Ferrari Dino gets 19.7 miles per gallon.
    ## The Maserati Bora gets 15 miles per gallon.
    ## The Volvo 142E gets 21.4 miles per gallon.

Working with dates (`lubridate`)
================================

One of the most common types of string data to encounter in research are
dates. When dates are formatted in a uniform way, some information can
be extracted using the string tools we’ve alredy seen:

``` r
session_years <- as.numeric(sapply(str_split(sessions, pattern='-'), dplyr::first))
session_years
```

    ## [1] 2020 2020 2020 2020 2020 2021 2021 2021

Dates are also important as the basis of calculations. For example, we
might be interested in knowing how much time has passed between a
baseline and repeat assessment, or we might want to group dates together
to define hospitalisation or prescribing episodes. Date information in R
can be stored in `Date` objects. The `lubridate` package adds additional
functionality for parsing character data into `Date`s and doing
calculations that properly handle parculiarities like leap years and
time zones.

Creating date objects and parsing dates
---------------------------------------

Under the the hood, dates are stored as number of days since January
1st, 1970 (the “\[Unix
epoch\]”(<https://en.wikipedia.org/wiki/Unix_time>)). An object holding
date/time information can be created with \`ISOdate()\`\`

``` r
ISOdate(year=2021, month=3, day=10)
```

    ## [1] "2021-03-10 12:00:00 GMT"

A basic date object can also be automatically parsed from a string that
is formatted as `YYYY/MM/DD` or `YYYY-MM-DD`

``` r
as.Date("2021/03/10")
```

    ## [1] "2021-03-10"

``` r
as.Date("2021-03-10")
```

    ## [1] "2021-03-10"

Lubridate has a similar function `ymd()` that is less picky about
punctuation separating the different parts of the date string, as long
as they appear in the order year–month–day.

``` r
library(lubridate)
ymd("2021/03/10")
```

    ## [1] "2021-03-10"

``` r
ymd("2021-03-10")
```

    ## [1] "2021-03-10"

``` r
ymd("2021 03 10")
```

    ## [1] "2021-03-10"

``` r
ymd("20210310")
```

    ## [1] "2021-03-10"

Lubridate has other convenience functions if the date information is in
a different order

``` r
dmy("10/03/2021")
```

    ## [1] "2021-03-10"

``` r
mdy("03/10/2021")
```

    ## [1] "2021-03-10"

If the date information is not as nicely structured, it can be extracted
using `parse_date_time()`. This function’s second argument is an
`orders` vector of string encoding the different ordering and formatting
of date information to look for. The orders string uses single or dual
characters to encode the formatting of the date information:

-   `a` Abbreviated weekday name in the current locale. (Also matches
    full name)
-   `A` Full weekday name in the current locale. (Also matches
    abbreviated name).
-   `b` Abbreviated or full month name in the current locale.
-   `d` Day of the month as decimal number (01-31 or 0-31)
-   `m` Month as decimal number (01-12 or 1-12).
-   `w` Weekday as decimal number (0-6, Sunday is 0).
-   `y` Year without century (00-99 or 0-99).
-   `Y` Year with century.
-   `Om` Matches numeric month and English alphabetic months (Both, long
    and abbreviated forms).

``` r
parse_date_time("2021-03-10", orders="Ymd")
```

    ## [1] "2021-03-10 UTC"

``` r
parse_date_time("Mar 10th 2021", orders="bdY")
```

    ## [1] "2021-03-10 UTC"

``` r
parse_date_time("10 March 21", orders="dby")
```

    ## [1] "2021-03-10 UTC"

``` r
parse_date_time("2021-03", orders="Ym")
```

    ## [1] "2021-03-01 UTC"

If a vector of parsing orders are passed, the function will try each of
the options

``` r
parse_date_time(c("2021-03-10","Mar 10th 2021", "10 March 21", "Jan 1st 1970"), orders=c("bmY", "dby", "Ymd"))
```

    ## [1] "2021-03-10 UTC" "2021-10-01 UTC" "2021-03-10 UTC" "1970-01-01 UTC"

Calculations with dates
-----------------------

Once you have two dates, you can use subtraction to get the difference
between them.

``` r
unix_epoch = ymd("1970-01-01")
string_session = ymd("2021-03-10")
string_session - unix_epoch
```

    ## Time difference of 18696 days

Two dates can also define an **interval**

``` r
epoch_session <- interval(unix_epoch, string_session)
epoch_session
```

    ## [1] 1970-01-01 UTC--2021-03-10 UTC

An interval can be divided by a duration to convert them to a different
unit. How many minutes between today and the Unix epoch?

``` r
epoch_session / dminutes(1)
```

    ## [1] 26922240

Or years?

``` r
epoch_session / dyears(1)
```

    ## [1] 51.18686

**NB**: Lubridate has two ways of interpreting the length of an
`interval()`: a *duration* repesents absolute differences in time (a day
is always 24 hours, a year is always 365 days) while a *period*
represents time in a way that respects how calendars account for them
(some years are 366 days, etc). For *period* the functions are plural
time units while the equivalent *duration* functions are prefixed with
`d`

``` r
string_session + months(1)
```

    ## [1] "2021-04-10"

``` r
string_session + dmonths(1)
```

    ## [1] "2021-04-09 10:30:00 UTC"
