# centos6_dev.md

The purpose of this container is CENTOS 6 (similar to SLF6) development where CVMFS is available on the host. This container includes,

* Centos 6.7
* Packages for git, support for art, and support for root
* Kerberos client (so kinit to Fermilab will work)
* kx509 and VOMS clients (so you can get a VOMS proxy)
* Mount point for `/cvmfs`
* Mount point for `/Users` (useful on a Mac)
* Mount point for `/exp` (useful for mounting your experiment's disk like `/gm2` or `/nova`)
* Mount point for `/pnfs` (useful if the host has `/pnfs` mounted with NFS4; access may be slow)
* Mount point for `/grid` (useful for `/grid/fermi/app` if the host has it)

# Running the Container

## Running on a Mac

Make sure that the cvmfs mounts are there (use `cvmfs_mount`). 

```bash
singularity shell -p -H /vagrant/homes/centos_dev:/home/me --shell /bin/bash -B /cvmfs,/Users /vagrant/images/centos6_dev.img
```
