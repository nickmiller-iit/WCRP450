#################################################################################
#                                                                               #
#                Getting Cytochrome P450 annotation targets                     #
#                                                                               #
#################################################################################


# Get the scaffolds

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

# Get the GFF of trancsript models

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
