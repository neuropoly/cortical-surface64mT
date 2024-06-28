# cortical-surface64mT
Pipeline for generating the cortical surface from Hyperfine pediatric brain MRI

## Dependencies

You will need to download each of these four tools individually to run this pipeline. Installation instructions for each tool can be found at the provided links.

- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
- [ANTS](http://stnava.github.io/ANTs/)
- [FreeSurfer (dev version ubuntu22-7-dev_amd64)](https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/)
- [Infant FreeSurfer (version linux-centos7_x86_64-infant-dev-4a14499)](https://lcn.martinos.org/infant-freesurfer-request/)

For members of NeuroPoly lab; `bireli` has all of these versions installed. You will only need to type `fs infant` in the terminal in order to change the version of FreeSurfer to Infant FreeSurfer.

## Usage

This script expects your input images to be inside the data folder.

