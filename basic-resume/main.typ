#import "@preview/basic-resume:0.2.8": *

// Put your personal information here, replacing mine
#let name = "Egor Marin, ML Engineer/Scientist"
// Applied ML Engineer/Scientist
#let location = "Groningen, Netherlands"
#let email = "me@marinegor.dev"
#let github = "github.com/marinegor"
#let linkedin = "linkedin.com/in/marinegor"
// #let phone = "+1 (xxx) xxx-xxxx"
#let personal-site = "marinegor.dev"

#show: resume.with(
  author: name,
  // All the lines below are optional.
  // For example, if you want to to hide your phone number:
  // feel free to comment those lines out and they will not show.
  location: location,
  email: email,
  github: github,
  linkedin: linkedin,
  // phone: phone,
  personal-site: personal-site,
  accent-color: "#e9602a",
  font: "New Computer Modern",
  paper: "us-letter",
  author-position: left,
  personal-info-position: left,
)

/*
 * Lines that start with == are formatted into section headings
 * You can use the specific formatting functions if needed
 * The following formatting functions are listed below
 * #edu(dates: "", degree: "", gpa: "", institution: "", location: "", consistent: false)
 * #work(company: "", dates: "", location: "", title: "")
 * #project(dates: "", name: "", role: "", url: "")
 * certificates(name: "", issuer: "", url: "", date: "")
 * #extracurriculars(activity: "", dates: "")
 * There are also the following generic functions that don't apply any formatting
 * #generic-two-by-two(top-left: "", top-right: "", bottom-left: "", bottom-right: "")
 * #generic-one-by-two(left: "", right: "")
 */

== Summary

- ML Scientist with a PhD in Structural Biology and 8+ years of research experience
- built and managed ML/DL codebase with data and model registry in a team of scientists and engineers
- specialized in building generative and predictive models for antibody drug discovery and structural biology
- managed complete research data lifecycles, from cryo-EM/crystallography data processing (20TB+) to deploying ML-driven analysis tools
- Core Developer for MDAnalysis, contributing major features like a parallel processing backend (dask/multiprocessing)

// == Selected Projects
//
// #project(
// dates: dates-helper(start-date: "Sep 2017", end-date: "Sep 2020"),
// name: "Structure-function relationship of cysteinyl leukotriene receptors",
// role: "Scientist",
// )
// - did last-mile crystallography service from membrane protein crystals to refined PDB structures and wrote manuscripts collaborating with multiple research groups
// - publications in Nature Communications, Science Advances and Biomolecules
//
// #project(
// dates: dates-helper(start-date: "Sep 2020", end-date: "Sep 2023"),
// name: "Structural characterisation of microbal rhodopsins",
// role: "Structural biologist",
// )
// - reconstituted membrane proteins in nanodiscs and processed cryoEM data subsequently
// - publications in Nature Communications and Science Advances
//
// #project(
// dates: dates-helper(start-date: "May 2023", end-date: "Sep 2023"),
// name: "Implementation of parallel analysis in MDAnalysis",
// role: "Software developer",
// )
// - implemented backward-compatible parallelization for the most popular molecular dynamics analysis package; continue contributing as a core developer


== Experience

#work(
  title: "Machine Learning Scientist",
  location: "Den Bosch, Netherlands",
  company: "ENPICOM B.V.",
  dates: dates-helper(start-date: "May 2024", end-date: "Present"),
)
- develop and deploy generative and predictive models for antibody drug discovery using pytorch/lightning and custom discrete diffusion pipelines
- own the end-to-end ML lifecycle, from sourcing and cleaning biochemical data to building reproducible training pipelines with MLflow for experiment tracking
- manage codebase with data and training pipelines, ensuring regular code reviews and code reusability while maintaining modularity and compatibility of the models

#work(
  title: "Open-source software engineer",
  location: "Remote",
  company: "MDAnalysis via Google Summer of Code",
  dates: dates-helper(start-date: "May 2023", end-date: "September 2023"),
)
- designed and wrote backward-compatible parallelization with dask or multiprocessing for the core analysis library

