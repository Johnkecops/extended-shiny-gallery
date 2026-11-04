# freedom-press-index

---

- Developed by: [John Coene](https://john-coene.com)
- Link to deployed app: https://gallery.shinyapps.io/freedom-press-index/

---

## App description

An application to visualise the Freedom of Press Index.

## Installation & Setup

To install all required CRAN and GitHub dependencies:

```r
source("install_deps.R")
```

Or manually in R:

```r
install.packages("remotes", repos = "https://cloud.r-project.org")
remotes::install_deps(dependencies = TRUE)
```

## Running the Application

In R or RStudio:

```r
shiny::runApp()
```

Or from the command line:

```bash
Rscript app.R
```

