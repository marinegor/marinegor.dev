---
title: "Job search simulation"
date: 2026-09-28
description: "An interactive notebook showing how difficult (or not) it is to search for a job under certain conditions, and easy way to estimate which parameters influence that"
tags:
  - python
  - marimo
  - hiring
---

Many of my friends (and myself) have at some point been in a following position: you want to find a job. It's usually quite tedious, and requires a lot of dedication, a well working application pipeline, good if you have some networking, and a good resume. However, despite all of that, you might still have a lot of frustration in the process -- you keep applying, and keep getting rejection after rejection.

To slightly help people navigate through that, I decided to build a little interactive simulation for the job search process. It's fully interactive thanks to [marimo](https://marimo.io), and runs in your browser in this page (but I limited parameters so that it wouldn't crush your laptop).

## Job application model

The model is somewhat inspired by role playing games -- for each stage, a candidate rolls a dice (or mathematically, samples from uniform distribution `[0, 1]`), and this action's threshold defines if a candidate passes or fails. There are multiple stages:

 - 📞 HR screening: your resume has to pass an initial HR screen 
 - 🧑‍💻 interviews: you have `n` technical interviews, each of them you can pass with some probability (and you have to pass all of them)
 - 🤙 team ~~vibe check~~ cultural fit: you have to talk to the team and pass their vibe check
 - 🤞 relevance: defines overall fit for the position that all stages, except for interviews, consider, and works as multiplier for all thresholds above

In this (very simple) model, all applications are considered identical between each other, i.e. thresholds for each stage are identical between candidates, and candidates are identical between each other. After all candidates pass (or not) their checks, one candidate is randomly selected among all suitable candidates.

## Simulation process

In general, I invite you to explore the notebook -- it's self-contained (and mostly hand-written, except for visualization functions), and describes the simulation in detail. In short, idea is following: each **position** is represented by a dataframe, where rows define applicants, and columns define their sampled probabilities (and subsequent computed thresholded checks). A **job search** is, in turn, a collection of **positions**, and we can condence them to get offer probability for each position by doing `1 / n_passed_candidates`, since the one who'll take the offer is chosen randomly after all checks.

Now, we can simulate multiple **job searches**, and deduce how a cumulative `p_offer` changes as you keep applying. If you have positions `1..k` with offer probabilities `p1..pk` respectively, your cumulative offer probability for position up to `k` is given by:

```bash
p_offer = 1 - (1-p1)*(1-p2)...*(1-pk)
```

what we use to simulate probability of getting a job by application `n`. And finally, we can rescale that to your timelines, if we know how many applications a week you're doing.

## Notebook

{{< marimo "jobsearch-1" >}}

The notebook lives in this site's `/content` as a plain `.py` file, and is also served as-is. The `marimo` shortcode reads it at build time and passes its code to [marimo.app](https://marimo.app) in the iframe URL. To play with it locally:

```bash
uvx marimo edit --sandbox https://marinegor.dev/notebooks/jobsearch-1.py
```

## Discussion

I find it fun to play around with different scenarios -- e.g. "mass-applying to multiple positions with many candidates" vs "targeted applications to companies with high relevance". Interestingly enough, since candidates are all equal, you often can see that e.g. low probability to pass HR check (or team vibe or interview) might actually lead to faster hire specifically for you. I guess it's because, if our model, probability of getting an offer is inversely proportional to the number of candidates at the end of the hiring funnel, so if you manage to pass it once (e.g. if companies massively false-reject good candidates), you'll get hired faster.

Another interesting thing is how much fluctiation in probabilities we get if we have low number of applications (or at least, for early applications). Depending on number of candidates, this uncertainty period might actually last for weeks, and in narrow-scoped specializations practically diminishes your ability to predict your timelines based on how your friends / colleagues / ... are doing on the job market.

## Outro

If you have errors here, please let me know in the [repo](https://github.com/marinegor/marinegor.dev), and/or open a PR. There's no code of conduct just yet, so I'll just yolo reject PRs full of slop -- at the end of the day, it's my personal blog.
