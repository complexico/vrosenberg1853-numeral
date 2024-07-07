source /Users/Primahadi/Documents/cldf_project/myenv/bin/activate

cldfbench new
# id: vrosenberg1853
# title: CLDF dataset derived from von Rosenberg's "De Mentawei-Eilanden en Hunne Bewoners" from 1853 for comparative numeral data
# license: https://creativecommons.org/licenses/by-nc-sa/4.0/
# url: 
# citation: Rosenberg, Carl Benjamin Hermann von. 1853. De Mentawei-Eilanden en Hunne Bewoners. Tijdschrift voor Indische Taal-, Land- en Volkenkunde 1. 403–440.

cd vrosenberg1853

# pre-process the raw data in `01-raw-data-pre-processing.R`

# run pyconcepticon
concepticon --repos "/Users/Primahadi/Documents/cldf_project/concepticon/concepticon-data" \
map_concepts "etc/gloss-to-map.tsv" --language en --output "etc/concepts.tsv"