#work(
  title: "PhD Researcher",
  location: "Groningen, Netherlands",
  company: "University of Groningen",
  dates: dates-helper(start-date: "June 2021", end-date: "Dec 2023"),
)
- led a research project as a corresponding author, applying regression-based active learning to accelerate ultra-large library docking, resulting in a publication in J. Chem. Inf. Model
- designed, deployed, and managed a high-throughput data processing infrastructure (CryoSPARC) for 15+ users, processing over 80 cryo-EM projects and 20TB of data
- developed a custom web server (ntfy-cryosparc) to provide personalized notifications, improving workflow efficiency for the research group
- solved 38+ protein structures using cryo-EM and X-ray crystallography, leading to publications in journals including Nature Communications and Science Advances

#work(
  title: "Junior Research Associate",
  location: "Moscow, Russia",
  company: "Moscow Institute of Physics and Technology",
  dates: dates-helper(start-date: "March 2017", end-date: "September 2021"),
)
- managed the end-to-end protein crystallography pipeline for multiple research groups, from sample preparation to synchrotron and XFEL data collection
- processed, refined, and analyzed crystallographic data, successfully determining and depositing 38 protein structures to the PDB
- contributed structural data and analysis that formed the basis for 16 peer-reviewed publications

// - coordinated data analysis and manuscript preparation

// #work(
// title: "Scientific Journalist",
// location: "Moscow, Russia",
// company: "Moscow Institute of Physics and Technology",
// dates: dates-helper(start-date: "Jun 2016", end-date: "Aug 2017"),
// )
// - wrote press-releases on published papers
// - communicated with scientists & media.

== Skills

#text(weight: "bold")[Technology:]  python | rust | pytorch | jax | scipy | numpy | sklearn | polars | pydantic | mlflow | docker | AWS | k8s | SLURM

#text(weight: "bold")[Domain:] cryoEM | X-ray crystallography | biophysics | drug discovery | cheminformatics | antibodies

// - *Programming Languages*: Python, bash, Rust, C++, Typescript
// - *Python*: uv/ruff/ty, pytest, hypothesis, pydantic, dask
// - *Data Science*: polars, huggingface, pandas/numpy/sklearn/skrub
// - *Visualization*: altair, marimo, matplotlib/seaborn/jupyter
// - *Deep Learning*: pytorch, lightning, jax, mlflow
// - *ML in biology*: protein language models, diffusion/discrete diffusion/flow matching, continuous diffusion models (Alphafold/Openfold/Boltz)
// - *Structural biology*: cryoEM data processing and structure refinement, X-ray crystallography data collection, processing and refinement
// - *Cheminformatics*: RDKit, polaris, molecular docking, structural bioinformatics (MDAnalysis/mdtraj/biotite)
// - *Technologies*: AWS, Docker, k8s/SLURM, Modal, Airflow, Github actions

== Selected publications

For full list, see #link("https://scholar.google.com/citations?user=FJbv9XcAAAAJ")[google scholar].

#edu(
  degree: "CryoRhodopsins: a comprehensive characterization of a new clade of microbial rhodopsins from cold environments",
  institution: "Science Advances",
  dates: "July 2025",
  consistent: true,
)
// - #text(style: "italic")[Science Advances], July 2025
// - prepared samples for cryoEM (nanodisc reconstitution), processed cryoEM data and organized data collection

#edu(
  degree: "Structural basis for no retinal binding in flotillin-associated rhodopsins",
  institution: "Pre-print on biorxiv",
  dates: "29 April 2025",
  consistent: true,
)
// - Prepared samples for cryoEM (nanodisc reconstitution), processed cryoEM data and organized data collection.

#edu(
  degree: "A subgroup of light-driven sodium pumps with an additional Schiff base counterion",
  institution: "Nature Communications",
  dates: "4 October 2024",
  consistent: true,
)
// - Reconstituted protein into nanodiscs and processed cryo-EM data.

#edu(
  degree: "Regression-Based Active Learning for Accessible Acceleration of Ultra-Large Library Docking",
  institution: "Journal of Chemical Information and Modeling",
  dates: "December 2023",
  consistent: true,
)
// - #text(style: "italic")[Journal of Chemical Information and Modeling], December 2023
// - proposed the project, supervised the study and wrote manuscript, performed ML benchmarks

