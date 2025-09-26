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


== Education

#edu(
  institution: "University of Groningen",
  location: "Groningen, Netherlands",
  dates: dates-helper(start-date: "2019", end-date: "2023"),
  degree: "PhD",
  consistent: true
)
- thesis 'On the methods of studying protein-ligand interaction dynamics'"
- methods: cryoEM, X-ray crystallography, protein biochemistry, protein biophysics
- publications in JACS, Crystal Growth & Design, Journal of Cheminformatics & Modelling

#edu(
  institution: "Computer Science Center",
    location: "St. Petersburg, Russia",
    dates: dates-helper(start-date: "2020", end-date: "2022"),
    degree: "Full-time extracurricular educational program in computer science",
    consistent: true
)
- relevant coursework: Python, C++, Algorithms and data structures, Data science, Intro to Linux systems, Rust

#edu(
  institution: "Moscow Institute of Physics and Technology",
    location: "Moscow, Russia",
    dates: dates-helper(start-date: "2017", end-date: "2019"),
    degree: "MSc in applied mathematics and physics",
    consistent: true
)
- managed bachelor and master students, created a course on modern protein crystallography
- publications in Science, Nature Communications, Science Advances, Scientific Data
- graduated #text(style: "italic")[summa cum laude]

#edu(
  institution: "Moscow Institute of Physics and Technology",
    location: "Moscow, Russia",
    dates: dates-helper(start-date: "2017", end-date: "2019"),
    degree: "BSc in applied mathematics and physics",
    consistent: true
)
- graduated #text(style: "italic")[magna cum laude]
- related coursework: Calculus I-IV, Linear Algebra I-II, Complex Analysis, Differential Equations I-II, Analytical Mechanics I-II, Thermodynamics.


== Publications

#project(
  name: "Hyperschedule",
  // Role is optional
  role: "Maintainer",
  // Dates is optional
  dates: dates-helper(start-date: "Nov 2023", end-date: "Present"),
  // URL is also optional
  url: "hyperschedule.io",
)
- Maintain open-source scheduler used by 7000+ users at the Claremont Consortium with TypeScript, React and MongoDB
  - Manage PR reviews, bug fixes, and coordinate with college for releasing scheduling data and over \$1500 of yearly funding
- Ensure 99.99% uptime during peak loads of 1M daily requests during course registration through redundant servers

== Skills
- *Programming Languages*: Python, bash, Rust, C++, Typescript
- *Python*: uv/ruff/ty❤️‍🔥, pytest, hypothesis, pydantic, dask
- *Data Science*: polars🫶, huggingface🤗, pandas, numpy, sklearn, skrub
- *Deep Learning*: pytorch, lightning, jax, mlflow
- *ML in biology*: protein language models, diffusion/discrete diffusion/flow matching, Alphafold/Openfold/Boltz
- *Technologies*: AWS, Docker, SLURM, Modal, Airflow, Github actions
- *Cheminformatics*: RDKit, polaris, molecular docking, structural bioinformatics (MDAnalysis/mdtraj/biotite)

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
