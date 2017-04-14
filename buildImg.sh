#!/bin/bash
#  --- Create, bootstrap, shrink and copy/compress an image from a .def file
#
# Run this script where the .def files exist
# It is assumed that the images will go into ../images
# The second line of the .def file needs to be the singularity create call
set -x

# Keep the def file
deff=$1

# Create the image - the second line of the def file says what to do
cmd=$(sed '2q;d' $deff | sed 's/# //')
eval $cmd

# Capture the image file name
img=$(echo ${cmd##* })

# Run boot strap
sudo singularity bootstrap $img $deff

# Shrink it
# Determine actual size of image (giving 20 MB for overhead)
realSize=$(singularity exec $img df -k / | tail -1 | awk '{print int(int($3)/1000)+20}')

# Rename the old image as big
pushd ../images
bigImg=$(basename $img .img)_big.img
smallImg=$(basename $img)
sudo mv $img $bigImg

# Create and populate the small image
sudo singularity create -s $realSize $smallImg
sudo singularity export $bigImg | sudo singularity import $smallImg

# Make the compressed image for copying
gzip -c $smallImg > ${smallImg}.gz

ls -lh $bigImg ${smallImg}*
sudo rm -f $bigImg

popd



