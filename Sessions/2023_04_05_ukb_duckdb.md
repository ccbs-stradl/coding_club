# UKB DuckDB Tables
Mark Adams

## UK Biobank Releases

- Phenotypes downloaded as a single compressed file

- Amount of data has grown considerably

  | Year | Download | Fields | Columns |
  |------|----------|--------|---------|
  | 2014 | 493 MB   | 519    | 4428    |
  | 2016 | 684 MB   | 1574   | 7096    |
  | 2018 | 1301 MB  | 2282   | 8904    |
  | 2022 | 6144 MB  | 7698   | 26522   |

## Data Extracts

By 2017, the data extracts were approaching 1GB in size.

Loading all the data into R required \> 20GB of RAM.

## Organising the Data

To make the data easier to work with, we split the data into separate
files for each category.

``` sh
AlgorithmicallyDefinedOutcomes.rds 
BaselineCharacteristics.rds
CognitiveFunctionOnline.rds
...
```

Obstacles remain:

- takes ≈10s to load a file
- still requires lots of RAM to merge fields across multiple files

## DuckDB

***“DuckDB is an in-process SQL OLAP database management system”***

- “in process”: runs on your **local** machine/node, rather than
  connecting to a separate server.
- “SQL”: data can be analysed using **Structured Query Language** and
  plugged into interfaces that speak SQL, like dbplyr.
- “OLAP”: **Online analytical processing**, where operations (filter,
  aggregate, mutate) happen over the entire dataset.

## What is DuckDB

- table-oriented, relational database
- performance optimised for reads
- assumes writes are infrequent
- run queries without importing/copying data

## Structured Query Language

- “S-Q-L” or “sequel”
- declarative programming language
- declarative = “tell the computer what you want, not step-by-step
  instructions to follow”
- relational model for storing and handling structured data.

## SQL ↔︎ dplyr

| SQL         | dplyr                                 |
|-------------|---------------------------------------|
| `SELECT`    | `select()`, `mutate()`, `transmute()` |
| `FROM`      | `tibble()`, `read_*()`                |
| `_ JOIN ON` | `_join(…, by=…)`                      |
| `WHERE`     | `filter()`                            |
| `GROUP BY`  | `group_by() |> summarize()`           |
| `ORDER BY`  | `arrange()`                           |

## SQL query

- Count of each level of variable `f.4598.0.0` (“ever depressed”) from
  table `Touchscreen`.

``` sql
SELECT "f.4598.0.0" AS ever_depressed, COUNT(*) AS n
FROM Touchscreen
GROUP BY "f.4598.0.0";
┌──────────────────────┬────────┐
│    ever_depressed    │   n    │
│     "f.4598.0.0"     │ int64  │
├──────────────────────┼────────┤
│                      │ 329735 │
│ No                   │  78777 │
│ Yes                  │  89351 │
│ Do not know          │   3876 │
│ Prefer not to answer │    650 │
└──────────────────────┴────────┘
```

## R Installation

``` r
install.packages('duckdb')
```

Or install a specific version

``` r
remotes::install_version('duckdb', '0.7.1-1')
```

Command line version on Eddie at:

``` sh
/exports/igmm/eddie/GenScotDepression/local/bin/duckdb
```

## UKB Database location

Latest phenotype release (670429):

`GenScotDepression/data/ukb/phenotypes/fields/2022-11-phenotypes-ukb670429-v0.7.1/ukb670429.duckdb`

NB: The DuckDB database format is still in development, so data extracts
are marked with which version was used to create them.

## Connecting to the database

Lauch R from an interactive node

``` sh
qlogin -l h_vmem=8G
module load igmm/apps/R/4.1.0
```

Use dbplyr

``` r
library(dplyr)

con <- DBI::dbConnect(duckdb::duckdb(),
  dbdir="ukb670429.duckdb",
  read_only=TRUE)
```

- connecting to the the database takes 2s
- tip: symlink the database into your project directory

## Listing available tables

