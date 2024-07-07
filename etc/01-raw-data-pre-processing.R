library(tidyverse)
library(deeplr)

df <- read_tsv("https://raw.githubusercontent.com/complexico/mentawai-word-list-1853/main/data/vrosenberg1853p434.tsv")

df <- df |>
	mutate(ID = row_number()) |>
	select(ID, everything()) |>
	pivot_longer(cols = -c(Dutch, ID), names_to = "Doculect", values_to = "Forms")

# prepare a translation data (run one time then save it)
# source("etc/00-deeplr.R")
# dutch <- df |>
#	select(ID, Dutch) |>
#	distinct()

# dutch_w_english <- dutch |>
#	mutate(English = translate2(text = Dutch, target_lang = "EN", source_lang = "NL", preserve_formatting = TRUE, auth_key = mydeepl))

# dutch_w_english <- dutch_w_english |>
# 	mutate(English = replace(English, English == "a", "one"))
# write_tsv(dutch_w_english, file = "etc/dutch_w_english.tsv")

dutch_w_english <- read_tsv("etc/dutch_w_english.tsv")

doculect <- tribble(
	~Doculect, ~Doculect_Eng, ~Glottocode, ~Glottolog_name,
	"Maleisch", "Central Malay", "mala1479", "Central Malay",
	"Lampongsch", "Lampungic", "lamp1241", "Lampungic",
	"Redjangsch", "Rejang", "reja1240", "Rejang",
	"Battasch", "Batakic", "toba1265", "Batakic",
	"Atjinesch", "Acehnese", "achi1257", "Acehnese",
	"Niasch", "Nias", "nias1242", "Nias",
	"Mentaweijsch", "Mentawai", "ment1249", "Mentawai",
	"Engganoosch", "Enggano", "engg1245", "Enggano"
)
# I choose Glottolog's Central Malay because I am not really sure the specific Malay variety referred to by von Rosenberg. Glottolog describes Central Malay as the primary source of the variety of Malay spoken throughout the South East Asia: "Malay (zlm-zlm) = 3 (Wider communication). Originated in Sumatra; spoken throughout southeast Asia. With the advent of Islam, Malay became widespread in the 15th and 16th centuries. Lingua franca for Malaysia’s multiethnic population. Used in trade, literature, and story telling."

df <- df |>
	left_join(dutch_w_english) |>
	select(ID, Forms, Dutch, English, Doculect) |>
	left_join(doculect) |>
	rename(Doculect_orig = Doculect,
		   Doculect = Doculect_Eng)

df |> write_tsv("raw/raw-dat.tsv")

# Prepare the concept for Concepticon mapping
# df |>
# 	select(ENGLISH = English, ID) |>
# 	distinct() |>
# 	write_tsv("etc/gloss-to-map.tsv")
  
