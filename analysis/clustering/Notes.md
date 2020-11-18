---
title: "Clustering CYPs into families"
author: "Nick Miller"
---

# Overview

Cytochrome P450s are assigned to families and subfamilies on the basis of amino acid identity. A CYP is a member of family X if it shares 40% amino acid identity with another member of family X. See *Feyereisen, René. “8 - Insect CYP Genes and P450 Enzymes.” In Insect Molecular Biology and Biochemistry, edited by Lawrence I. Gilbert, 236–316. San Diego: Academic Press* for details.

To assign our CYPs to families, we need to group them into clusters of >= 40% identity. To make life easier, we can also include CYPS from another species, with known family memberships. This should tell us right away which CYP family each cluster corresponds to.

Much of this analysis will make use of tools that cannot be easily run from the command line, so my preferred method of documenting analysis (run everything from a Makefile) breaks down. Instead, I will keep notes here, and track key files with git.

# Alignment

In some initial playing around, normal aligners (clustal, muscle, etc.) did not do a great job aligning the full-length CYPs we annotated. This is because CYPs are a highly divergent protein family. Fortunately, we can use praline, an aligner that takes into account regoins of high homology and structural similarity. In initial tests, pralinen did a much better job, in particular, the conserved cysteine heme-iron ligand signature motif `[FW]-[SGNH]-x-[GD]-{F}-[RKHPT]-{P}-C-[LIVMFAP]-[GAD]` aligned perfectly (except 2 sequences that turned out to be truncated) near the C-terminus and the transmembrane regions at the N-terminus mostly aligned.

Praline is not straightforward to install locally, but happily, it is available via a web interface: https://www.ibi.vu.nl/programs/pralinewww/

## Input sequences

### WCR

We have a total of 85 full-length manually curated sequences. To facilitate collaboration, the sequences were stored as fasta format in a Google Doc. They were downloaded, cleaned up (sequences unwrapped, DOS line breaks removed) and stored in `WCRFullLength.fasta`
