# EEG_Preprocessing

The goal of this repository is to provide a template EEG preprocessing pipeline and directory structure.

Author: Tom Bullock, UCSB Attention Lab

Date created: 09.30.20

Date updated: 09.30.20

## Directory Structure and Nomenclature 

I propose we set up directories like this:
```
EEG_Project
└── Dependencies
└── EEG_Prepro1
└── EEG_Raw
└── eeglab2019_1
└── Scripts
└── Trial_Data
```

### EEG_Project (root)

This is your project name (in my examples I use EEG_Exp_Template)

### Scripts

These are the scripts you will use to run the preprocessing

`EEG_Prepro1.m` Does the following:

* import into EEGLAB structure
* filter
* add channel locations
* re-reference
* remove noise (using clean_artifacts)
* visualize data (reality check)
* interpolate bad channels
* save in standard EEGLAB format (but in .mat files, not .set/.fdt)

`EEG_Merge_Recordings.m` Allow you to merge split recordings prior to preprocessing e.g. participant took a bathroom break halfway though the study and you had to stop the recording and disconnect the amp

### Dependencies

A library of subfunctions that support the higher level "Scripts" functions

`EEG_ATTLAB_Import_Data.m` Import data from raw Biosemi/Brain Products files

`EEG_ATTLAB_Apply_Reference.m` Re-reference the data (takes input from a cell array of channel labels)

`EEG_ATTLAB_Channel_Index_finder.m` Finds channel indices (takes input from a cell array of channel labels)

`EEG_ATTLAB_Visualize_Data.m` Visualizes data that has been cleaned using 'clean_artifacts' and allows easy comparison between new and old data

`EEG_ATTLAB_Merge_Broken_Files.m` Merge two recordings (e.g. participant takes a bathroom break and you have to unplug the cap)

### EEG_Raw

Raw EEG files (currently either Biosemi or Brain Vision format).  You can also place merged files here (saved in .mat format)

### Trial_Data

Trial information (typically in .mat format)

### eeglab2019_1

EEGLAB (my scripts are designed to work with this version).  The following plugins are required:

### EEG_Prepro1

Contains files preprocessed by `EEG_Prepro1.m`.

etc...






