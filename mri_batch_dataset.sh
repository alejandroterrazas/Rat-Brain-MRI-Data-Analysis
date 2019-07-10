
#!/bin/bash

#clear out old files if they exist
rm -r  ./MRIRawData/$1

#get MRI data from As3 bucket
aws s3 cp s3://narp-alext/$1 ./MRIRawData/$1 --exclude '*' --include 'fine.nii' --include 'bias_corrected.nii' --recursive

cd MRIRawData/$1
#make crude mask for bias correction
mrmath bias_corrected.nii fine.nii product masked_bias_corrected.nii

#run long processes of registration

antsRegistrationSyN.sh -d 3 -f masked_bias_corrected.nii -m ~/MRITemplates/t2refcroppedmasked_150.nii -o registered_reference

#transform the atlast to the rat MRI

antsApplyTransforms -f 0 -d 3 -i ~/MRITemplates/atlascropped.nii -n NearestNeighbor -o ./atlas_warped.nii -r masked_bias_corrected.nii -t registered_reference1Warp.nii.gz -t registered_reference0GenericAffine.mat

mkdir ../processed
mv * ../processed
cd ../processed



python ~/OutputBrainAreas.py "atlas_warped.nii" $1

~
aws s3 cp ./ s3://narp-alext/$1  --exclude '*' --include '*.gz' --include '*.nii' --include '*.mat' --include '*.xlsx'  --recursive 
 

