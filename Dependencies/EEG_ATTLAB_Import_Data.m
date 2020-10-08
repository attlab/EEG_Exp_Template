function EEG = EEG_ATTLAB_Import_Data(sourceDir,filename)
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
EEG: standard EEGLAB structure with all event codes in number format for
consistency

Dependencies: EEGLAB toolbox with fileio and biosig plugins (I think)

%}


% try to import data into EEGLAB format
try
    if strcmp(filename(end),'r') % if brain vision format (vhdr)
        EEG = pop_fileio([sourceDir '/'  filename]);
    elseif strcmp(filename(end),'f') % if Biosemi format (bdf/edf)
        EEG = pop_biosig([sourceDir '/'  filename]);
    end
    disp(['Importing: ' filename])
catch % if data already imported into .mat format (e.g. if merged) then just load .mat file instead
    if strcmp(filename(end),'r')
        filename = [filename(1:end-5),'.mat'];
    else 
        filename = [filename(1:end-4),'.mat'];
    end
    load([sourceDir '/' filename]);
    disp(['Loading: ' filename])
end

% convert all event codes to numbers between 1-255 for consistency.
% Biosemi event codes import as numbers.  Brain Vision import as strings.
% If you merge biosemi files prior to import, they turn into strings...
for i=1:length(EEG.event)
    if strcmp(EEG.event(i).type(1),'S') % standard for Brain Products have codes like this e.g. "S120", "S  5" etc.
        EEG.event(i).type = str2double(EEG.event(i).type(2:4));
    else
        try
            EEG.event(i).type = str2double(EEG.event(i).type);
        catch
            disp(['Not converting event:' EEG.event(i).type])
        end
    end
end


return