from doc2dash.parsers.intersphinx import InterSphinxParser

# Sphinx Directive Type -> Dash Entry Type
# Read ./docs/dash_zeal_type.md for types supported by Dash and Zeal
# You can figure out which directive type Coq uses can be listed using ./tools/parse_objects_inv.py
# The description of Coq directive can be found in:
#   https://github.com/coq/coq/blob/master/doc/tools/coqrst/coqdomain.py
TYPE_MAP = {
    'coq:cmd': 'Command', # Coq command.
    'coq:cmdv': 'Variable', # A variant of a Coq command.
    'coq:exn': 'Error', # An error raised by a Coq command or tactic.
    'coq:flag': 'Flag', # A Coq flag (i.e. a boolean setting).
    'coq:index': 'Index', # A link to one of our domain-specific indices.
    'coq:opt': 'Option', # A Coq option (a setting with non-boolean value, e.g. a string or numericvalue).
    'coq:table': 'Table', # A Coq table, i.e. a setting that is a set of values.
    'coq:tacn': 'Tactic', # A tactic, or a tactic notation.
    'coq:tacv': 'Variant', # A variant of a tactic.
    'coq:warn': 'Warn', # An warning raised by a Coq command or tactic..
    'std:doc': 'Guide',
    'std:label': 'Section',
    'std:token': 'Keyword'
}

class CoqSphinxParser(InterSphinxParser):
  def convert_type(self, inv_type):
    return TYPE_MAP.get(inv_type)
