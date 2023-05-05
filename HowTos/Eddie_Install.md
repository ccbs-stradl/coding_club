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