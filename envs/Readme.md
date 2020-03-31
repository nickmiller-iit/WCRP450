---
title: Conda environments
author: Nick Miller
---

Lately, I have found that the most painless way to install most bioinformatics tools and run them from a Makefile is to set up minimal conda environments for each tool. This avoids a lot of frustration compared to a single conda environment for an entire project, in which tool A and tool B can have conflicting dependency issues, particularly dependencies on different versions of the same library or whatever. Samtools has been especially exasperating in this regard.

Each minimal conda environment has its own .yaml file in this directory. and can be installed via

`conda env create -f foo.yaml`

The installed tool can then be run from a Makefile (or shell for that matter) with:

`conda run --name foo <command>`

