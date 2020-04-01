# A simple script to convert blast XML to GFF3 format.
# See notes in notes dir for explanations of fields

import sys
import csv

inFileName = sys.argv[1]

inFile = open(inFileName)
c = csv.reader(inFile, delimiter = '\t')

for row in c:
    if row: # True if row is not empty
        out = ["" for x in range(9)] # empty GFF3 output line
        if int(row[8]) < int(row[9]):
            plusStrand = True
        else:
            plusStrand = False
        out[0] = row[1]
        out[1] = "blast2gff.py"
        out[2] = "."
        if plusStrand:
            out[3] = row[8]
            out[4] = row[9]
        else:
            out[3] = row[9]
            out[4] = row[8]
        out[5] = row[2]
        if plusStrand:
            out[6] = '+'
        else:
            out[6] = '-'
        out[7] = '.'
        attr = []
        attr.append("Eval=" + row[10])
        attr.append("Query=" + row[0])
        out[8] = ';'.join(attr)
        print('\t'.join(out))
inFile.close()
