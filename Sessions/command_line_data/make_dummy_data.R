setwd("/Users/aes/OneDrive - University of Edinburgh/PhD/Meetings/Coding Club/Sessions/command_line_data")

library(stringi)

df <- data.frame("SNP" = paste0("rs", sample(100000:200000, 500, replace = TRUE) ),
           "CHR"= sample(1:22, 500, replace = T),
           "BP" = sample(300:38000000, 500, replace = T),
           "A1" = stri_rand_strings(500, 1, '[A T C G]'),
           "A2" = stri_rand_strings(500, 1, '[A T C G]'),
           "MAF" = sample(seq(from=0, to=0.4, by=.01), 500, replace = T ),
           "INFO" = sample(seq(from=0.6, to=1, by=.001), 500, replace = T ),
           "OR" = sample(seq(from=0, to=1, by=.001), 500, replace = T ),
           "P" = sample(seq(from=0, to=0.5, by=.0000001), 500, replace = T )) 
head(df)
sum(df$MAF < 0.01)
sum(df$INFO > 0.9)

write.table(df,"dummy_GWAS_sumstats", quote = F, row.names = F)
