#!/bin/sh

dbfile="outputs/waberm.terraindb"
rm -f $dbfile

# Set an SRS and convert to geotiff the MNT25 background terrain
gdal_translate -a_srs EPSG:21781 -of "GTiff" inputs/Wabern/Matrixmodell/ASCII_GRID/dhm_1.asc inputs/wabern_25_21781.tif

ls inputs/SWISSALTI3D_TIFF_CHLV95_LN02/0.5m/*.tif -1 > inputs.txt
echo inputs/wabern_25_21781.tif >> inputs.txt

# Generate terrain
cesium-cli/bin/terrain-tiler \
  --description "Swisstopo swissalti3d on top of MNT 25" \
  --attribution 'Swisstopo' \
  --name swisstopo_terrain \
  --input-list inputs.txt \
  --void-fill Underlying \
  --height-reference Ellipsoid \
  --verbose \
  -o $dbfile

# Extract to wabern_tiles/ directory
rm -rf outputs/wabern_tiles/
python modules/stk_tiles_dumper/stk_tiles_dumper.py -i $dbfile -o outputs/wabern_tiles/