``` r
DBI::dbListTables(con)
```

     [1] "AlgorithmicallyDefinedOutcomes" "BaselineCharacteristics"
     [3] "BiologicalSampling"             "BloodAssays"
     [5] "CancerRegister"                 "CognitiveFunction"
     [7] "CognitiveFunctionOnline"        "DeathRegister"
     [9] "Dictionary"                     "DietByHourRecall"
    [11] "DigestiveHealth"                "ExperienceOfPain"
    [13] "EyeMeasures"                    "FirstOccurrences"
    [15] "Genotypes"                      "HospitalInpatient"
    [17] "Imaging"                        "LocalEnvironment"
    [19] "MentalHealth"                   "OngoingCharacteristics"
    [21] "PhysicalActivityMeasurement"    "PhysicalMeasures"
    [23] "PrimaryCare"                    "ProceduralMetrics"
    [25] "Recruitment"                    "SampleInventory"
    [27] "Touchscreen"                    "UrineAssays"
    [29] "VerbalInterview"                "WorkEnvironment"

## Opening a table

“Opening” a table takes \< 1s:

``` r
Touchscreen <- tbl(con, 'Touchscreen')
Imaging <- tbl(con, 'Imaging')
```

## Like a tibble

Printing the table to the screen only queries the first few rows

``` r
Touchscreen
```

    # Source:   lazy query [?? x 2,077]
    # Database: DuckDB 0.7.1 [madams23@Linux 3.10.0-1160.80.1.el7.x86_64:R
    #   4.1.0/ukb670429.duckdb]
       f.eid f.670…¹ f.670…² f.670…³ f.670…⁴ f.680…⁵ f.680…⁶ f.680…⁷ f.680…⁸
       <int> <fct>   <fct>   <fct>   <fct>   <fct>   <fct>   <fct>   <fct>  
     1 0000… A hous… NA      NA      NA      Own ou… NA      NA      NA     
     2 0000… A hous… NA      NA      NA      Own ou… NA      NA      NA     
     3 0000… A hous… NA      NA      NA      Own wi… NA      NA      NA     
     4 0000… A hous… NA      A hous… NA      Own wi… NA      Own wi… NA     
     5 0000… A hous… NA      A hous… NA      Own ou… NA      Own ou… NA     
     6 0000… A hous… A hous… NA      NA      Own wi… Own wi… NA      NA     
     7 0000… A hous… NA      A hous… NA      Own ou… NA      Own ou… NA     
     8 0000… A hous… NA      NA      NA      Own ou… NA      NA      NA     
     9 0000… A hous… NA      NA      NA      Own ou… NA      NA      NA     
    10 0000… A hous… NA      NA      NA      Own ou… NA      NA      NA     
    # … with more rows, 2,067 more variables: f.699.1.0 <int>, …

## Use `dplyr` verbs

``` r
Touchscreen |> count(f.4598.0.0)
```

      f.4598.0.0                n
      <fct>                 <dbl>
    1 NA                   329735
    2 No                    78777
    3 Yes                   89351
    4 Do not know            3876
    5 Prefer not to answer    650

*Query time: 0.038s*

## Joining tables

E.g., gray matter volume of right caudate and low mood item.

``` r
caudate_dep_qf <-
left_join(Imaging, Touchscreen, by='f.eid') |>
select(f.eid,
       caudate_volume_right=f.25881.2.0,
       ever_dep_week=f.4598.0.0)
```

*Query time: 0.750s*

## Importing result into R workspace with `collect()`

- dbplyr is “lazy”
- only does as much work as necessary to construct or print the results
- does not pull data into R workspace until told

``` r
caudate_dep_df <- caudate_dep_qf |> collect()
```

*Query time: 4.171s*

## Data Dictionary table

``` r
Dictionary <- tbl(con, 'Dictionary')
colnames(Dictionary)
```

     [1] "Table"        "FieldID"      "Field"        "Category"     "Participants"
     [6] "Items"        "Stability"    "ValueType"    "Units"        "ItemType"
    [11] "Strata"       "Sexed"        "Instances"    "Array"        "Coding"
    [16] "Notes"        "Link"

## Finding MHQ depression items

