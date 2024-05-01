---
title: "Structural basis for receptor selectivity and inverse agonism in S1P5 receptors"
description: "A lesser formal version of this Nature Communications paper"
date: "2022-08-12"
author: "Egor Marin"
tags:
    - science
    - paper
    - machine learning
    - virtual screening
---

[Article link](https://doi.org/10.1038/s41467-022-32447-1)

The story behind this paper is relatively simple -- there's a receptor, there's a ligand, let's make a crystal structure of their complex, and get some insights on how the receptor works. The physiological relevance (tm) please find in the paper, while here I'll go through some technical challenges that are more important to me.

## Crystallography and computer vision

A technical issue with getting the structure was *very* high upstream scattering background on the images. Namely, while a normal dataset contains has background at around 15 detector counts, and signal (=diffraction peak) roughly above 50, this dataset had  the same diffraction peak strength while background was around **2000** counts. I've tried many different things while trying to get rid of that, and also learned approaches like `NMF` for denoising. Luckily, the background was smooth enough that the sliding-window noise subtraction actually helped a lot.

## Alphafold boom

Basically, Alphafold 2.0 appeared when we were writing the paper, and all structural biologists across the world were scared they'll loose their jobs (spoiler: that kinda didn't happen). Fun thing we did was that we benchmarked our structure in a mock ligand screening study, and showed that it's actually much more useful than all Alphafold models (or, more precisely, the best of ensemble of 50 different models), and that this ensemble performs basically at a random baseline level. Structures of other receptors were more useful, i.e. had non-random ROC AUC and enrichment factor, while our structure was better by quite a bit.

## Google patents

The last fun thing was that although we had our ligand, we didn't know anything about similar ligands, even though we suspected it arose from a medicinal chemistry study. I found out that you can actually search Google Patents by SMILES string, and by entering ligand's SMILES there, found that there was a benchmark of similar ligands by ONO Pharmaceuticals! We took that published benchmark as a reference, and showed that our structure is quite good at dissecting binders from non-binders, within this particular group of ligands at least.