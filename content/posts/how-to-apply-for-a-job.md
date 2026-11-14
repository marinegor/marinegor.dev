---
title: "Searching for a job: opinionated approach to an exhausting task"
date: 2026-11-14
description: "Here I'm telling how my job application process has been for the last three years -- CV, recommendation letters, and how to make it more fun for you and for the HR."
tags:
  - hiring
  - resume
---

Job search is exhausting -- you are not getting paid for that, you have to submit hundreds of applications with little to no feedback, and you have to pretend you're very interested in anything but money while your unemployment leave is running thin. This is, however, my personal view on the whole process -- if you have it differently, you're probably luckier than I am.

I've switched two of them in the last three years, and happy to be employed right now. But throughout multiple attempts to find one (I've been searching for a job two times during last three years), I've developed an approach that I quite enjoy, and recommend to my friends and random people on the internet often enough to document it here. If you have something you'd like to discuss about it, please open an issue at this repo's github, or simply write me an email!

While all of that is only my personal recommendation, I will still phrases like "you should", simply because it's easier to write in this way. Or because I enjoy being bossy🤷‍♂️

# Target audience

My experience is only my experience, and you can decide if it's relevant to you by comparing our career paths. You can find about me more on my [CV](/cv), but in short: I'm an immigrant in tech, with a PhD from University of Groningen, working in biology-related tech startup as a machine learning engineer.

# Resume aka CV

I know there's difference between resume and CV, but I'll use those interchangeably since I don't understand what's the difference anyway, and your HR probably also doesn't. 

First, you should see your CV a little bit like your wardrobe: it should have all sorts of different things, but you pick only a subset of those for every particular look. For instance, my [CV](/cv) has a full version of it, with all sorts of possible projects, skills, jobs etc, but for every particular application I choose only some of those to include in the actual document. For instance, if I'm applying for a outside-facing position, I will probably include my journalist job, while for more technical positions I'll include more of my education sections (e.g. extracurricular courses on programming and ML).

Second, modern typesetting systems can help you tremendously with this modularity. For instance, I use `typst` for that: it's like Latex that you've likely heard about, but ~~in Rust~~ much friendlier to the user. At some point I sat down and wrote a big-ass template for my resume, including all jobs, courses, publications with experience, skills etc, and for every particular application I just comment out entries that are not needed for a particular application, and quickly re-compile the PDF to fit into a single- or two-page format.

Third, the format. I quite enjoy the one I use ([PDF](/cv.pdf)), with three major sections:

 - the "Summary" section: free-style paragraph describing who you are. Not too long, not too short, human-written, showing that you are an actual person who can write texts and present yourself in a certain way
 - the "Experience" section: your career path, including position and main **outcomes** of your particular work period. In my field, those can fit into multiple bins -- could be organizational ("organized a conference for your scientists"), could be scientific ("has shown that protein X does function Y, some results published in A and B"), or engineering ("established internal pipeline for processing of M and N, used for publication C")
 - the "Education" section -- at least for the entry-level jobs, it's important where you got your degree / Masters / MBO / ..., so that HR could put you on their internal scale. It's not fair, I know, but it's still an important section
 - feel free to remix other sections as you see fit for a particular position. I have "Skills", "Education" and "Open-source contributions", but you can add whatever you like

 Freedom in writing first paragraph and remixing the optional ones should give you flexibility in creating a decent-looking single- or double-page PDF without much of empty space. Ironically enough, my PDF version at the time of writing has one line on the third page, but I promise I haven't sent it anywhere😔

# Recommending letter aka Motivation letter

I also don't know the difference between these two -- perhaps there is, but I have never really understood a consistent enough explanation that wouldn't contradict another explanation.

Here's the trick I found useful: you don't actually have to follow a tedious wall-of-text-like template that you can find on the internet. It's rather boring and repetitive to write and, more importantly, read, and you can make a mistake of starting like "ever since I was a kid, I always dreamt of ...". The way I write them for a job is unconventional yet quite efficient if an actual person is reading it.

Imagine the job description -- it usually has particular requirements for the candidates, and perhaps some nice-to-haves. For example:

```
Requirements:
 - don't be an asshole
 - be able to write code in python
 - know how to do linear algebra by hand

Nice-to-haves:
 - have nice hair
 - enjoy being yelled at
 - know how to write code in Rust
```

Then my motivational letter would be structured in following way, each number represents a single paragraph:

0. Dear <company-name> hiring team, I'm writing this letter to support my application for <position-name> at your company.
1. Paragraph with "Summary" section from my CV. Either identical copy-paste of the text, or slightly longer version of it.
2. Please find below my point-by-point response to your job posting requirements:
  - > don't be an asshole
    - I have interacted with many different people throughout my career, participating in numerous collaborations and joint projects. I believe that the sheer number of interactions, as seen in my CV and particularly publications list, can give you an impression that I can maintain valuable and productive relationship with different people, which of course does not guarantee I am not an asshole, but severely lowers the chances of that
  - > be able to write code in python
    - I have contributed to various projects (polars/MDAnalysis/reciprocalspaceship) in open-source settings, and have also been using python for scripting and more production-like code since 2018.
  - > know how to do linear algebra by hand
    - I have graduated from a technical university, completing multiple mathematics courses, which also included Linear Algebra I and II, with grade A. This also included doing linear algebra by hand, which I haven't exercised long enough, but hopefully can still do.
  - > have nice hair
    - Unfortunately, I don't, unless you mean my beard. But I'm happy to wear a wig if that's an absolutely strict requirement for the job.
  - > Enjoy being yelled at
    - This is not something I enjoy, and prefer more productive form of communication between colleagues. I'm happy to discuss these forms though.
  - > Know how to write code in Rust
    - I have in fact written some code in Rust, and while nowadays write most of that in English with subsequent LLM translation, can write things like helloworld, or try to optimize things like python bindings for a python module.
3. Please don't hesitate to contact me if you have any questions. Best wishes, Egor Marin, PhD.

And basically, this is what gets sent. I use either same `typst` style, or just drop it into markdown and render to pdf with something like Obsidian, or paste directly into application form.

# Finishing thoughts

Honestly, I don't think it should be all polished and crispy -- you can be slightly raw, as long as information you're trying to convey. While it might somewhat lower your chances, it significantly lowers resource requirements for applying for endless stream of positions, and at the end of the day this is what matters a bit more, at least to me.

Good luck applying!
