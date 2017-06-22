#!/bin/bash
#  --- Create, bootstrap, shrink and copy/compress an image from a .def file
#	
#  Usage: buildImg.sh defFile imgSize imgDir
#
# Run this script where the .def files exist
# It is assumed that the images will go into ../images
# The second line of the .def file needs to be the singularity create call
set -x

# Record arguments
deff=$1
imgSize=$2
imgDest=$3

# See https://stackoverflow.com/questions/2664740/extract-file-basename-without-path-and-extension-in-bash
b=${deff##*/}
imgBase=${b%.*}
imgFile=${imgBase}.img
sqshFile=${imgBase}.sqsh
tarFile=${imgBase}.tar

echo ${imgBase}
echo ${imgFile}
echo ${sqshFile}
echo ${tarFile}

# Clean up old files
rm -f ${imgDest}/${imgFile}
rm -f ${imgDest}/${sqshFile}
sudo rm -rf /tmp/${imgBase}*

# Create the image
sudo singularity create -s $imgSize /tmp/${imgFile}

# Run bootstrap
sudo singularity bootstrap /tmp/${imgFile} $deff

# Export 
sudo singularity export /tmp/${imgFile} > /tmp/${tarFile}

# Unpack the tar file
mkdir /tmp/${imgBase}
pushd /tmp/${imgBase}
sudo tar xf /tmp/${tarFile}
popd

# Make the squashed image
sudo mksquashfs /tmp/${imgBase} ${imgDest}/${sqshFile}

# Make the small image file
realSize=$(sudo du -ks /tmp/${imgBase} | awk '{print int(int($1)/1000)+20}')
sudo singularity create -s $realSize ${imgDest}/${imgFile}

# Create and populate the small image
sudo singularity export /tmp/${imgFile} | sudo singularity import ${imgDest}/${imgFile}

sudo rm -rf /tmp/${imgBase}*