import json
from os import name
import pycountry

with open('./cities.json', encoding="UTF-8") as f:
    d = json.load(f)
    # print(d)

print(type(d))

for i in range(len(d)):
    p = pycountry.countries.get(alpha_2=d[i]['country'])

    if(pycountry.countries.get(alpha_2=d[i]['country']) is not None):
        d[i]['ISO_A3'] = p.alpha_3
    else:
        d[i]['ISO_A3'] = 'XXK'


with open('cities_2.json', 'w') as f:
    json.dump(d, f)
