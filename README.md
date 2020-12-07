# POC Swisstopo terrain from Cesium-cli

## Description

The generated terrain is based on 2 datasets, by order of priority:
- Swissalti 3D 0.5m GeoTiffs;
- Swisstopo MNT25 ASCII Grid.

This fallback strategy is necessary since the Swissalti 3D data stops almost at the Swiss boundary.
https://map.geo.admin.ch/?lang=en&topic=ech&bgLayer=ch.swisstopo.pixelkarte-farbe&layers=ch.swisstopo.swissalti3d.metadata,ch.swisstopo.digitales-hoehenmodell_25.metadata

## Instructions

- create a simlink to the CLI
```
ln -s ...../cesium-cli
```

- get submodules
```
git submodule init
```

- get sample data from the Swisstopo shop
```
./get_samples.sh
```

- generate the terrain tiles
```
./generate_terrain.sh
```

- Serve the tiles
```
python serve.py
```

- Navigate http://localhost:8000

## Real data

Here are some general steps for working with real data.

- create one vrt per input data;
gdalbuildvrt -r lanczos -overwrite lv95.vrt CHLV95_LHN95_*.tif

- reproject to EPSG:4326;
gdalwarp -co BIGTIFF=YES --config GDAL_CACHEMAX 2000 -wm 2000 -multi -wo NUM_THREADS=ALL_CPUS -co TILED=YES -co compress=lzw -wo OPTIMIZE_SIZE=YES -t_srs EPSG:4326 -s_srs EPSG:2056 -r lanczos -ovr NONE lv95.vrt CH4326_LN02.tif

- run cli;
 cesium-cli/bin/terrain-tiler \
  --input detailed_4326.tif \
  --input eventual_less_detailed_4326.tif \
  --void-fill Underlying \
  --height-reference Ellipsoid \
  --verbose \
  -o $dbfile

- extract tiles to the filesystem;
python modules/stk_tiles_dumper/stk_tiles_dumper.py -i $dbfile -o $outdir

aws s3 sync --acl public-read --content-encoding gzip --cache-control 'public, max-age=86400' --content-type application/vnd.quantized-mesh '18*' outputs/xx s3://XXX