// #edu(
// institution: "Custom Design of a Humidifier Chamber for In Meso Crystallization",
// )
// - #text(style: "italic")[Crystal Growth & Design], December 2023
// - purified and crystallized protein, performed in meso crystallization, processed data, refined the structure, analyzed cryo-EM data, wrote the manuscript

#edu(
  degree: "Mirror proteorhodopsins",
  institution: "Nature Communications Chemistry",
  dates: "2 May 2023",
  consistent: true,
)
// - Collected crystallographic data and solved the structure.

// #edu(
// institution: "Structural insights into thrombolytic activity of destabilase from medicinal leech",
// )
// - #text(style: "italic")[Scientific Reports], April 2023
// - Crystallized the protein, collected data, solved the structures, performed molecular dynamics simulations and analyzed the results.

// #edu(
// institution: "Structural insights into the effects of glycerol on ligand binding to cytochrome P450",
// degree: "Acta Crystallographica Section D",
// dates: "12 August 2022"
// )
// - Collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models.

#edu(
  degree: "Structural basis for receptor selectivity and inverse agonism in S1P5 receptors",
  institution: "Nature Communications",
  dates: "August 2022",
  consistent: true,
)
// - #text(style: "italic")[Nature Communications], August 2022
// - collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models

// #edu(
// institution: "A new twist of rubredoxin function in M. tuberculosis",
// degree: "Bioorganic Chemistry",
// dates: "1 April 2021"
// )
// - Collected crystallography data, supervised model refinement, wrote manuscript

// #edu(
// institution: "Metabolic fate of human immunoactive sterols in Mycobacterium tuberculosis",
// )
// - #text(style: "italic")[Journal of Molecular Biology], February 2021
// - collected crystallography data, supervised model refinement, wrote manuscript

// #edu(
// institution: "Structural Aspects of Photopharmacology: Insight into the Binding of Photoswitchable and Photocaged Inhibitors to the Glutamate Transporter Homologue",
// )
// - #text(style: "italic")[Journal of American Chemical Society], January 2021
// - performed molecular docking of photo-switchable compounds in crystallographic structure and compared docking results with functional data

#edu(
  degree: "Structure-Based Virtual Screening of Ultra-Large Library Yields Potent Antagonists for a Lipid GPCR",
  institution: "Biomolecules",
  dates: "December 2020",
  consistent: true,
)
// - #text(style: "italic")[Biomolecules], December 2020
// - prepared small-molecule libraries for docking, did large-scale docking and analyzed the results, wrote manuscript

// #edu(
// institution: "Hydroxylation of antitubercular drug candidate, SQ109, by mycobacterial cytochrome P450",
// degree: "International Journal of Molecular Sciences",
// dates: "16 October 2020"
// )
// - Collected crystallography data, supervised model refinement, discussed draft.

// #edu(
// institution: "Small-wedge synchrotron and serial XFEL datasets for cysteinyl leukotriene GPCRs",
// )
// - #text(style: "italic")[Scientific Data], November 2020
// - organized, annotated and deposited raw data, developed robust re-processing algorithms, wrote manuscript
//
// #edu(
// institution: "Molecular mechanism of light-driven sodium pumping",
// )
// - #text(style: "italic")[Nature Communications], May 2020
// - processed serial synchrotron crystallography data using CrystFEL, deposited raw data

#edu(
  institution: "Structural basis of ligand selectivity and disease mutations in cysteinyl leukotriene receptors",
  degree: "Nature Communications",
  dates: "December 2019",
  consistent: true,
)
// - #text(style: "italic")[Nature Communications], December 2019
// - collected small-wedge serial synchrotron crystallography data, refined, deposited, and analyzed structures, wrote the manuscript

#edu(
  degree: "Structure-based mechanism of cysteinyl leukotriene receptor inhibition by antiasthmatic drugs",
  institution: "Science Advances",
  dates: "October 2019",
  consistent: true,
)
// - #text(style: "italic")[Science Advances], October 2019
// - collected synchrotron crystallography data, processed XFEL and synchrotron data, refined, deposited and analyzed structures, wrote the manuscript

