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

== Work Experience

#work(
  title: "Machine Learning Scientist",
  location: "Den Bosch, Netherlands",
  company: "ENPICOM B.V.",
  dates: dates-helper(start-date: "May 2024", end-date: "Present"),
)
- full-cycle ML model development: from literature survey and data collection to reproducible training and deployment
- working with both generative and predictive models for various tasks in the antibody development field

#work(
  title: "Open-source software engineer",
  location: "Remote",
  company: "MDAnalysis via Google Summer of Code",
  dates: dates-helper(start-date: "May 2023", end-date: "September 2023"),
)
- wrote backward-compatible parallelization for molecular dynamics trajectory analysis

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
- coordinated data analysis and manuscript preparation

#work(
  title: "Scientific Journalist",
  location: "Moscow, Russia",
  company: "Moscow Institute of Physics and Technology",
  dates: dates-helper(start-date: "Jun 2022", end-date: "Aug 2022"),
)
- wrote press-releases on published papers
- communicated with scientists & media.

== Skills
- *Programming Languages*: Python, bash, Rust, C++, Typescript
- *Python*: uv/ruff/ty❤️‍🔥, pytest, hypothesis, pydantic, dask
- *Data Science*: polars🫶, huggingface🤗, pandas, numpy, sklearn, skrub
- *Visualization*: altair, marimo, matplotlib/seaborn/jupyter
- *Deep Learning*: pytorch, lightning, jax, mlflow
- *ML in biology*: protein language models, diffusion/discrete diffusion/flow matching, Alphafold/Openfold/Boltz
- *Technologies*: AWS, Docker, SLURM, Modal, Airflow, Github actions
- *Cheminformatics*: RDKit, polaris, molecular docking, structural bioinformatics (MDAnalysis/mdtraj/biotite)

== Publications

#project(
  name: "CryoRhodopsins: a comprehensive characterization of a new clade of microbial rhodopsins from cold environments",
)
- #text(style: "italic")[Science Advances], July 2025
- prepared samples for cryoEM (nanodisc reconstitution), processed cryoEM data and organized data collection

// #project(
// role: "Structural basis for no retinal binding in flotillin-associated rhodopsins",
// name: "biorxiv",
// dates: "29 April 2025"
// )
// - Prepared samples for cryoEM (nanodisc reconstitution), processed cryoEM data and organized data collection.

// #project(
// role: "A subgroup of light-driven sodium pumps with an additional Schiff base counterion",
// name: "Nature Communications",
// dates: "4 October 2024"
// )
// - Reconstituted protein into nanodiscs and processed cryo-EM data.

#project(
  name: "Regression-Based Active Learning for Accessible Acceleration of Ultra-Large Library Docking",
)
- #text(style: "italic")[Journal of Chemical Information and Modeling], December 2023
- proposed the project, supervised the study and wrote manuscript, performed ML benchmarks

#project(
  role: "Custom Design of a Humidifier Chamber for In Meso Crystallization",
)
- #text(style: "italic")[Crystal Growth & Design], December 2023
- purified and crystallized protein, performed in meso crystallization, processed data, refined the structure, analyzed cryo-EM data, wrote the manuscript

// #project(
// role: "Mirror proteorhodopsins",
// name: "Nature Comm. Chemistry",
// dates: "2 May 2023"
// )
// - Collected crystallographic data and solved the structure.

#project(
  role: "Structural insights into thrombolytic activity of destabilase from medicinal leech",
)
- #text(style: "italic")[Scientific Reports], April 2023
- Crystallized the protein, collected data, solved the structures, performed molecular dynamics simulations and analyzed the results.

// #project(
// role: "Structural insights into the effects of glycerol on ligand binding to cytochrome P450",
// name: "Acta Crystallographica Section D",
// dates: "12 August 2022"
// )
// - Collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models.

#project(
  role: "Structural basis for receptor selectivity and inverse agonism in S1P5 receptors",
)
- #text(style: "italic")[Nature Communications], August 2022
- collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models

// #project(
// role: "A new twist of rubredoxin function in M. tuberculosis",
// name: "Bioorganic Chemistry",
// dates: "1 April 2021"
// )
// - Collected crystallography data, supervised model refinement, wrote manuscript

#project(
  role: "Metabolic fate of human immunoactive sterols in Mycobacterium tuberculosis",
)
- #text(style: "italic")[Journal of Molecular Biology], February 2021
- collected crystallography data, supervised model refinement, wrote manuscript

#project(
  role: "Structural Aspects of Photopharmacology: Insight into the Binding of Photoswitchable and Photocaged Inhibitors to the Glutamate Transporter Homologue",
)
- #text(style: "italic")[Journal of American Chemical Society], January 2021
- performed molecular docking of photo-switchable compounds in crystallographic structure and compared docking results with functional data

