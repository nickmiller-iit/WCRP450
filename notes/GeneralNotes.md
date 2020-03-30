---
title: General Notes
author: Nick Miller
---

Our goal is to identify the set of transcript models that are putative *CYP* genes for further manual annotation. The basic steps are:

 1. Get the WCR scaffolds from i5k
 2. Use a set of full-length beetle CYP protein sequences as tblastn queries to identify genome locations containing potential *CYP* genes
 3. Get the GFF of transcript models from i5k
 4. Get the intersection of blast hits and transcript models. This should give us the transcript models that contain at least one tblastn hit.

The whole process is run by GNU make, the Makefile both cotrols the process and documents it.

Lately, I have found the most pain-free way to install needed software is to give each tool its own dedicated conda environment (specified in the ../envs/*.yaml files) using the conda run command.
