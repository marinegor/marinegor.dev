#import "@preview/basic-resume:0.2.8": *

// Put your personal information here, replacing mine
#let name = "Egor Marin"
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

== Cover paragraph

Scientist with strong computational and biophysical background and tendency towards writing reusable code. I have eight years of experience as a structural biology/bioinformatics scientist,
with h-index of 13 and experience ranging from data processing in serial crystallography and cryoEM to wet-lab sample preparation and virtual ligand screening.

As a structural biologist, have 400+ hours of crystallography beamtime, 20+ Tb of processed crystallography data and #text(weight: "bold")[80 processed projects in CryoSPARC] instance
that I also set up and managed for 15 users on multiple workstations and a SLURM cluster. As of January 2026, have #text(weight: "bold")[38 deposited PDB structures] across 16 different publications.
Notably, for faster processing of the projects wrote a #link("https://github.com/marinegor/ntfy_cryosparc/")[web-server] for personalised CryoSPARC notifications.

I also have good knowledge of Linux systems, supported by 4 years of management of various workstations and servers for more than 30 users.
I regularly contribute to structural biology and data science open-source (projects such as polars, MDAnalysis, reciprocalspaceship).

Now employed as Machine Learning Scientist, working on full-cycle predictive and generative model development for an antibody drug-discovery platform startup.

// Technology-wise, love (typed) python and recently Rust, jax data model, and toml over yaml for configs.


== Selected Projects

#project(
  dates: dates-helper(start-date: "Sep 2017", end-date: "Sep 2020"),
  name: "Structure-function relationship of cysteinyl leukotriene receptors",
  role: "Scientist",
)
- did last-mile crystallography service from membrane protein crystals to refined PDB structures and wrote manuscripts collaborating with multiple research groups
- publications in Nature Communications, Science Advances and Biomolecules

#project(
  dates: dates-helper(start-date: "Sep 2020", end-date: "Sep 2023"),
  name: "Structural characterisation of microbal rhodopsins",
  role: "Structural biologist",
)
- reconstituted membrane proteins in nanodiscs and processed cryoEM data subsequently
- publications in Nature Communications and Science Advances

#project(
  dates: dates-helper(start-date: "May 2023", end-date: "Sep 2023"),
  name: "Implementation of parallel analysis in MDAnalysis",
  role: "Software developer",
)
- implemented backward-compatible parallelization for the most popular molecular dynamics analysis package; continue contributing as a core developer


== Work Experience

#work(
  title: "Machine Learning Scientist",
  location: "Den Bosch, Netherlands",
  company: "ENPICOM B.V.",
  dates: dates-helper(start-date: "May 2024", end-date: "Present"),
)
- full-cycle ML model development: from literature survey and data collection and cleaning to reproducible training and deployment
- working with both generative and predictive models for various tasks in the antibody development field

#work(
  title: "Open-source software engineer",
  location: "Remote",
  company: "MDAnalysis via Google Summer of Code",
  dates: dates-helper(start-date: "May 2023", end-date: "September 2023"),
)
- designed and wrote backward-compatible parallelization (dask / multiprocessing) for molecular dynamics trajectory analysis

#work(
  title: "PhD Researcher",
  location: "Groningen, Netherlands",
  company: "University of Groningen",
  dates: dates-helper(start-date: "June 2021", end-date: "Dec 2023"),
)
- full-cycle membrane protein biochemistry: protein expression, purification, nanodisc reconstitution or crystallization
- processed cryoEM data (~80 CryoSPARC projects), set up cryoEM data processing & management infrastructure
- supervised a project as a corresponding author: #link("https://pubs.acs.org/doi/10.1021/acs.jcim.3c01661")["Regression-Based Active Learning for Accessible Acceleration of Ultra-Large Library Docking"]

#work(
  title: "Junior Research Associate",
  location: "Moscow, Russia",
  company: "Moscow Institute of Physics and Technology",
  dates: dates-helper(start-date: "March 2017", end-date: "September 2021"),
)
- last-mile protein crystallography service: crystal harvesting, data management, synchrotron and XFEL data collection
- refined, analysed and deposited protein structures to PDB (38 structures as of September 2025)
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
- *Programming Languages*: Python, bash, Rust, C++, Typescript
- *Python*: uv/ruff/ty, pytest, hypothesis, pydantic, dask
- *Data Science*: polars, huggingface, pandas/numpy/sklearn/skrub
- *Visualization*: altair, marimo, matplotlib/seaborn/jupyter
- *Deep Learning*: pytorch, lightning, jax, mlflow
- *ML in biology*: protein language models, diffusion/discrete diffusion/flow matching, continuous diffusion models (Alphafold/Openfold/Boltz)
- *Structural biology*: cryoEM data processing and structure refinement, X-ray crystallography data collection, processing and refinement
- *Cheminformatics*: RDKit, polaris, molecular docking, structural bioinformatics (MDAnalysis/mdtraj/biotite)
- *Technologies*: AWS, Docker, k8s/SLURM, Modal, Airflow, Github actions

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
  dates: dates-helper(start-date: "2017", end-date: "2019"),
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

== Extracurricular Activities

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
- self-hosting multiple applications (vikunja, llama.cpp wrappers, openwebui) for family use under a Tailscale VPN

#extracurriculars(
  activity: "Data Science Competitions",
  dates: dates-helper(start-date: "2018", end-date: "Present"),
)
- top-10% in Kaggle "Predict Molecular Properties" (public notebooks + gradient boosting on self-written rotationally invariant features)
- top-1 in first round of "Learning How To Smell" at AIcrowd
- top-10% in Takeda competition at Signate
- 5th place in Tochka Bank graph ML competition
