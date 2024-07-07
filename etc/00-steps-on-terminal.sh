source /Users/Primahadi/Documents/cldf_project/myenv/bin/activate

cldfbench new
# id: vrosenberg1853
# title: CLDF dataset derived from von Rosenberg's "De Mentawei-Eilanden en Hunne Bewoners" from 1853 for comparative numeral data
# license: https://creativecommons.org/licenses/by-nc-sa/4.0/
# url: 
# citation: Rosenberg, Carl Benjamin Hermann von. 1853. De Mentawei-Eilanden en Hunne Bewoners. Tijdschrift voor Indische Taal-, Land- en Volkenkunde 1. 403–440.

cd vrosenberg1853

# pre-process the raw data in `01-raw-data-pre-processing.R`

# edit setup.py and metadata.json in the root directory

# run pyconcepticon
concepticon --repos "/Users/Primahadi/Documents/cldf_project/concepticon/concepticon-data" \
map_concepts "etc/gloss-to-map.tsv" --language en --output "etc/concepts.tsv"

# manually edit the concepts

# remember to left_join the concept to the main raw data table and enumerate the new ID for the forms/rows in the main raw data

# edit the .py custom code

# test the CLDF
cldfbench lexibank.makecldf cldfbench_vrosenberg1853.py --glottolog "/Users/Primahadi/Documents/cldf_project/glottolog-glottolog-d9da5e2" --concepticon "/Users/Primahadi/Documents/cldf_project/concepticon/concepticon-data" --clts "/Users/Primahadi/Documents/cldf_project/cldf-clts-clts-6dc73af"