From [Category
138](https://biobank.ndph.ox.ac.uk/showcase/label.cgi?id=138)

``` r
Dictionary |> filter(Category == 138) |> select(Table, FieldID, Field)
```

          Table        FieldID Field
       <chr>          <dbl> <chr>
     1 MentalHealth   20433 Age at first episode of depression
     2 MentalHealth   20434 Age at last episode of depression
     3 MentalHealth   20435 Difficulty concentrating during worst depression
     4 MentalHealth   20436 Fraction of day affected during worst episode of depres…
     5 MentalHealth   20437 Thoughts of death during worst depression
     6 MentalHealth   20438 Duration of worst depression
     7 MentalHealth   20439 Frequency of depressed days during worst episode of dep…
     8 MentalHealth   20440 Impact on normal roles during worst period of depression
     9 MentalHealth   20441 Ever had prolonged loss of interest in normal activities
    10 MentalHealth   20442 Lifetime number of depressed periods

## Finding MHQ depression items

Field column names are formatted as `f.FIELD.INSTANCE.ARRAY` so select
for `"f.FIELD."` to find all instances and arrays.

``` r
MentalHealth <- tbl(con, 'MentalHealth')

mhq_dep_field_ids <- Dictionary |> filter(Category == 138) |> pull(FieldID)
mhq_dep_fields <- paste0('f.', mhq_dep_field_ids, '.')

mhq_dep_qf <- MentalHealth |> select(f.eid, starts_with(mhq_dep_fields))
```

## Detailed info about a particular field

``` r
Dictionary |> filter(FieldID == 20433) |> pull(Notes) |> cat('\n')
```

    Question asked: ""About how old were you the FIRST time you had a period of two weeks like this? (Whether or not you received any help for it.)""  Question was asked when Field 20446 was Yes or Field 20441 was Yes.

``` r
Dictionary |> filter(FieldID == 20433) |> pull(Link) |> cat('\n')
```

    http://biobank.ndph.ox.ac.uk/ukb/field.cgi?id=20433

## My dbplyr programming style

- Tables are capitalised

  ``` r
  Touchscreen <- tbl(con, 'Touchscreen')
  ```

- Variables for queries end in `_qf`

  ``` r
  prob_mdd_qf <- Touchscreen |> 
    select(f.eid, ever_dep_week=f.4598.0.0, ever_anh_week=f.4631.0.0) |>
    mutate(ever_md_week=if_else(ever_dep_week == 'Yes' | ever_anh_week == 'Yes',
           true=TRUE, false=FALSE))
  ```

- Variables for collected tibbles end in `_df`

  ``` r
  prob_mdd_df <- prob_mdd_qf |> collect()
  ```

- Copy/mutate queries with reckless abandon (only adds a few MB to
  workspace)

## Look under the hood

`show_query()` prints the SQL translation

``` r
prob_mdd_qf |> show_query()
```

``` sql
SELECT "f.eid", ever_dep_week, ever_anh_week,
CASE WHEN (ever_dep_week = 'Yes' OR ever_anh_week = 'Yes')
  THEN (TRUE)
WHEN NOT(ever_dep_week = 'Yes' OR ever_anh_week = 'Yes')
  THEN (FALSE)
END AS ever_md_week
FROM (SELECT "f.eid",
             "f.4598.0.0" AS ever_dep_week,
             "f.4631.0.0" AS ever_anh_week
      FROM Touchscreen) q01
```

## Data extraction workflow

- implemented in Nextflow
- Github repo: [ukb-release-nf](https://github.com/mja/ukb-release-nf/)

``` sh
module load uge
module load igmm/apps/nextflow/20.04.1

nextflow run duckdb.nf \
-c eddie.config \
-work-dir /exports/eddie/scratch/$USER/ukb-release \
-resume \
--enc ukb670429.enc \
--key k4844r670429.key
```

## Data extraction workflow

``` mermaid
flowchart LR
    enc[(ukb670429.enc)]
    key&gt;k4844r670429.key]
    duckdb[(ukb670429.duckdb)]
    dat{{encoding.dat}}
    unpack([unpack])
    conv_docs([ukb_conv docs])
    conv_r1([ukb_conv r])
    conv_r2([ukb_conv r])
    ukb_enc[(ukb670429.ukb_enc)]
    docs{{ukb670429.html}}
    fields{{ukb670429.fields}}
    showcase{{showcase.csv}}
    TouchscreenF(Touchscreen.fields)
    ImagingF(Imaging.fields)
    TouchscreenT(Touchscreen.tsv)
    ImagingT(Imaging.tsv)
    TouchscreenR(Touchscreen.R)
    ImagingR(Imaging.R)
    TouchscreenRds(Touchscreen.Rds)
    ImagingRds(Imaging.Rds)
    Rscript1([Rscript])
    Rscript2([Rscript])
    enc &amp; key --&gt; unpack --&gt; ukb_enc
    ukb_enc --&gt; conv_docs --&gt; docs &amp; fields
    fields &amp; showcase --&gt; TouchscreenF &amp; ImagingF
    ukb_enc &amp; TouchscreenF &amp; dat--&gt; conv_r1
    ukb_enc &amp; ImagingF &amp; dat --&gt; conv_r2
    conv_r1 --&gt; TouchscreenT &amp; TouchscreenR --&gt; Rscript1 --&gt; TouchscreenRds
    conv_r2 --&gt; ImagingT &amp; ImagingR --&gt; Rscript2 --&gt; ImagingRds
    TouchscreenRds &amp; ImagingRds &amp; showcase --&gt; duckdb
```

## Worked example: MHQ depression phenotypes

List of MHQ fields

``` r
mhq_field_ids <- c(31, 53, 189, 680, 709, 738, 884, 1031, 1239, 1249, 1647, 2020, 2050, 2110, 2188, 2443, 2453, 2664, 6138, 6141, 6150, 6152, 6160, 20002, 20003, 20116, 20122, 20123, 20124, 20125, 20126, 20127, 20400, 20401, 20403, 20404, 20405, 20406, 20407, 20408, 20409, 20410, 20411, 20412, 20413, 20414, 20415, 20416, 20417, 20418, 20419, 20420, 20421, 20422, 20423, 20425, 20426, 20427, 20428, 20429, 20431, 20432, 20433, 20434, 20435, 20436, 20437, 20438, 20439, 20440, 20441, 20442, 20445, 20446, 20447, 20448, 20449, 20450, 20453, 20454, 20455, 20456, 20457, 20458, 20459, 20460, 20461, 20462, 20463, 20465, 20466, 20467, 20468, 20470, 20471, 20473, 20474, 20476, 20477, 20479, 20480, 20481, 20482, 20483, 20484, 20485, 20486, 20487, 20488, 20489, 20490, 20491, 20492, 20493, 20494, 20495, 20496, 20497, 20498, 20499, 20500, 20501, 20502, 20503, 20504, 20505, 20506, 20507, 20508, 20509, 20510, 20511, 20512, 20513, 20514, 20515, 20516, 20517, 20518, 20519, 20520, 20521, 20522, 20523, 20524, 20525, 20526, 20527, 20528, 20529, 20530, 20531, 20532, 20533, 20534, 20535, 20536, 20537, 20538, 20539, 20540, 20541, 20542, 20543, 20544, 20546, 20547, 20548, 20549, 20550, 20551, 20552, 20553, 20554, 21000, 21003, 41202, 41204)
```

Dictionary search

``` r
Dictionary |>
  filter(FieldID %in% mhq_field_ids) |>
  distinct(Table)
```

      Table
      <chr>
    1 BaselineCharacteristics
    2 Recruitment
    3 VerbalInterview
    4 Touchscreen
    5 MentalHealth
    6 HospitalInpatient

## MHQ query

``` r
mhq_fields <- paste0('f.', mhq_field_ids, '.')

mhq_qf <- 
tbl(con, 'BaselineCharacteristics') |>
full_join(tbl(con, 'Recruitment'), by='f.eid') |>
full_join(tbl(con, 'VerbalInterview'), by='f.eid') |>
full_join(tbl(con, 'Touchscreen'), by='f.eid') |>
full_join(tbl(con, 'MentalHealth'), by='f.eid') |>
full_join(tbl(con, 'HospitalInpatient'), by='f.eid') |>
select(f.eid, starts_with(mhq_fields))
```

## Self-declared depression

*field 20499*: “Ever sought or received professional help for mental
distress”; *field 20544:* “Mental health problems ever diagnosed by a
professional”

``` r
mhq_sr_depression_qf <- mhq_qf |>
transmute(f.eid,
SRDepression=case_when(if_any(starts_with("f.20544."),
                              ~ . == "Depression") ~ 1,
                       !is.na(f.20499.0.0) ~ 0,
                       TRUE  ~ NA_integer_))
```

Count cases

``` r
mhq_sr_depression_qf |> count(SRDepression)
```

      SRDepression      n
             <dbl>  <dbl>
    1           NA 345084
    2            0 123905
    3            1  33400

## CIDI-depression

Symptom fields

``` r
cidi_field_ids <- c(20435, 20437, 20441, 20446, 20449, 20450, 20532, 20536)
```

Response codings

``` f
fields <- read_tsv("https://biobank.ndph.ox.ac.uk/ukb/scdown.cgi?fmt=txt&id=1")
fields |>
  filter(field_id %in% cidi_field_ids) |>
  select(field_id, title, encoding_id)
```

      field_id title                                            encodin…¹
         <dbl> <chr>                                                <dbl>
    1    20435 Difficulty concentrating during worst depression       502
    2    20437 Thoughts of death during worst depression              502
    3    20441 Ever had prolonged loss of interest in normal ac       503
    4    20446 Ever had prolonged feelings of sadness or depres       503
    5    20449 Feelings of tiredness during worst episode of de       502
    6    20450 Feelings of worthlessness during worst period of       502
    7    20532 Did your sleep change?                                 502
    8    20536 Weight change during worst episode of depression       507

## CIDI administration and screening

Non-missing responses

``` r
cidi_admin_qf <- mhq_qf |>
  select(f.eid, all_of(cidi_fields)) |>
  mutate(cidi_administered=if_any(cidi_fields, ~!is.na(.)))
```

Low mood and anhedonia symptoms

``` r
cidi_screen_qf <- cidi_admin_qf |>
  mutate(cidi_cardinal=case_when(f.20446.0.0 == 'Yes' ~ TRUE,
                                 f.20441.0.0 == 'Yes' ~ TRUE,
                                 cidi_administered ~ FALSE,
                                 TRUE ~ NA))

cidi_screen_qf |> count(cidi_administered, cidi_cardinal)
```

      cidi_administered cidi_cardinal      n
      <lgl>             <lgl>          <dbl>
    1 FALSE             NA            345084
    2 TRUE              TRUE           89003
    3 TRUE              FALSE          68302

## CIDI diagnosis

``` r
cidi_dep_qf <-
cidi_screen_qf |>
  mutate(across(c(f.20446.0.0, f.20441.0.0),
                ~case_when(. == 'Yes' ~ 1,
                           . == 'No' ~ 0,
                           TRUE ~ NA_integer_)),
         across(c(f.20449.0.0, f.20532.0.0, f.20435.0.0, f.20450.0.0, f.20437.0.0),
                ~case_when(. == 'Yes' ~ 1,
                           cidi_administered ~ 0,
                           TRUE ~ NA_integer_)),
        across(c(f.20536.0.0), ~case_when(. == 'Gained weight' ~ 1,
                                          . == 'Lost weight' ~ 1,
                                          . == 'Both gained and lost some weight during the episode' ~ 1,
                                          cidi_administered ~ 0,
                                          TRUE ~ NA_integer_))) |>
  mutate(cidi_symptom_count=f.20446.0.0 + f.20441.0.0 + f.20449.0.0 + f.20532.0.0 + f.20435.0.0 + f.20450.0.0 + f.20437.0.0 + f.20536.0.0) |>
  mutate(CIDI_Depression=case_when(cidi_cardinal & cidi_symptom_count > 4 ~ 1,
                                   cidi_administered ~ 0,
                                   TRUE ~ NA)) |>
  select(f.eid, CIDI_Depression)
```

## Save data and close the database

``` r
dep_df <- mhq_sr_depression_qf |>
  full_join(cidi_dep_qf, by='f.eid') |>
  collect()

write_tsv(dep_df, 'mhq_dep.tsv')

dbDisconnect(con, shutdown=TRUE)
```

## Runtime comparison

Full MHQ analysis uses 178 fields from 6 categories.

| Dataset        | Input size | Time   | Memory  |
|----------------|------------|--------|---------|
| 178 fields RDS | 50MB       | 14.19s | 3.070G  |
| 6 Category RDS | 205MB      | 52.42s | 16.885G |
| DuckDB         | 16GB       | 25.07s | 2.377G  |
