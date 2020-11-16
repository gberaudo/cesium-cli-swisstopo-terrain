#!/bin/sh
cd inputs
wget https://cms.geo.admin.ch/Topo/swissalti3d/swissalti3dgeotifflv95.zip
wget https://cms.geo.admin.ch/Topo/dhm25/dhm25wabern.zip

for i in *.zip; do unzip $i; done
