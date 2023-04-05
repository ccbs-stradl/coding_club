# Function to run regression analysis
# -----------------------------------------------------------
# Problem:
# I want to run linear regression on several different inflammatory
# blood markers against several different polygenic risk scores.
# I also want to save the QQ plots from each model and
# save the final results of all models in a .csv file. 
# Where the cols contain: PRS score, blood marker, beta, SE, P-value, corrected p-value etc
# and each row is a different model.

# "family" is the family function in the glm function (see ?glm)
# "bloods" is a vector of blood markers that match a col name of "data"
# "scores" is a vector of PRS scores that match a col name of "data"
# "covars" is a vector of covariates I want to include in the model
# "data" is my dataframe containing bloods, scores and covars as cols.
# "output" is the path to where I want the csv file and QQ plots to be saved.


lm_func <- function(family, bloods, scores, covars, data, output, ...){
  results <- lapply(bloods, function(marker){
    # Loop over different PRS thresholds
    prs_results <- lapply(scores, function(pred){
      form <- paste0(marker, " ~ ", pred," + ", paste(covars, collapse = " + "))
      fit <- glm(formula = form, family = family, data = data, ...)
      
      # Get estimate, std.error, t value and p value
      coef <- summary(fit)$coefficients[2,]
      results <- as.data.frame(coef)
      # Save PRS threshold and blood marker to "results"
      results["Score",] <- pred
      results["Marker",] <- marker
      # Transform the dataframe so rows are now cols and cols are now rows
      results <- t(results)
      rownames(results) <- ""
      results <- results[,c(5,6,1:4)] # reorder
      
      #QQ plot
      png(paste0("results/QQ/",output,"_", marker,"~", pred, "_", as.character(family)[1], "_link_", as.character(family)[2], ".png"), width=600,height=600,)
      par(oma=c(3,3,3,3))
      par(mar=c(2,2,10,2))
      plot(fit, which = 2,
           main = str_wrap(
             paste0(form, " (", as.character(family)[1], "(link = '", as.character(family)[2] ,"'))"), width = 35)
      )
      dev.off()
      
      return(results)
    })
    results <- as.data.frame(do.call("rbind", prs_results))
    results$marker <- marker
    results <- results[,c(7,1:6)]
    return(results)
  })
  
  # Save summary from models in one dataframe for all blood markers
  end_results <- as.data.frame(do.call("rbind", results))
  end_results$P.corr <- p.adjust(as.numeric(as.character(end_results$`Pr(>|t|)`)), method = "fdr")
  # Add a TRUE column if FDR corrected p values < 0.05
  end_results$Sig <- as.numeric(as.character((end_results[,"P.corr"]))) < 0.05
  
  # Save this with family and link names as .csv files
  write.csv(end_results, file = paste0("results/", output, as.character(family)[1], "_link_", as.character(family)[2],".csv"),
            row.names = F)
}

# -----------------------------------------------------------
# Dummy data:
UKB_data <- data.frame("f.eid" = 1:100,
           "CRP" = runif(100, min = 0, max = 5),
           "lymphocyte_count" = runif(100, min = 0, max = 5),
           "SCZ_PRS" = runif(100, min = -4, max = 4),
           "BD_PRS" = runif(100, min = -4, max = 4),
           "age" = runif(100, min = 40, max = 65),
           "sex" = sample(c("M", "F"), 100, replace = T) )

# For my real data blood markers were log transformed and all continuous variables were Z-score scaled.
# -----------------------------------------------------------
# Using function:

# First set your working directory:
setwd("/Users/aes/coding_club") 
# This folder needs to contain a directory called "results" and a subdirectory in "results" called "QQ"
system("ls")
system("ls results")

# Load required libraries:
library(stringr)

# Try running the function on only a few variables to check it works:
lm_func(family = gaussian(link = "identity"),
        bloods = c("CRP", "lymphocyte_count"),
        scores = c("SCZ_PRS", "BD_PRS"),
        covars = c("age", "sex"),
        data = UKB_data,
        output = "main_analysis")

# example of using a different family function in lm
# because the raw inflammatory blood markers were not normally distributed
# I tried using a gamma distribution with a log link function.
lm_func(family = gamma(link = "log"),
        bloods = c("CRP", "lymphocyte_count"),
        scores = c("SCZ_PRS", "BD_PRS"),
        covars = c("age", "sex"),
        data = UKB_data,
        output = "main_analysis")



