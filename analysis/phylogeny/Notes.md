# Constructing a phylogeny of P450s

For simplicity, we will follow the same methodoloty Brad already used for the ABC transporters. Use MEGA to first determine the best substitution model, then use that model to produce a maximum likelihood tree.

One question - do we include non-WCR CYPs as reference points? May not be necessary, given we have already assigned the CYPs to families. If we do add in external references, we will need to re-align. After some conversation with Brad, decided to add some reference points. Selected the UniProt blast hits used to assign full-length genes to CYP families (see `../clustering`).

## Aligning P450s

Made an input fasta file (`PralineIn.fasta`) by combining the 85 full-length WCR P450s (`WCRFullLength.fasta`) plus the 20 UniProt blast hits (`UniProtFamilyReps.fasta`). 
