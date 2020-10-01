# EEG_Preprocessing

The goal of this repository is to provide a template EEG preprocessing pipeline and directory structure.

Author: Tom Bullock, UCSB Attention Lab

Date created: 09.30.20

Date updated: 09.30.20

## Directory Structure and Nomenclature 

The "root" level directory is your project name (**EEG_Exp_Template** in this example)

**Scripts:** the code you will use to run preprocessing

`EEG_Prepro1.m` Does the following:

* import into EEGLAB structure
* filter
* add channel locations
* re-reference
* remove noise (using clean_artifacts)
* visualize data (reality check)
* interpolate bad channels
* save in standard EEGLAB format (but in .mat files, not .set/.fdt)

**Dependencies:** library of useful subfunctions

`EEG_ATTLAB_Import_Data.m` Import data from raw Biosemi/Brain Products files

`EEG_ATTLAB_Apply_Reference.m` Re-reference the data (takes input from a cell array of channel labels)

`EEG_ATTLAB_Channel_Index_finder.m` Finds channel indices (takes input from a cell array of channel labels)

`EEG_ATTLAB_Visualize_Data.m` Visualizes data that has been cleaned using 'clean_artifacts' and allows easy comparison between new and old data

`EEG_ATTLAB_Merge_Broken_Files.m` Merge two recordings (e.g. participant takes a bathroom break and you have to unplug the cap)


**EEG_Raw:** raw EEG files (currently either Biosemi or Brain Vision format)

**Trial_Data:** trial data (in .mat format) 

**EEG_Prepro1:** save files at prepro1 stage


Example folder structure

```
app
└── screens
    └── App
        └── screens
            ├── Admin
            │   └── screens
            │       ├── Reports
            │       └── Users
            └── Course
                └── screens
                    └── Assignments
```