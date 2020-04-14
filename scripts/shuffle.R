# Really simple script to shuffle lines in a gff file, doesn't support piping from stdin.
# Use this instead of `shuf` because we can set the seed and make the shuffle repeatable.
set.seed(20200408)
inFile <- commandArgs(trailingOnly = T)[1]

gff.in <- read.table(inFile, header = F, sep = '\t', quote = "", fill = F)
line.count <- length(gff.in[,1])
new.lines <- sample(1:line.count)
gff.out <- gff.in[new.lines,]
write.table(gff.out, quote = F, row.names = F, col.names = F, sep = '\t')




