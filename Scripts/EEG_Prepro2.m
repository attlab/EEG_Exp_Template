%{
EEG_Prepro_2
Author: Tom Bullock, UCSB Attention Lab
Date created: 10.06.20
Date updated: 10.06.20

Purpose: Epoch EEG data and match with experiment trial data stored in
MATLAB.

Instructions:

Notes:

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
sourceDirEEG = [rDir '/' 'EEG_Prepro1']; % cleaned EEG data
sourceDirTrial = [rDir '/' 'Trial_Data']; % trial data 
destDir = [rDir '/' 'EEG_Prepro2']; % epoched, ICA?

% add dependencies to path
addpath(genpath([rDir '/' 'Dependencies']))

% subjects for processing
subjects = 1:3;

%% subject loop
for iSub=1:length(subjects)
    sjNum = subjects(iSub);
    
    % condition loop
    for iCond=1%:2
        
        % load EEG data 
        load([sourceDirEEG '/' sprintf('sj%02d_cd%02d_ri_prepro1.mat',sjNum,iCond)]);
        
        % load trial data
        load([sourceDirTrial '/' sprintf('sj%02d_cd%02d_ri.mat',sjNum,iCond)])   
        
        % check the EEG event codes match/align with the trial data codes
        % (***this example is particularly complex - move this to a subfunction?***)
        EEG_tmp = pop_epoch(EEG,{11,12,13,110},[0,.1]);
        
        for iCode=1:length(EEG_tmp.epoch)
            for iCell=1:length(EEG_tmp.epoch(iCode).eventtype)
                if ismember(EEG_tmp.epoch(iCode).eventtype{iCell},[11,12,13,110])
                    eventCodeTable(iCode,1) = [EEG_tmp.epoch(iCode).eventtype{iCell}];
                end
            end
            eventCodeTable(iCode,2) = trialMat(iCode,4);
        end
        
        for iCode=1:length(eventCodeTable)
            if      eventCodeTable(iCode,1)==110 && eventCodeTable(iCode,2)==100
                eventCodeTable(iCode,3) = 1;
            elseif  eventCodeTable(iCode,1)==11  && eventCodeTable(iCode,2)==1
                eventCodeTable(iCode,3) = 1;
            elseif  eventCodeTable(iCode,1)==12  && eventCodeTable(iCode,2)==2
                eventCodeTable(iCode,3) = 1;
            elseif  eventCodeTable(iCode,1)==13 && eventCodeTable(iCode,2) ==3
                eventCodeTable(iCode,3) = 1;
            else
                eventCodeTable(iCode,3) = 0;
            end
        end
        
        if sum(eventCodeTable(:,3)) == length(eventCodeTable)
            disp('EEG and Trial Data Event Codes Matched Successfully!')
        else
            disp('EEG and Trial Data Mismatch - check eventCodeTable!')
            return
        end
        
        % epoch data around each trial (make sure to include all trials so
        % that the entire EEG dataset syncs with the behavior)
        EEG = pop_epoch(EEG,{11,12,13,110},[-.2, 1]);
        EEG = pop_rmbase(EEG,[-200 -100]);
        
        % add trialMat to EEG structure
        EEG.trialMat = trialMat;
        
        % save data
        save([destDir '/' sprintf('sj%02d_cd%02d_ri_prepro2.mat',sjNum,iCond)],'EEG','bad_channel_list')
        
        clear bad_channel_list EEG EEG_tmp eventCodeTable trialMat
    
    end
    
end