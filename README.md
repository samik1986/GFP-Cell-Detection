# GFP-Cell-Detection
[![DOI](https://zenodo.org/badge/342072813.svg)](https://zenodo.org/badge/latestdoi/342072813)

Run the script 'sh run_script.sh $brainID' get the results.

Code Repo for the paper :

[High precision automated detection of labeled nuclei in Gigapixel resolution image data of Mouse Brain](https://www.biorxiv.org/content/10.1101/252247v2.full)

Sukhendu Das, Jaikishan Jayakumar, Samik Banerjee, Janani Ramaswamy, Venu Vangala, Keerthi Ram, and Partha Mitra. 

BioRxiv (2019): 252247.

### Configurations

Store the input Brain images in JP2 format in a folder with the brainID.

If you have Brain Region Segmentation (as .mat files) store that in the folder $brainID/reg_high_seg_pad/

If you have Brain Region Segmentation in other format, read the segmenation appropiately so that it represents a single-channel image in line 28 of GFP_Cell_Detection/main_bam.m

If you donot have Brain Region Segmentation, comment out line 28 of GFP_Cell_Detection/main_bam.m and add a line to create a white single-channel image of the same size as your input image.
