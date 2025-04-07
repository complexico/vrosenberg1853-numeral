library(tidyverse)

# This code is to be run when the following conditions are met:
##
## 1. an existing cldf dataset (with FormTable that contains segmented tokens). This condition also entails:
##    
##    1.1 an initial orthography profile overall and/or per language existed (preferrably also edited and checked)
## 
## 2. an input data containing the segmented tokens to be processed with lingpy's LexStat and Alignment to provide initial cognate identification and alignment between tokens/segments
##
## 3. an output file as the results for running initial cognate identification and alignment analysis. 
##
##    3.1 This output cognate identification file is to be the basis for joining with the initial raw data
##    3.2 This joined RAW DATA and COGNATE+ALIGNMENT OUTPUT will be processed again into CLDF dataset (step 1 above)

cogid <- read_tsv("etc/cognacy-vrosenberg1853-output.tsv")

rawdat <- read_tsv("raw/raw-dat.tsv")

cogid_mini <- cogid |>
    select(ID, English = CONCEPT, 
            Doculect = DOCULECT, 
            COGNACY = COGID, ALIGNMENT)

rawdat_with_cognate <- rawdat |> 
    left_join(cogid_mini)

colnames(rawdat)
colnames(rawdat_with_cognate)