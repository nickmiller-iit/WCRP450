# Add some extra columns to GFF to help with annotation in Apollo
library(stringr)

inFile <- commandArgs(trailingOnly = T)[1]

gff.cols <- c("gff_seqid",
              "gff_source",
              "gff_type",
              "gff_start",
              "gff_end",
              "gff_score",
              "gff_strand",
              "gff_phase",
              "gff_attributes")

gff.in <- read.table(inFile,
                     header = F,
                     sep = '\t',
                     col.names = gff.cols,
                     stringsAsFactors = F,
		     quote = "",
		     fill = F)
# Should always be 9 columns, but let's make sure

tab.out <- gff.in[,1:9]

tab.out$locus <- str_remove(str_split(tab.out$gff_attributes, 
                                      ';', 
                                      simplify = T)[,2], 
                            "Parent=gene-")

# Format to paste into Apollo's location bar
tab.out$location <- paste(tab.out$gff_seqid, 
                          paste(tab.out$gff_start, 
                                tab.out$gff_end, 
                                sep = ".."), 
                          sep = ":")

# Some blank (for now columns we will want)
tab.out$link <- character(length = length(tab.out$location))
tab.out$annotator <- character(length = length(tab.out$location))
tab.out$status <- character(length = length(tab.out$location))
tab.out$comments <- character(length = length(tab.out$location))

# Rearrange columns

tab.out <- tab.out[,c(10:15, 1:9)]

write.table(tab.out, 
            quote = F, 
            row.names = F, 
            col.names = T, 
            sep = '\t')

