# singularity-def



## Shrinking images

When creating an image, you typically need to make it much larger than the final size due to overhead from `yum` and building applications. The easiest way to shrink an image is to determine the size needed, rename the image file, create a new image with the desired smaller size, and then use Singularity to export the old image piped to import for the new image. For example,

```bash
$ mv centos6_dev.img centos6_dev_big.img
$ singularity exec centos6_dev_big.img df -h /
Filesystem      Size  Used Avail Use% Mounted on
singularity     1.2G  542M  580M  49% /

# So our 1.2GB image really only needs 542MB.
$ sudo singularity create -s 600 centos6_dev.img   # Be a little generous
$ sudo singularity export centos6_dev_big.img | sudo singularity import centos6_dev.img

$ singularity exec centos6_dev.img df -h
Filesystem      Size  Used Avail Use% Mounted on
singularity     591M  525M   36M  94% /

# Et voila - you can delete the big image now
```
