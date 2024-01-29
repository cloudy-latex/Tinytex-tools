library(lubridate)
library(stringr)

log_file_paths <- c("main.log")

log_content_single_file <- sapply(log_file_paths, function(path) {
    readLines(path, warn = FALSE)
}, USE.NAMES = FALSE)
# Concatenate the content of all log files
log_content <- unlist(log_content_single_file, use.names = FALSE)
# Define the regular expression pattern for Latex packages
# This pattern is designed to capture the package name, date/version, and 
# description separately
pattern <- "Package: ([^ ]+) (.+)"
# Use grep to find lines that match the pattern, value = TRUE returns the 
# matching lines
matching_lines <- grep(pattern, log_content, value = TRUE)
# Initialize a data frame to store the results
package_data <- data.frame(name=character(), date=character(), 
    description=character(), stringsAsFactors=FALSE)
for (line in matching_lines) {
    # Extract package name, date/version, and description from each line
    if (grepl(pattern, line)) {
        matches <- regmatches(line, regexpr(pattern, line))
        split_line <- strsplit(sub(pattern, "\\1 \\2", matches), " ")
        # Assigning values to name, date/version, and description
        name <- split_line[[1]][1]
        date <- format(ymd(split_line[[1]][2]), "%Y-%m-%d")
        version <- str_extract(split_line[[1]][3], "v[0-9.]+")[1]
        description <- paste(split_line[[1]][-c(1, 2, 3)], collapse=" ")
        # Append the extracted information to the dataframe
        package_data <- rbind(package_data, data.frame(
            name=name, date=date, version=version, description=description))
    }
}
write.csv(package_data, 'latex_packages.csv', row.names = FALSE)