// #edu(
// institution: "An outlook on using serial femtosecond crystallography in drug discovery",
// )
// - #text(style: "italic")[Expert Opinion on Drug Discovery], June 2019
// - wrote sections about SFX data processing and phasing

// #edu(
// institution: "Structural insights into ion conduction by channelrhodopsin 2",
// )
// - #text(style: "italic")[Science], November 2017
// - processed serial crystallography data for both WT and mutant proteins

// #edu(
// institution: "Element-specific density profiles in interacting biomembrane models",
// degree: "Journal of Physics D: Applied Physics",
// dates: "9 February 2017"
// )


== Education

#edu(
  institution: "University of Groningen",
  location: "Groningen, Netherlands",
  dates: dates-helper(start-date: "2019", end-date: "2023"),
  degree: "PhD",
  consistent: true,
)
- thesis 'On the methods of studying protein-ligand interaction dynamics'"
- methods: cryoEM, X-ray crystallography, molecular dynamics, protein biochemistry, protein biophysics
- publications in JACS, Crystal Growth & Design, Journal of Cheminformatics & Modelling


#edu(
  institution: "Moscow Institute of Physics and Technology",
  location: "Moscow, Russia",
  dates: dates-helper(start-date: "2017", end-date: "2019"),
  degree: "MSc in applied mathematics and physics",
  consistent: true,
)
// - managed bachelor and master students, lectured a course on modern protein crystallography
- graduated #text(style: "italic")[summa cum laude]

#edu(
  institution: "Moscow Institute of Physics and Technology",
  location: "Moscow, Russia",
  dates: dates-helper(start-date: "2013", end-date: "2017"),
  degree: "BSc in applied mathematics and physics",
  consistent: true,
)
- graduated #text(style: "italic")[magna cum laude]
- related coursework: Calculus I-IV, Linear Algebra I-II, Complex Analysis, Differential Equations I-II, Analytical Mechanics I-II, Thermodynamics.

// #edu(
// institution: "Computer Science Center",
// location: "St. Petersburg, Russia",
// dates: dates-helper(start-date: "2020", end-date: "2022"),
// degree: "Online educational program in computer science",
// consistent: true,
// )
// - relevant coursework: Python, C++, Algorithms and data structures, Data science, Intro to Linux systems, Rust

== Open Source Contributions & Projects

#extracurriculars(
  activity: "Open-source contributions",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- #link("https://github.com/pola-rs/polars/")[polars]: contributed to polars (issue #link("https://github.com/pola-rs/polars/issues/25383")[\#25383]: extending `replace_many` with `leftmost` option.
- #link("https://github.com/ion-elgreco/polars-distance/")[polars-distance]: minor contribution to polars plugin for distance calculation
- #link("https://github.com/rs-station/reciprocalspaceship")[reciprocalspaceship]: wrote parser for serial crystallography data into binary dataframe-like class
// - #link("https://github.com/marinegor/ntfy_cryosparc/")[ntfy-cryosparc]: wrote web-server to parse CryoSPARC notifications and notify appropriate users

#extracurriculars(
  activity: "MDAnalysis Core Developer",
  dates: dates-helper(start-date: "February 2025", end-date: "Present"),
)
- #link("https://www.mdanalysis.org/pages/team/")[MDAnalysis Core Developer]
  - wrote a #link("https://github.com/MDAnalysis/mdanalysis/pull/4162")[parallel backend] for all analysis classes (dask/multiprocessing)
  - added a #link("https://github.com/MDAnalysis/mdanalysis/pull/4304")[DSSP module] for native secondary structure assignment
  - currently working on fast unified #link("https://github.com/MDAnalysis/mdanalysis/pull/4712")[MMCIF parser] based on `gemmi`

#extracurriculars(
  activity: "Self-hosting",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- self-hosting multiple applications (paperless, llama.cpp, openwebui) for family use under a Tailscale VPN

#extracurriculars(
  activity: "Data Science Competitions",
  dates: dates-helper(start-date: "2018", end-date: "Present"),
)
- top-10% in Kaggle "Predict Molecular Properties" (public notebooks + gradient boosting on self-written rotationally invariant features)
// - top-1 in first round of "Learning How To Smell" at AIcrowd
- top-10% in Takeda competition at Signate
- 5th place in Tochka Bank graph ML competition
