# adapted from: https://github.com/lexibank/constenlachibchan/blob/main/scripts/ortho_profiles.py

## the requirements include:
### - an existing CLDF dataset
### - an existing GENERAL orthography profile inside etc under `orthography.tsv` (Generated via lingpy/cldfbench)
### - an existing `orthography` directory inside etc

from csvw.dsv import UnicodeDictReader
from collections import defaultdict
from clldutils.text import strip_brackets
from unicodedata import normalize

with UnicodeDictReader('cldf/forms.csv') as reader:
    data = [row for row in reader]

with UnicodeDictReader('etc/orthography.tsv', delimiter="\t") as reader:
    profile = {}
    for row in reader:
        profile[normalize('NFC', row['Grapheme'])] = row['IPA']

languages = set([row['Language_ID'] for row in data])

profiles = {language: defaultdict(int) for language in languages}

errors = {}

lexemes = {}

for row in data:
    for char in row['Graphemes'].split():
        char = normalize('NFC', char)
        profiles[row['Language_ID']][char, profile.get(char, char)] += 1   # "?"+

    if [x for x in '˩˨˧˦˥' if x in row['Value']]:
        tone = False
        out = []
        for char in strip_brackets(row['Form']).split(' '):
            char = normalize('NFC', char)
            if [x for x in '˩˨˧˦˥' if x in char]:
                if tone:
                    out[-1] += char
                else:
                    out += [char]
                tone = True
            else:
                tone = False
                try:
                    out[-1] = char+out[-1]
                except IndexError:
                    out += [char]
        lexemes[row['Value']] = ''.join(out)

for language in languages:
    with open('etc/orthography/'+language+'.tsv', 'w') as f:
        f.write('Grapheme\tIPA\tFrequency\n')
        for (char, ipa), freq in profiles[language].items():
            if char == "^":
                pass
            elif char == "$":
                pass
            else:
                f.write('{0}\t{1}\t{2}\n'.format(char, ipa, freq))
            if ipa.startswith('?'):
                errors[char] = ipa[1:]