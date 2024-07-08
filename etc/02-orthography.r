library(tidyverse)
library(qlcData)

df <- read_tsv("raw/raw-dat.tsv")

doculect <- unique(df$Doculect)

# for (dcl in seq_along(doculect)) {
#    txts <- pull(filter(df, Doculect == doculect[dcl]), Form)

#    qlcData::write.profile(txts, normalize = "NFC", info = TRUE, editing = TRUE, file.out = paste("etc/orthography/", doculect[dcl], ".tsv", sep = ""))
#}

for (i in seq_along(doculect)) {

    txts <- df$Form[df$Doculect == doculect[i]]
    ids <- df$ID[df$Doculect == doculect[i]]
    prf <- str_subset(dir("etc/orthography", full.names = TRUE), doculect[i])
    trsl <- qlcData::tokenize(txts, profile = prf, transliterate = "Replacement", ordering = NULL, sep.replace = "_", regex = TRUE)
    trsl_str <- trsl$strings |>
        mutate(Doculect = doculect[i],
            ID = ids) |>
        select(-originals)
    write_tsv(trsl_str, file = paste("etc/transliterated/", doculect[i], "-trans.tsv", sep = ""))
}


