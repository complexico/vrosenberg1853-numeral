library(tidyverse)

# preparing data for automatic cognate analyses from the cldf data

formtable <- read_csv("cldf/forms.csv")

formtable1 <- formtable |>
select(ID = Local_ID, DOCULECT = Language_ID, CONCEPT = Parameter_ID, TOKENS = Segments) |>
mutate(GLOSS_ID = str_replace(CONCEPT, "_.+$", "")) |>
mutate(CONCEPT = str_replace(CONCEPT, ".*_", "")) |>
mutate(IPA = str_replace_all(TOKENS, "\\s", ""))

formtable1 |> write_tsv("etc/cognacy-vrosenberg1853-input.tsv")
