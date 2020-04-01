#################################################################################
#                                                                               #
#                Getting Cytochrome P450 annotation targets                     #
#                                                                               #
#################################################################################

#################################################################################
#                                                                               #
#                               Get the scaffolds                               #
#                                                                               #
#################################################################################

scaffoldsDir=scaffolds

$(scaffoldsDir):
	if [ ! -d $(scaffoldsDir) ]; then mkdir $(scaffoldsDir); fi

scaffoldsURL=http://i5k.nal.usda.gov/sites/default/files/GCA_003013835.2_Dvir_v2.0_genomic_consortiumIDs.fna.gz

scaffoldsGz=$(addsuffix  /$(notdir $(scaffoldsURL)), $(scaffoldsDir))

$(scaffoldsGz): | $(scaffoldsDir)
	wget -P $(scaffoldsDir) $(scaffoldsURL)

# when decompressing, rename to something less cumbersome
scaffoldsFasta=$(addsuffix /WCRScaffolds.fasta, $(scaffoldsDir))

$(scaffoldsFasta): $(scaffoldsGz)
	zcat $(scaffoldsGz) > $(scaffoldsFasta)

.PHONY: getScaffolds

getScaffolds: $(scaffoldsFasta)

#################################################################################
#                                                                               #
#                       Get the GFF of trancsript models                        #
#                                                                               #
#################################################################################

gffDir=gff

$(gffDir):
	if [ ! -d $(gffDir) ]; then mkdir $(gffDir); fi

gffURL=http://i5k.nal.usda.gov/sites/default/files/GCF_003013835.1_Dvir_v2.0_genomic_updated.gff.gz

gffGz=$(addsuffix  /$(notdir $(gffURL)), $(gffDir))

$(gffGz): | $(gffDir)
	wget -P $(gffDir) $(gffURL)

# when decompressing, rename to something less cumbersome
gff=$(addsuffix /WCR.gff, $(gffDir))

$(gff): $(gffGz)
	zcat $(gffGz) > $(gff)

.PHONY: getGFF

getGFF: $(gff)

#################################################################################
#                                                                               #
#                     Make blast database of the scaffolds                      #
#                                                                               #
#################################################################################

blastDbDir=blastdb

$(blastDbDir):
	if [ ! -d $(blastDbDir) ]; then mkdir $(blastDbDir); fi

blastDbBaseName=WCRScaffolds

 blastDbName=$(addprefix $(blastDbDir)/, $(blastDbBaseName))

blastDbFiles=$(addprefix $(blastDbName), .nin .nhr .nsq)

$(blastDbFiles): $(scaffoldsFasta) | $(blastDbDir)
	conda run --name p450_blast \
	makeblastdb \
	-in $(scaffoldsFasta) \
	-dbtype nucl \
	-out $(blastDbName)

.PHONY: blastdatabase

blastdatabase: $(blastDbFiles)

#################################################################################
#                                                                               #
#                   Run blast searches with query proteins                      #
#                                                                               #
#################################################################################


queryDir=queries

#reduced file sets for testing

# Completed by Dariane
#queryFileNames=CPB_CYP4_complete.fasta 
# Completed by Dakota
#queryFileNames=ALB_Family_4.fasta
# Completed by Dimpal
#queryFileNames=Tribolium_castaneum_CYP_12.fasta

queryFileNames=CPB_CYP4_complete.fasta ALB_Family_4.fasta Tribolium_castaneum_CYP_12.fasta

# Remove .fasta suffix to make things clearer later on
queryNames=$(basename $(queryFileNames))

queryFiles=$(addprefix $(queryDir)/, $(queryFileNames))

blastOutDir=blastresults

$(blastOutDir):
	if [ ! -d $(blastOutDir) ]; then mkdir $(blastOutDir); fi


blastOutFiles=$(addprefix $(blastOutDir)/, $(addsuffix .out, $(queryNames)))

# Easiest to parse output with biopython if in XML format (format option 5)
# blastOpts=-evalue 0.1 -outfmt 5

# The parsed XML is a pain in the arse
blastOpts=-evalue 0.1 -outfmt 6

# This doesn't work exactly as I would like because make considers every
# query file to be a dependency for each ouput file. Consequently, if one
# input file is newer than any output file, all the searches get run again.
# On the plus side, doing things this way lets us rune the searches in parallel
# with make -j

$(blastOutFiles): $(queryFiles) $(blastDbFiles) | $(blastOutDir)
	conda run --name p450_blast \
	tblastn \
	-db $(blastDbName) \
	-query $(subst $(blastOutDir), $(queryDir), $(subst .out,.fasta, $@)) \
	$(blastOpts) \
	> $@

.PHONY: runblast

runblast: $(blastOutFiles)

#################################################################################
#                                                                               #
#                          Convert blast output to GFF3                         #
#                                                                               #
#################################################################################

scriptsDir = scripts
conversionScript = $(addprefix $(scriptsDir)/, blast2gff.py)

blastGffFiles=$(addprefix $(gffDir)/, $(addsuffix .gff, $(queryNames)))

$(blastGffFiles): $(blastOutFiles) | $(gffDir)
	python \
	$(conversionScript) \
	$(subst $(gffDir), $(blastOutDir), $(subst .gff,.out, $@)) \
	> $@

.PHONY: blast2gff

blast2gff: $(blastGffFiles)

#################################################################################
#                                                                               #
#                 Find transcript models containing blast hits                  #
#                                                                               #
#################################################################################

overlapGffFiles=$(subst .gff,.transcript.overlaps.gff, $(blastGffFiles))

bedtoolsOpts=-wa #output original features from file a

# Note: piping to grep filters transcript features only
$(overlapGffFiles): $(blastGffFiles)
	conda run --name p450_bedtools \
	bedtools intersect \
	$(bedtoolsOpts) \
	-a $(gff) \
	-b $(subst .transcript.overlaps.gff,.gff, $@) \
	| grep ID=rna \
	> $@

.PHONY: transcriptswithhits

transcriptswithhits: $(overlapGffFiles)
