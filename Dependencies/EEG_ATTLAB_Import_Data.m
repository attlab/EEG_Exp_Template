function EEG = EEG_ATTLAB_Import_Data(sourceDir,filename,dataFormat,chanlocsPathBESA)
%{
EEG_ATTLAB_Import_Data
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.28.20
Date updated: 09.28.20

Purpose: Import data from any of the following systems into EEGLAB
1) Biosemi ActiveTwo 
2) Brain Products ActiCHamp
3) Brain Products BrainAmp MR

Inputs
sourceDir: source directory
filename: filename of raw EEG data (no extension)
dataFormat: either "Biosemi_bdf", "Biosemi_edf", or "Brain_Vision" data
chanlocsPathBESA: path of chanlocs in the "BESA" folder in EEGLAB

Outputs
EEG: standard EEGLAB structure

Dependencies: EEGLAB toolbox with fileio and biosig plugins (I think)

%}

% selects correct file extension
if strcmp(dataFormat,'Biosemi_bdf')
    rawFileExt = '.bdf';
elseif strcmp(dataFormat,'Biosemi_edf')
    rawFileExt = '.edf';
elseif strcmp(dataFormat, 'Brain_Vision')
    rawFileExt = '.vhdr';
end

% import data into EEGLAB format
if strcmp(dataFormat,'Brain_Vision')
    EEG = pop_fileio([sourceDir '/'  filename rawFileExt]);
else
    EEG = pop_biosig([sourceDir '/'  filename rawFileExt]);
end

% add channel locations (may need to edit dir for different EEGLAB vers)
EEG=pop_chanedit(EEG, 'lookup',[chanlocsPathBESA '/standard-10-5-cap385.elp']); 
  

return