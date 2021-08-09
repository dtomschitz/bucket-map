import json

with open("./cities.json") as f:
    d = json.load(f)
    print(d)