# EEG_Preprocessing

The goal of this repository is to provide a template EEG preprocessing pipeline and directory structure.

Author: Tom Bullock, UCSB Attention Lab
Date created: 09.30.20
Date updated: 09.30.20

## Directory Structure and Nomenclature 

The "root" level directory is your project name (**EEG_Exp_Template** in this example)

**Scripts:** the code you will use to run preprocessing

**Dependencies:** library of useful subfunctions

**EEG_Raw:** raw EEG files (currently either Biosemi or Brain Vision format)

**EEG_Prepro1:** EEG files in standard EEGLAB format (but saved as .mat files) that have been through the following preprocessing stages

* import into EEGLAB structure
* filter
* add channel locations
* re-reference
* remove noise (using clean_artifacts)
* visualize data (reality check)
* interpolate bad channels
