library(tidyverse)

cogid <- read_tsv("etc/cognacy-vrosenberg1853-output.tsv")

rawdat <- read_tsv("raw/raw-dat.tsv")

cogid_mini <- cogid |>
    select(ID, Doculect = DOCULECT, COGID, ALIGNMENT)

rawdat |> left_join(cogid_mini)
