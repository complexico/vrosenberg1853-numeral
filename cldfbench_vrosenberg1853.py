import pathlib

import attr
from clldutils.misc import slug
from pylexibank import Language, FormSpec, Concept, Lexeme
from pylexibank.dataset import Dataset as BaseDataset

@attr.s
class CustomLanguage(Language):
    Sources = attr.ib(default=None)
    Doculect_Dutch = attr.ib(default=None)

@attr.s
class CustomLexeme(Lexeme): # to add custom column into forms.csv (looking at Barlow, Russell & Don Killian. 2023. CLDF dataset derived from Barlow and Killian’s "Tomoip Wordlist" from 2023. Zenodo. https://doi.org/10.5281/zenodo.8437515.)
    CommonTranscription = attr.ib(default=None)

@attr.s
class CustomConcept(Concept):
    Number = attr.ib(default=None)


class Dataset(BaseDataset):
    dir = pathlib.Path(__file__).parent
    id = "vrosenberg1853"

    language_class = CustomLanguage
    lexeme_class = CustomLexeme
    form_spec = FormSpec(normalize_unicode="NFD", separators = ",")
    concept_class = CustomConcept

    # def cldf_specs(self):  # A dataset must declare all CLDF sets it creates.
    #    return super().cldf_specs()

    def cmd_download(self, args):
        """
        Download files to the raw/ directory. You can use helpers methods of `self.raw_dir`, e.g.

        >>> self.raw_dir.download(url, fname)
        """
        pass

    def cmd_makecldf(self, args):

        # personal note: this `add_sources()` will presumably output the "sources.bib" inside cldf because the "sources.bib" under raw is self-added before cldf conversion
        args.writer.add_sources()
        args.log.info("added sources")

        # add languages (personal note: this `add_languages` function will output the "languages.csv" inside cldf)
        languages = args.writer.add_languages(
            id_factory=lambda l: l["Name"], lookup_factory = lambda l: (l["Name"], l["Sources"])
        )
        sources = {k[0]: k[1] for k in languages}
        # IMPORTANT: do not put space in the values of the language "Name" column

        # def cln(word): return re.sub("[†\\d\\.\\*\\?\\~]", "", word)

        # add concept (personal note: this `add_concept()` call will output the "parameters.csv" inside cldf which is taken from etc/concepts.tsv)
        concepts = {}
        for i, concept in enumerate(self.concepts):
            idx = str(i + 1) + "_" + slug(concept["Gloss"])
            args.writer.add_concept(
                ID = idx,
                Name = concept["Gloss"],
                Number = concept["Number"],
                Concepticon_ID = concept["Concepticon_ID"],
                Concepticon_Gloss = concept["Concepticon_Gloss"]
            )
            concepts[concept["Gloss"], concept["Concepticon_ID"]] = idx
            #concepts[concept["Concepticon_ID"]] = idx
        args.log.info("added concepts")

        for idx, row in enumerate(self.raw_dir.read_csv(
            "raw-dat.tsv", delimiter = "\t", dicts = True)):
            # args.writer.add_form_with_segments( # this add_form_with_segments() is used when to include the Segments info from the raw data (this function also requires explicit statement of the addition of the Form variable). But, args.writer.add_forms_from_value is used when we can ignore the Segments variable
            args.writer.add_forms_from_value(
                Local_ID = row["ID"],
                Language_ID = row["Doculect"],
                # For the following line of code in getting the Parameter_ID to work, we need to:
                # - ensure that the CONCEPTICON_ID in the raw/main data and in the Concepts.tsv data is the same.
                #   That is, we cannot have a CONCEPTICON_ID of NA (in the main data [whatever we call this main data] under raw) but then empty/NULL in Concepts.tsv data.
                #   If that is the case, it will throw a KeyError such as `KeyError: ('this and that', 'NA')` (in this case, the function found this key: 'this and that', 'NA' in the raw/main data but in the concepts dictionary, it is 'this and that', '', which is different!)
                Parameter_ID = concepts[row["English"], row["Concepticon_ID"]], 
                # CommonTranscription = row["CommonsNotSegmented"], # this column takes the non-tokenised common transcription
                Value = row["Form"], # this column takes the original transcription
                # Value = row["Mentawai"], # specify this line for the Value col. explicitly when args.writer.add_form_with_segments() is used
                # Form = row["CommonsNotSegmented"], # specify this line for the Segments col. explicitly when args.writer.add_form_with_segments() is used
                #Segments = list(row["IPA"]), # specify this line for the Segments col. explicitly when args.writer.add_form_with_segments() is used; the Segments column needs a list (not string), that is why we use the list() function
                Source = "VonRosenberg1853")