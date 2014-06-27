#!/bin/bash

# This code takes the MT, PD and R2* files from the mpm_dir,
# converts them to freesurfer space (in the surfer_dir) and then
# extracts a bunch of different values from each of them

# USAGE: mpm_freesurfer_roi_extract <mpm_dir> <surfer_dir>

# INPUTS
mpm_dir=$1
surfer_dir=$2

# Loop through the mpm outputs that you're interested in
for mpm in MT R2s; do

    # Convert the mpm nii file to mgz format
    mri_convert ${mpm_dir}/${mpm}_head.nii.gz ${mpm_dir}/${mpm}_head.mgz
    
    # Align the mgz file to "freesurfer" anatomical space
    mri_vol2vol --mov ${mpm_dir}/${mpm}_head.mgz \
                --targ ${surfer_dir}/mri/T1.mgz \
                --regheader \
                --o ${surfer_dir}/mri/${mpm}.mgz --no-save-reg

    # Extract roi values
    #=== wmparc
    mri_segstats --i ${surfer_dir}/mri/${mpm}.mgz \
                 --seg ${surfer_dir}/mri/wmparc.mgz \
                 --ctab ${FREESURFER_HOME}/WMParcStatsLUT.txt \
                 --sum ${surfer_dir}/stats/${mpm}_wmparc.stats \
                 --pv ${surfer_dir}/mri/norm.mgz

    #=== aseg
    mri_segstats --i ${surfer_dir}/mri/${mpm}.mgz \
                 --seg ${surfer_dir}/mri/aseg.mgz \
                 --ctab ${FREESURFER_HOME}/ASegStatsLUT.txt \
                 --sum ${surfer_dir}/stats/${mpm}_aseg.stats \
                 --pv ${surfer_dir}/mri/norm.mgz
                 
done

