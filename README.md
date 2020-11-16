# POC Swisstopo terrain from Cesium-cli

## Description

The generated terrain is based on 2 datasets, by order of priority:
- Swissalti 3D 0.5m GeoTiffs;
- Swisstopo MNT25 ASCII Grid.

This fallback strategy is necessary since the Swissalti 3D data stops almost at the Swiss boundary.
https://map.geo.admin.ch/?lang=en&topic=ech&bgLayer=ch.swisstopo.pixelkarte-farbe&layers=ch.swisstopo.swissalti3d.metadata,ch.swisstopo.digitales-hoehenmodell_25.metadata

## Instructions

- create a simlink to the CLI
ln -s ...../cesium-cli

- get submodules
git submodules --init

- get sample data from the Swisstopo shop
./get_samples.sh

- generate the terrain tiles
./generate_terrain.sh

- Serve the tiles
python serve.py

- Navigate http://localhost:8000

