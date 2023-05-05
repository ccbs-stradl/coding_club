# Building command line tools on Eddie from source

Eddie is running an older version of Scientific Linux and it does not always have the most up-to-date libraries, so sometimes Linux binaries will not run and need to be installed from source. 

Usually the easiest way is to install programs using Anaconda, since that will automatically pull in the correct versions of libraries. However, when you need to install directly from source, general advice and specific commands are given here.

## Specific programs

### DuckDB

[DuckDB](https://duckdb.org) is a SQL database for online analytic processing (OLAP). 

```sh
# download the source code for the latest release version listed
# https://github.com/duckdb/duckdb/releases/
wget https://github.com/duckdb/duckdb/archive/refs/tags/v0.7.1.zip
unzip v0.7.1.zip
cd duckdb-0.7.1
module load phys/compilers/gcc/9.3.0
make
```

### regenie

[regenie](https://rgcgithub.github.io/regenie/) is a program for whole genome regression modelling and GWAS.

```sh
module load phys/compilers/gcc/9.3.0
module load intel/2020u4

git clone https://github.com/rgcgithub/regenie.git
cd regenie
```

Edit `Makefile` so that the configuration lines read:
```
BGEN_PATH     = /gpfs/igmmfs01/eddie/GenScotDepression/local/bgen
HAS_BOOST_IOSTREAM := 0
MKLROOT       = /exports/applications/apps/SL7/intel/parallel_studio_xe_2020_update4_cluster_edition/compilers_and_libraries_2020.4.304/linux/mkl
OPENBLAS_ROOT =
STATIC       := 1
```

Then build the program"
```sh
make
```
