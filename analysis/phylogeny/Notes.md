# Constructing a phylogeny of P450s

For simplicity, we will follow the same methodoloty Brad already used for the ABC transporters. Use MEGA to first determine the best substitution model, then use that model to produce a maximum likelihood tree.

One question - do we include non-WCR CYPs as reference points? May not be necessary, given we have already assigned the CYPs to families. If we do add in external references, we will need to re-align. After some conversation with Brad, decided to add some reference points. Selected the UniProt blast hits used to assign full-length genes to CYP families (see `../clustering`).

## Aligning P450s

Made an input fasta file (`PralineIn.fasta`) by combining the 85 full-length WCR P450s (`WCRFullLength.fasta`) plus the 20 UniProt blast hits (`UniProtFamilyReps.fasta`).

Ran PRALINE via the web interface at https://www.ibi.vu.nl/programs/#msa. Took a screen shot to record the parameters

![Praline settings](PralineSettings20201221.png)

PRALINE alignment was stored in `PralineResults20201221/alignment.fasta_ali`. Because PRALINE likes to change various chracters to underscores, made a copy of the alignment, with original names restored as `PralineOut.fasta`

## Model selection for ML Tree

MEGA has a tool to select the best amino acid substitution model for maximum likelihood trees. Rand this tool and save the output to `MEGAModelSelection.txt`

## ML Tree

Lowest BIC was for model "LG+G+I+F" (LG with freqs, gammma distributed rates with invariant sites). Used this model to make the ML tree. Ran MEGA to buit the ML tree with 500 bootstrap replicates.

Because MEGA is GUI based, took a screenshot to capture paramter settings (did this after analysis was done, but I'm confident params were the same).

![MEGA settings](MEGASettings20201229.png)

NEWICK formatted tree saved to `MEGAMLTree20201229.nwk`

# Producing a figure.

Made use of the "Interactive tree of life" (https://itol.embl.de/).

## Changing labels

The labels for the UniProt CYP representatives are rather clunky and iTOL seems to choke on them. Changed them to just the UniProt accessions. Set up a file of sed commands in `iTOL/transformTree.sed` and ran `sed -f transformTree.sed ../MEGAMLTree20201229.nwk > WCRP450.nwk` from th `iTOL` dir.

Uploaded `iTOL/WCRP450.nwk` to work with.

## Colour coding

Set up file `iTOL/treeColours.txt` to colour the tree by CYP family. Colour coding uses different shades of the same colour for different familes in the same clan.

## Other tweaks

Under the iTOL "advanced" tab:

 * Set internal tree scal with label font size 29px
 * Set to display botstraps
   * Display range 0.8 - 1 (ie show for bootstrap values > 80%) 
   * Display symbol (circle)
   * Min and max sizes 10 px

Downloaded as SVG. Used Illustrator to reposition legend and indicate CYP clans, deleted scale bar since the internal scale does the job. Saved as `iTOL/WCRP450s.svg`
