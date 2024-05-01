---
title: "Regression-based Accelerated Virtual Screening"
description: "A lesser formal version of this JCIM paper"
date: "2023-12-29"
author: "Egor Marin"
tags:
    - science
    - paper
    - machine learning
    - virtual screening
---

[Article link](https://doi.org/10.1021/acs.jcim.3c01661)

When doing large-scale virtual screening, you have a slow *oracle* that tells you the true value of each molecule (in our case, it's small molecule docking). Point is, the oracle is slow -- in our case, around 1 CPU-sec per molecule (depends heavily on pocket size and ligand sampling depth), which is a lot if you have $10^9$ molecules.

Main idea here, described also before us, is to do an active learning, using the docking algorithm as oracle. Then we can dock a small batch, then train a model to predict the docking scores, and then dock only those that have good scores. Potentially, we can also do that many times. It's quite intriguing though that, despite the whole "accelerated virtual screening" started back in 2020, all the papers that I've seen use some heavy-weight model as a *base* one, i.e. the model that determines which molecules go to the next docking step.

Here we showed that you can actually use a linear regression (literally, `sklearn.linear_model.LinearRegression`) model, trained on Morgan fingerprints, instead, and also few slightly more clever tricks to make your retrieval rate better. Namely:

 - use smaller batch size -- around 10_000 is perfect
 - re-use models -- aggregate few (we did 20) last batches via `MeanRank`, i.e. take the mean across last 20 models predicted rank of each molecule. You can also do some exponential decay of that, if you want.
 - use relatively big fingerprints -- [this](https://doi.org/10.26434/chemrxiv.14348117.v1) preprint by Martin et al benchmarks it much better
 - models like `sklearn.svm.SVR` could also be surprisingly good, though less stable across datasets


Our final active learinng model was following:

 - Morgan fingerprints with 1024 bits, radius 2, as features
 - `sklearn.linear_model.LinearRegression` as base learner
 - batch size 10_000
 - aggregation of last 20 models via mean ranking

With that, we could retrieve 70% of the top-0.05% of famous AmpC dataset from [Lyu et al](https://doi.org/10.1038/s41586-019-0917-9) after screening only 2% of the library, whereas the message-passing neural networks approach retrieves around 80%. Kinda cool, given that we used a CPU-only workstation with only a modest SSD for our work.

Also, cool thing is that our approach allows us to pre-compute the fingerprints and store them somewhere, whereas MPNN-based one needs to be trained again and again for each new dataset, which is also kinda a disadvantage.