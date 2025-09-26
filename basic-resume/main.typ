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
  accent-color: "#26428b",
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
- *Deep Learning*: pytorch, lightning, jax, mlflow
- *ML in biology*: protein language models, diffusion/discrete diffusion/flow matching, Alphafold/Openfold/Boltz
- *Technologies*: AWS, Docker, SLURM, Modal, Airflow, Github actions
- *Cheminformatics*: RDKit, polaris, molecular docking, structural bioinformatics (MDAnalysis/mdtraj/biotite)

== Publications

#project(
  role: "CryoRhodopsins: a comprehensive characterization of a new clade of microbial rhodopsins from cold environments",
  name: "Science Advances",
  dates: "7 July 2025"
)
- Prepared samples for cryoEM (nanodisc reconstitution), processed cryoEM data and organized data collection.

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
  role: "Regression-Based Active Learning for Accessible Acceleration of Ultra-Large Library Docking",
  name: "Journal of Chemical Information and Modeling",
  dates: "29 December 2023"
)
- Proposed the project, supervised the study and wrote manuscript, performed ML benchmarks.

#project(
  role: "Custom Design of a Humidifier Chamber for In Meso Crystallization",
  name: "Crystal Growth & Design",
  dates: "12 December 2023"
)
- Purified and crystallized protein, performed in meso crystallization, processed data, refined the structure, analyzed cryo-EM data, wrote the manuscript.

// #project(
  // role: "Mirror proteorhodopsins",
  // name: "Nature Comm. Chemistry",
  // dates: "2 May 2023"
// )
// - Collected crystallographic data and solved the structure.

#project(
  role: "Structural insights into thrombolytic activity of destabilase from medicinal leech",
  name: "Scientific Reports",
  dates: "24 April 2023"
)
- Crystallized the protein, collected data, solved the structures, performed molecular dynamics simulations and analyzed the results.

// #project(
  // role: "Structural insights into the effects of glycerol on ligand binding to cytochrome P450",
  // name: "Acta Crystallographica Section D",
  // dates: "12 August 2022"
// )
// - Collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models.

#project(
  role: "Structural basis for receptor selectivity and inverse agonism in S1P5 receptors",
  name: "Nature Communications",
  dates: "12 August 2022"
)
- Collected data at PAL XFEL, processed SFX data, refined model, performed Alphafold simulations, molecular docking & VLS benchmarks of available S1P models.

// #project(
  // role: "A new twist of rubredoxin function in M. tuberculosis",
  // name: "Bioorganic Chemistry",
  // dates: "1 April 2021"
// )
// - Collected crystallography data, supervised model refinement, wrote manuscript

#project(
  role: "Metabolic fate of human immunoactive sterols in Mycobacterium tuberculosis",
  name: "Journal of Molecular Biology",
  dates: "19 February 2021"
)
- Collected crystallography data, supervised model refinement, wrote manuscript

#project(
  role: "Structural Aspects of Photopharmacology: Insight into the Binding of Photoswitchable and Photocaged Inhibitors to the Glutamate Transporter Homologue",
  name: "Journal of American Chemical Society",
  dates: "15 January 2021"
)
- Did molecular docking of photo-switchable compounds in crystallographic structure and compared docking results with functional data.

#project(
  role: "Structure-Based Virtual Screening of Ultra-Large Library Yields Potent Antagonists for a Lipid GPCR",
  name: "Biomolecules",
  dates: "3 December 2020"
)
- Prepared small-molecule libraries for docking, did large-scale docking and analyzed the results, wrote manuscript.

// #project(
  // role: "Hydroxylation of antitubercular drug candidate, SQ109, by mycobacterial cytochrome P450",
  // name: "International Journal of Molecular Sciences",
  // dates: "16 October 2020"
// )
// - Collected crystallography data, supervised model refinement, discussed draft.

#project(
  role: "Small-wedge synchrotron and serial XFEL datasets for cysteinyl leukotriene GPCRs",
  name: "Scientific Data",
  dates: "12 November 2020"
)
- Organized, annotated and deposited raw data, developed robust re-processing algorithms, wrote manuscript.

#project(
  role: "Molecular mechanism of light-driven sodium pumping",
  name: "Nature Communications",
  dates: "1 May 2020"
)
- Processed serial synchrotron crystallography data using CrystFEL, deposited raw data.

#project(
  role: "Structural basis of ligand selectivity and disease mutations in cysteinyl leukotriene receptors",
  name: "Nature Communications",
  dates: "6 December 2019"
)
- Collected small-wedge serial synchrotron crystallography data, processed them, refined, deposited and analyzed structures.

#project(
  role: "Structure-based mechanism of cysteinyl leukotriene receptor inhibition by antiasthmatic drugs",
  name: "Science Advances",
  dates: "1 October 2019"
)
- Collected synchrotron crystallography data, processed XFEL and synchrotron data, refined, deposited and analyzed structures.

#project(
  role: "An outlook on using serial femtosecond crystallography in drug discovery",
  name: "Expert Opinion on Drug Discovery",
  dates: "11 June 2019"
)
- Wrote sections about SFX data processing & phasing.

#project(
  role: "Structural insights into ion conduction by channelrhodopsin 2",
  name: "Science",
  dates: "24 November 2017"
)
- Data collection and processing for both WT and mutant proteins.

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
- Founder of Les Amateurs (#link("https://amateurs.team")[amateurs.team]), currently ranked \#4 US, \#33 global on CTFTime (2023: \#4 US, \#42 global)

#extracurriculars(
  activity: "MDAnalysis Core Developer",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- Founder of Les Amateurs (#link("https://amateurs.team")[amateurs.team]), currently ranked \#4 US, \#33 global on CTFTime (2023: \#4 US, \#42 global)

#extracurriculars(
  activity: "Self-hosting",
  dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)

#extracurriculars(
  activity: "Data Science Competitions",
  // dates: dates-helper(start-date: "Jan 2021", end-date: "Present"),
)
- Founder of Les Amateurs (#link("https://amateurs.team")[amateurs.team]), currently ranked \#4 US, \#33 global on CTFTime (2023: \#4 US, \#42 global)
