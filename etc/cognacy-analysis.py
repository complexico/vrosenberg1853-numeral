# Source: List, Johann-Mattis (2017). Historical Language Comparison with LingPy and EDICTOR
from lingpy import *

# automatic cognate analysis
lex = LexStat("etc/cognacy-vrosenberg1853-input.tsv")
lex.cluster(method="sca", threshold=0.45, ref="cogid")

# alignment analysis
alm = Alignments(lex, ref = "cogid")
alm.align()
alm.output(fileformat = "tsv", 
           filename = "etc/cognacy-vrosenberg1853-output", 
           subset = True, 
           cols = ["doculect", "concept", "ipa", "tokens", "cogid", "alignment"],
           prettify = False, 
           ignore = "all")