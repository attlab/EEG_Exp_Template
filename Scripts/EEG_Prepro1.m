%{
EEG_Prepro_1
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.28.20
Date updated: 10.06.20

Purpose:
Import data
Apply filters
Clean artifacts
Re-reference

Instructions: 
Create directories and set directory paths in script
Edit filename to match the filename of your raw files

Notes:
Biosemi records to a single bdf file.  If you have issues with event codes
not registering, use the Biosemi converter application to convert bdf>edf
and then import the edf here instead.  Sometimes this allows you recover
the scrambled event codes.  Not sure why!

Brain Vision systems record to three separate files with the same name but
different extensions.  ".eeg" is where the raw samples are stored.  ".vhdr"
contains header info.  ".vmrk" contains markers (event codes).  You need
all these files in the same directory to successfully import data.  Note
that if you rename the raw files for any reason, you need to 1) ensure all
three files (eeg,vhdr,vmrk) have the same names, and then you need to load
the vhdr and vmrk files (double click and they'll open in matlab editor)
and edit the file paths contained within both files.

To Dos:
Make all event codes numerical after import (easier to work with if all
consistent)

%}

clear
close all

% set EEGLAB Path (if not already set)
eeglabDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/eeglab2019_1';
if ~exist('eeglab.m')
    cd(eeglabDir);eeglab;clear;close all;cd ..
else
    eeglabDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/eeglab2019_1';
end

% set directories
rDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template';
sourceDir = [rDir '/' 'EEG_Raw']; % raw data 
destDir = [rDir '/' 'EEG_Prepro1']; % filtered, downsampled, clean (artifacts rejected) data

% add dependencies to path
addpath(genpath([rDir '/' 'Dependencies']))

% set path to channel locations in EEGLAB (varies betweeb versions)
chanlocsPathBESA = [eeglabDir '/plugins/dipfit/standard_BESA']; % standard
chanlocsPathBEM = [eeglabDir '/plugs/difit/standard_BEM']; % for dipole fitting 

% subjects for processing
subjects = 1:3;

% visualize data after cleaning? ('yes' or 'no')
visualizeData='no';

%% preprocessing settings
s.thisLowPass = 100; % low-pass filter setting (100 Hz is typical, enter [] to turn off)
s.thisHighPass = []; % high-pass filter setting (.1 normally works well, enter [] to turn off)
s.thisNewSampleRate = 250; % downsample data if required (new SR MUST be a factor of original SR e.g. 1024 Hz >256 Hz)

% preprocessing settings for clean_artifacts function
s.cleanArtifacts.channelCriterion = .85; % channel correlation (default: .85)
s.cleanArtifacts.LineNoiseCriterion = 4; % line noise (default: 4)
s.cleanArtifacts.BurstCriterion = 'off'; % noise burst removal (ASR) - only really needed for noisy (e.g. active) recordings - use with caution
s.cleanArtifacts.FlatLineCriterion = 5; % max tolerated channel flatline (in secs)
s.cleanArtifacts.WindowCriterion = 'off'; % relevant to ASR - if turned on will remove unrepaired time windows 
s.WindowCriterionTolerances = 'off'; % see above (I turn this off)

% reference settings
s.thisRef = []; % if using average reference, enter [], otherwise enter a cell array of channel names e.g. {'EXG1','EXG2'} for Biosemi


%% subject loop
for iSub=1:length(subjects)
    sjNum = subjects(iSub);
    
    % condition loop
    for iCond=1%:2
        
        % set filename.  Provide a .vhdr/.bdf/.edf extension.  Note, if you
        % have already imported the file into .mat (e.g. if you merged a
        % broken recording) then the script will ignore the extension and
        % just load the data AS LONG AS the filename format is consistent
        % with other files
        filename = sprintf('sj%02d_cd%02d_ri.vhdr',sjNum,iCond);
        %disp(['Processing ' filename])

        % import raw data into EEGLAB format (or load, if already imported
        % e.g. in the case of merged file)
        EEG = EEG_ATTLAB_Import_Data(sourceDir,filename);
        
        % add channel locations (may need to edit dir for different EEGLAB vers)
        EEG=pop_chanedit(EEG, 'lookup',[chanlocsPathBESA '/standard-10-5-cap385.elp']); 
        
        % apply initial bandpass filter 
        EEG = pop_eegfiltnew(EEG,s.thisHighPass,s.thisLowPass); 
        
        % downsample data if required (make sure the new sampling rate is a
        % factor of the old sampling rate e.g. if you recorded at 1000 Hz
        % as is typical for Brain Vision systems, downsample to 250 hz; if
        % you recorded at 1024 Hz as is typical for Biosemi systems,
        % downsample to 256 Hz)
        EEG.originalSampleRate = EEG.srate;
        EEG = pop_resample(EEG,s.thisNewSampleRate);
        if rem(EEG.originalSampleRate,EEG.srate) % checks for acceptable SR and aborts if new SR not a factor of old SR
            disp('Error - new sample rate not a factor of original sample rate! Abort!')
            return
        end
            
        % save original channel locations then remove any extraneous
        % channels if needed (see chanlocs struct e.g. EKG, Actigraphy)
        originalEEG = EEG;
        EEG = pop_select(EEG,'nochannel',{'EKG','ACCX'}); % just examples
        EEG.originalChanlocs = EEG.chanlocs; 

        % clean noisy data (all in one function for artifact removal -
        % options are extensively documented in >> help clean_artifacts - )
        EEG = clean_artifacts(EEG,... 
            'channelCriterion',s.cleanArtifacts.channelCriterion,... 
            'LineNoiseCriterion',s.cleanArtifacts.LineNoiseCriterion,... 
            'BurstCriterion',s.cleanArtifacts.BurstCriterion,... 
            'FlatLineCriterion',s.cleanArtifacts.FlatLineCriterion,... 
            'WindowCriterion',s.cleanArtifacts.WindowCriterion,... 
            'WindowCriterionTolerances',s.WindowCriterionTolerances); 
        
        % re-reference the data.  If you plan to run ICA, compute the
        % average reference (i.e. thisRef = []), if not, enter the 
        % electrode(s) you want to use in a cell array (e.g. for Biosemi 
        % Mastoids: thisRef = {'EXG1','EXG2'};)  If these electrodes no
        % longer exist, that means they've been rejected during the 
        % previous stage, so you need to reconsider)        
        EEG = EEG_ATTLAB_Apply_Reference(EEG,s.thisRef);
        
        % visualize the original vs. cheaned data (good to do reality check)
        % key shortcuts (must click on fig2 for these to work):
        % y = confirm data and continue, q = quit script
        % n = new data, o = old data, b = both data, d = difference,
        % + = increase amp, - = decrease amp, *=shrink time scale, 
        % ? = expand time scale, h = show/hide slider
        if strcmp(visualizeData,'yes')
            dataCheck = EEG_ATTLAB_Visualize_Data(EEG,originalEEG);
            if dataCheck==0; return; end
        end
        
        % create list of bad channels and interpolate bad channels
        bad_channels = setdiff({EEG.originalChanlocs.labels},{EEG.chanlocs.labels});
        bad_channel_list = {};
        bad_channel_list = unique(cat(2,bad_channel_list,bad_channels));
        EEG = pop_interp(EEG,EEG.originalChanlocs, 'spherical');
        EEG.badChannelList = bad_channel_list;
        
        % save a record of preprocessing settings in the EEG structure
        EEG.preproSettings = s;
        
        % save cleaned data
        save([destDir '/' sprintf('sj%02d_cd%02d_ri_prepro1.mat',sjNum,iCond)],'EEG','bad_channel_list')
        
    end
    
end
