# EEG_Preprocessing

The goal of this repository is to provide a template EEG preprocessing pipeline and directory structure.

Author: Tom Bullock, UCSB Attention Lab

Date created: 09.30.20

Date updated: 10.08.20

## Example Data Files

Some example raw data files are available to download <b>[here](https://ucsb.box.com/s/c3gbxa11psgjfbgws1rkvitlb39h0hqk)</b> 

## Directory Structure and Nomenclature 

I propose we set up directories like this:
```
EEG_Project
└── Dependencies [sync w/GitHub]
└── Data_Compiled
└── EEG_Prepro1
└── EEG_Raw
└── eeglab2019_1 (or latest version of EEGLAB toolbox)
└── Plots [sync w/GitHub]
└── Scripts [sync w/GitHub]
└── Trial_Data
```
Important: Do not attempt to sync folders with large data files (>50 MB) with GitHub as this won't work.  Don't try to sync EEGLAB toolbox as it contains thousands of files and takes forever.

### EEG_Project (root)

This is your project (and github repository) name.  In my examples I use "EEG_Exp_Template"

### Scripts

These are the scripts you will use to run the preprocessing

`EEG_Prepro1.m` 

* import into EEGLAB structure
* filter
* add channel locations
* re-reference
* remove noise (using clean_artifacts)
* visualize data (reality check)
* interpolate bad channels
* save in standard EEGLAB format (but in .mat files, not .set/.fdt)

`EEG_Prepro2.m` 

* epoch EEG data
* sync trial data (recorded in MATLAT) with EEG data and make sure trials match up correctly

`EEG_Prepro3.m`

* apply ICA (AMICA)
* apply ICLabel

__this is where I'm up to on 10.08.20!__


`EEG_Merge_Recordings.m` Allow you to merge split recordings prior to preprocessing e.g. participant took a bathroom break halfway though the study and you had to stop the recording and disconnect the amp

### Dependencies

A library of subfunctions that support the higher level "Scripts" functions

`EEG_ATTLAB_Apply_Reference.m` Re-reference the data (takes input from a cell array of channel labels)

`EEG_ATTLAB_Channel_Index_finder.m` Finds channel indices (takes input from a cell array of channel labels)

`EEG_ATTLAB_ICA.m` Run ICA and ICLabel on data

`EEG_ATTLAB_Import_Data.m` Import data from raw Biosemi/Brain Products files

`EEG_ATTLAB_Merge_Partial_Recordings.m` Merge two recordings (e.g. participant takes a bathroom break and you have to unplug the cap)

`EEG_ATTLAB_Visualize_Data.m` Visualizes data that has been cleaned using 'clean_artifacts' and allows easy comparison between new and old data


### EEG_Raw

Raw EEG files (currently either Biosemi or Brain Vision format) go here.  You can also place merged files here (saved in .mat format)

### Trial_Data

Trial information (typically in .mat format) goes here

### eeglab2019_1

EEGLAB (my scripts are designed to work with this version).  The following plugins are required:

blah...