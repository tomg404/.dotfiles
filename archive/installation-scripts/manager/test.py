from dataclasses import dataclass, fields
from dataclass_wizard import YAMLWizard, JSONListWizard, JSONWizard
import yaml

@dataclass
class prog(JSONListWizard):
    attr: str

@dataclass
class config(JSONListWizard):
    progs: list[prog]

with open("test.yaml", "r") as f:
    c = yaml.safe_load(f)
print(c)

c = config.from_dict(c)
print(c.progs)

