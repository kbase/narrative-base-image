# This script attempts to install all the R dependencies for the narrative base image.
# It goes through all the packages listed, attempts to install them, and saves an error
# message if the install fails.
#

# Set default CRAN repository globally
options(repos = c(CRAN = "http://cran.r-project.org/"))

# Initialize a vector to store error messages
error_messages <- character()

# Function to install packages only if they're not already installed and capture errors
install_if_needed <- function(packages, repos = NULL, type = NULL) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install_args <- list(package)
      if (!is.null(repos)) {
        install_args$repos <- repos
      }
      if (!is.null(type)) {
        install_args$type <- type
      }
      result <- tryCatch({
        do.call(install.packages, install_args)
        library(package, character.only = TRUE)
        TRUE
      }, error = function(e) {
        message <- paste("ERROR:", package, ":", e$message)
        cat(message, "\n")
        return(message)
      })
      if (!isTRUE(result)) {
        error_messages <<- c(error_messages, result)
      }
    }
  }
}

# List of packages to install
common_packages <- c("amap", "curl", "data.table", "devtools", "ggplot2", "googleVis",
                   "gplots", "igraph", "knitr", "lattice", "lme4", "pkgconfig", "png",
                   "pheatmap", "plyr", "RColorBrewer", "reshape", "rgl", "RJSONIO",
                   "stringr", "tiff", "tm", "wordcloud"
)
install_if_needed(common_packages)

# Special cases with specific repos or types
install_if_needed(c("fACD", "timeSeries"), repos = "http://R-Forge.R-project.org")
install_if_needed(c("Rglpk", "Quandl"), type = "source")

# Install development packages from GitHub
if (!require("devtools")) {
  install.packages("devtools")
  library(devtools)
}
devtools_install_result <- tryCatch({
  devtools::install_github("ramnathv/rCharts")
  TRUE
}, error = function(e) {
  message <- paste("ERROR: rCharts (GitHub):", e$message)
  cat(message, "\n")
  return(message)
})

if (!isTRUE(devtools_install_result)) {
  error_messages <<- c(error_messages, devtools_install_result)
}

# Check if there were any errors and exit accordingly
if (length(error_messages) > 0) {
  cat("Errors occurred during installation:\n", paste(error_messages, collapse = "\n"), "\n")
  quit("no", status = 1)  # Exit with status 1 indicating failure
}