#project(
  role: "Structure-Based Virtual Screening of Ultra-Large Library Yields Potent Antagonists for a Lipid GPCR",
)
- #text(style: "italic")[Biomolecules], December 2020
- prepared small-molecule libraries for docking, did large-scale docking and analyzed the results, wrote manuscript

// #project(
// role: "Hydroxylation of antitubercular drug candidate, SQ109, by mycobacterial cytochrome P450",
// name: "International Journal of Molecular Sciences",
// dates: "16 October 2020"
// )
// - Collected crystallography data, supervised model refinement, discussed draft.

#project(
  role: "Small-wedge synchrotron and serial XFEL datasets for cysteinyl leukotriene GPCRs",
)
- #text(style: "italic")[Scientific Data], November 2020
- organized, annotated and deposited raw data, developed robust re-processing algorithms, wrote manuscript

#project(
  role: "Molecular mechanism of light-driven sodium pumping",
)
- #text(style: "italic")[Nature Communications], May 2020
- processed serial synchrotron crystallography data using CrystFEL, deposited raw data

#project(
  role: "Structural basis of ligand selectivity and disease mutations in cysteinyl leukotriene receptors",
)
- #text(style: "italic")[Nature Communications], December 2019
- collected small-wedge serial synchrotron crystallography data, refined, deposited, and analyzed structures, wrote the manuscript

#project(
  role: "Structure-based mechanism of cysteinyl leukotriene receptor inhibition by antiasthmatic drugs",
)
- #text(style: "italic")[Science Advances], October 2019
- collected synchrotron crystallography data, processed XFEL and synchrotron data, refined, deposited and analyzed structures, wrote the manuscript

#project(
  role: "An outlook on using serial femtosecond crystallography in drug discovery",
)
- #text(style: "italic")[Expert Opinion on Drug Discovery], June 2019
- wrote sections about SFX data processing and phasing

#project(
  role: "Structural insights into ion conduction by channelrhodopsin 2",
)
- #text(style: "italic")[Science], November 2017
- performed data processing for both WT and mutant proteins

// #project(
// role: "Element-specific density profiles in interacting biomembrane models",
// name: "Journal of Physics D: Applied Physics",
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
- methods: cryoEM, X-ray crystallography, protein biochemistry, protein biophysics
- publications in JACS, Crystal Growth & Design, Journal of Cheminformatics & Modelling

#edu(
  institution: "Computer Science Center",
  location: "St. Petersburg, Russia",
  dates: dates-helper(start-date: "2020", end-date: "2022"),
  degree: "Full-time extracurricular educational program in computer science",
  consistent: true,
)
- relevant coursework: Python, C++, Algorithms and data structures, Data science, Intro to Linux systems, Rust

#edu(
  institution: "Moscow Institute of Physics and Technology",
  location: "Moscow, Russia",
  dates: dates-helper(start-date: "2017", end-date: "2019"),
  degree: "MSc in applied mathematics and physics",
  consistent: true,
)
- managed bachelor and master students, created a course on modern protein crystallography
- publications in Science, Nature Communications, Science Advances, Scientific Data
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

== Extracurricular Activities

#extracurriculars(
  activity: "Open-source contributions",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- #link("https://github.com/rs-station/reciprocalspaceship")[reciprocalspaceship]: wrote parser for serial crystallography data into binary dataframe-like class
- #link("https://github.com/marinegor/ntfy_cryosparc/")[ntfy-cryosparc]: wrote web-server to parse CryoSPARC notifications and notify appropriate users
- #link("https://github.com/ion-elgreco/polars-distance/")[polars-distance]: minor contribution to polars plugin for distance calculation

#extracurriculars(
  activity: "MDAnalysis Core Developer",
  dates: dates-helper(start-date: "February 2025", end-date: "Present"),
)
- #link("https://www.mdanalysis.org/pages/team/")[MDAnalysis Core Developer]
  - wrote a #link("https://github.com/MDAnalysis/mdanalysis/pull/4162")[parallel backend] for all analysis classes (dask/multiprocessing)
  - added a #link("https://github.com/MDAnalysis/mdanalysis/pull/4304")[DSSP module] for native secondary structure assignment
  - currently working on an #link("https://github.com/MDAnalysis/mdanalysis/pull/4712")[MMCIF parser] based on `gemmi`

#extracurriculars(
  activity: "Self-hosting",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- self-hosting bunch of open-source docker containers under Tailscale VPN

#extracurriculars(
  activity: "Data Science Competitions",
  dates: dates-helper(start-date: "2018", end-date: "Present"),
)
- top-10% in Kaggle "Predict Molecular Properties" (public notebooks + gradient boosting on self-written rotationally invariant features)
- top-1 in first round of "Learning How To Smell" at AIcrowd
- top-10% in Takeda competition at Signate
- 5th place in Tochka Bank graph ML competition
