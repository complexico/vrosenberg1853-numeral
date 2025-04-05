library(tidyverse)

df <- read_tsv("raw/raw-dat.tsv")

doculect <- unique(df$Doculect)

# The for-loop below is for creating the first orthography profile (followed with manual post-editing) # nolint

# for (dcl in seq_along(doculect)) {
#    txts <- pull(filter(df, Doculect == doculect[dcl]), Form) # nolint

#    qlcData::write.profile(txts, normalize = "NFC", info = TRUE, editing = TRUE, file.out = paste("raw/orthography-from-R/", doculect[dcl], ".tsv", sep = "")) # nolint
#}

# The for-loop below is for tokenising and transliterating the forms based on the orthography profile # nolint
for (i in seq_along(doculect)) {

    txts <- df$Form[df$Doculect == doculect[i]] # nolint
    ids <- df$ID[df$Doculect == doculect[i]]
    prf <- str_subset(dir("raw/orthography-from-R", full.names = TRUE), doculect[i]) # nolint: line_length_linter.
    trsl <- qlcData::tokenize(txts, 
            profile = prf, 
            transliterate = "Replacement", 
            ordering = NULL, 
            sep.replace = "_", 
            regex = TRUE)
    trsl_str <- trsl$strings |>
        mutate(Doculect = doculect[i],
            ID = ids) |>
        select(-originals)
    write_tsv(trsl_str, 
                file = paste("raw/transliterated/", 
                doculect[i], 
                "-trans.tsv", sep = "")
                )
}

# create CLDF-style orthography profile files ======
## but first, remove the R-derived and manually edited orthography files
## into different directory [e.g., into `raw`]

### create a sub-directory in `raw` called `orthography-from-R`
# dir.create("raw/orthography-from-R")
# dir.create("raw/transliterated")

### move the orthography profile files
# fs::file_move(path = dir("etc/orthography", full.names = TRUE), new_path = "raw/orthography-from-R")
# fs::file_move(path = dir("etc/transliterated", full.names = TRUE), new_path = "raw/transliterated") # nolint: line_length_linter.
# unlink("etc/transliterated", recursive = TRUE)
# unlink("etc/orthography", recursive = TRUE)
