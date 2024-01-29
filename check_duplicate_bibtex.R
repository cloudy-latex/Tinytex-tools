filename <- file.choose()

lines <- readLines(filename)
ref_pattern <- "^@\\w+\\s*\\{\\s*([^,]+),"
refs <- c()
line_numbers <- c()

for (i in 1:length(lines)) {
    if (grepl(ref_pattern, lines[i])) {
        ref_name <- gsub(ref_pattern, "\\1", lines[i])
        ref_name <- gsub("\\s", "", ref_name)
        refs <- c(refs, ref_name)
        line_numbers <- c(line_numbers, i)
    }
}

dup_refs <- refs[duplicated(refs) | duplicated(refs, fromLast = TRUE)]
for (ref in unique(dup_refs)) {
    cat(paste0("Reference '", ref, "' at lines: ", 
               paste(line_numbers[refs == ref], collapse = ", "), "\n"))
}
