# cortical-surface64mT
Pipeline for generating the cortical surface from Hyperfine pediatric brain MRI

## Dependencies

You will need to download each of these four tools individually to run this pipeline. Installation instructions for each tool can be found at the provided links.

- [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
- [ANTS](http://stnava.github.io/ANTs/)
- [FreeSurfer](https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/) (dev version ubuntu22-7-dev_amd64)
- [Infant FreeSurfer](https://lcn.martinos.org/infant-freesurfer-request/) (version linux-centos7_x86_64-infant-dev-4a14499)

For members of NeuroPoly lab; `bireli` has all of these versions installed. Just type `fs infant` in the terminal in order to change the version of FreeSurfer to Infant FreeSurfer.

## Usage

This script expects your input image to be named T2w.nii.gz and be inside the data folder. If you have Hyperfine images of 3 orientations and wish to proceed with an isotropic reconstruction, 3 images must be inside the data folder and respectively be named AXI.nii.gz, SAG.nii.gz and COR.nii.gz. 

Once your image is inside the data folder, navigate to the `cortical-surface64mT` repository in your terminal and type `bash scripts/cortical_surface.sh` to launch the pipeline.

After running the cortical_surface.sh script, you can go inside your FreeSurfer subject folder and open `surf/rh.pial` and `surf/lh.pial` in Freeview to visualize the pial surface of the brain.

