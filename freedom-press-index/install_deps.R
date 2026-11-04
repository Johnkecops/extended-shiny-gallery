# install_deps.R
# Script to install all required dependencies for fopi.app

if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install missing CRAN dependency for fopi
if (!requireNamespace("plumber", quietly = TRUE)) {
  install.packages("plumber", repos = "https://cloud.r-project.org")
}

# Install GitHub dependencies specified in DESCRIPTION Remotes
remotes::install_deps(dependencies = TRUE)

message("All dependencies installed successfully.")
