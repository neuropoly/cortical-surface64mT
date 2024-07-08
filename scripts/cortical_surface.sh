#!/bin/bash

# This script is used to generate the cortical surface from Hyperfine pediatric brain MRI

img="data/T2w.nii.gz"  
brainmask="data/brainmask.nii.gz"

# Creating the output directory
img_name=$(basename "$img" .nii.gz)
mkdir -p results
output_dir="results/$img_name"
mkdir -p "$output_dir"

# Reconstruction of 3 Hyperfine images (AXI,COR,SAG) to 1.6mm isotropic resolution
isotropic() {
    
    axi_file=$1
    cor_file=$2
    sag_file=$3

    antsMultivariateTemplateConstruction2.sh -d 3 -i 4 -r 1 -f 4x2x1 -s 2x1x0vox -q 30x20x4 \
        -t SyN -m MI -o "${output_dir}/inter" "$axi_file" "$cor_file" "$sag_file"

    ResampleImageBySpacing 3 "${output_dir}/intertemplate0.nii.gz" "${output_dir}/resampledinter.nii.gz" 1.6 1.6 1.6

    antsMultivariateTemplateConstruction2.sh -d 3 -i 4 -z "${output_dir}/resampledinter.nii.gz" \
        -r 1 -f 4x2x1 -s 2x1x0vox -q 30x20x4 -t SyN -m MI -o "${output_dir}/iso" "$axi_file" "$cor_file" "$sag_file"
    
    mv "${output_dir}/isotemplate0.nii.gz" "data/T2w.nii.gz"

}

if [ $(ls data | wc -l) -gt 2 ]; then
    isotropic data/AXI.nii.gz data/COR.nii.gz data/SAG.nii.gz
fi

# Skull strip by registration to a brain template
skullstrip() {

# Creating the brain mask registered to the input image
antsRegistration --dimensionality 3 --float 0 --output ["${output_dir}/${img_name}","${output_dir}/${img_name}_warp.nii.gz"] \
    --interpolation Linear --initial-moving-transform ["$brainmask","$img",1] \
    --transform Rigid[0.1] --metric MI["$brainmask","$img",1,32,Regular,0.25] -v 1 \
    --convergence [1000x500x250x100,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 4x2x1x0vox \
    --transform Affine[0.1] --metric MI["$brainmask","$img",1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,100] --shrink-factors 8x4x2x1 --smoothing-sigmas 4x2x1x0vox \
    --transform SyN[0.1,3,0] --metric CC["$brainmask","$img",1,4] \
    --convergence [100x70x50x20,1e-6,10] --shrink-factors 8x4x2x1 --smoothing-sigmas 4x2x1x0vox

    antsApplyTransforms -d 3 -i "$brainmask" -r "$img" -o "${output_dir}/${img_name}_maskregister.nii.gz" -n Linear \
        -t ["${output_dir}/${img_name}0GenericAffine.mat",1] -t "${output_dir}/${img_name}1InverseWarp.nii.gz" -v 1

# Applying the mask to the input image
mri_binarize --i "${output_dir}/${img_name}_maskregister.nii.gz" --min 0.5 --o "${output_dir}/${img_name}_mask.nii.gz"
fslmaths "$img" -mas "${output_dir}/${img_name}_mask.nii.gz" "${output_dir}/${img_name}_brain.nii.gz"

}

# Segmentation by WMHSynthSeg
segmentation() {

mri_WMHsynthseg --i "${output_dir}/${img_name}_brain.nii.gz" --o "${output_dir}/${img_name}_WMHseg.nii.gz"

}

# Cortical surface extraction with InfantFreeSurfer
cortical_surface() {

    fs_dir="/Applications/freesurfer/7.4.1/subjects/$img_name"
    mkdir -p "$fs_dir"

    cp "$img" "${fs_dir}/mprage.nii.gz"

    infant_recon_all --s $img_name --age 0 --newborn --masked ${output_dir}/${img_name}_brain.nii.gz \
    --segfile ${output_dir}/${img_name}_WMHseg.nii.gz

}

skullstrip
segmentation
cortical_surface
