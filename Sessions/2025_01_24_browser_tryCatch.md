# Coding Club - Show and Tell
## 24th Jan 2025 - Amelia


### Demonstrate the browser() function

browser() is a function that allows you to pause the execution of a function and inspect the environment at that point in time.

https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/browser
https://adv-r.hadley.nz/debugging.html#browser


```{r}
simple_function <- function() {
  x <- 1
  browser()
  x <- x + 1
  x
}

simple_function()

# At the browser prompt the user can enter commands or R expressions, 
# followed by a newline. The commands are: 
# n: go to the next statement in the function
# c: continue evaluation of the function
# Q: abort the function
# f: finish the function

# what if n is assigned instead of x
simple_function <- function() {
  n <- 1
  browser()
  n <- n + 1
  n
}

simple_function()
# n is a reserved word in R, so it is not a good idea to use it as a variable name

```

### Demonstrate the tryCatch() function

tryCatch() is a function that allows you to catch and handle errors in R code.

https://www.rdocumentation.org/packages/R.oo/versions/1.2.7/topics/trycatch
https://cran.r-project.org/web/packages/tryCatchLog/vignettes/tryCatchLog-intro.html 


```{r}
# Example function demonstrating tryCatch
example_tryCatch <- function(x) {
  tryCatch(
    {
      result <- log(x)  # Attempt to compute the logarithm
      message("Computation successful! Result is: ", result) 
      return(result)
    },
    error = function(e) {
      # Code to handle errors
      message("An error occurred: ", e$message) 
      return(NA)  # Return a default value
    },
    warning = function(w) {
      # Code to handle warnings
      message("A warning occurred: ", w$message)
      return(NULL)  # Return another default value
    },
    finally = {
      # Code that will always run, regardless of success or error
      message("Execution completed.")
    }
  )
}

# Test the function
example_tryCatch(10)  # Valid input, no warning
example_tryCatch(-1)  # Generates a warning: Logarithm of negative number
example_tryCatch("a")  # Generates an error: Logarithm of non-numeric value
```

