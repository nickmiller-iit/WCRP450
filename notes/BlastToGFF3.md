---
title: Converting BLAST output oft GFF3
author: Nick Miller
---

Converting BLAST output to GFF3 should be fairly straightforward. The BLAST -outfmt 6 option gives a tab-separated table, and GFF3 is a tab-separated table, so its mostly a case or reorganizing tbale columns. The columns for BLAST -outfmt 6 are


length mismatch gapopen qstart qend sstart send
   evalue bitscore'

 1. Query accesion.version
 2. Subject accession.version
 3. Percentage of identical matches
 4. Alignment length
 5. Number of mismatches
 6. Total number of gaps
 7. Start of alignment in query
 8. End of alignment in query
 9. Start of alignment in subject
 10. End of alignment in subject
 11. Expect value
 12. Raw score

Note that if the hit is to the opposite strand, col 9 > col 10

The columns for GFF3 are

 1. seqid - name of the chromosome or scaffold
 2.source - name of the program that generated this feature, or the data source (database or project name)
 3. type - type of feature. Must be a term or accession from the SOFA sequence ontology
 4. start - Start position of the feature, with sequence numbering starting at 1.
 5. end - End position of the feature, with sequence numbering starting at 1.
 6. score - A floating point value.
 7. strand - defined as + (forward) or - (reverse).
 8. phase - One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on..
 9. attributes - A semicolon-separated list of tag-value pairs, providing additional information about each feature. Some of these tags are predefined, e.g. ID, Name, Alias, Parent
 
So, the mapping from BLAST to GFF3 can be done as 

GFF3_col -> BLAST_col

1 -> 2
2 -> N/A (can give the name of the script)
3 -> N/A
4 -> 9 or 10
5 -> 10 or 9
6 -> 3
7 -> + if 9 < 10, - if 9 > 10
8 -> N/A
9 -> Query = 1; Eval = 11

The only bit of wrangling we have to do is to test if the value of col 9 < col 10.


