function EEG_ATTLAB_ICA(sourceDir,icaDir,thisFilename)
%{
EEG_ATTLAB_ICA
Author: Tom Bullock, UCSB Attention Lab (borrowed some code from Neil Dundon)
Date created: 10.08.20
Date updated: 10.08.20

Purpose: Run AMICA and apply IC Label

Inputs:
sourceDir - wherever EEG_Prepro2 lives (cleaned, epoched data)
icaDir - output for ICA data
thisFilename - data filename e.g. 'sj01_cd01_ri_prepro2.mat'

%}

% set EEGLAB Path (if not already set)
eeglabDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/eeglab2019_1';
if ~exist('eeglab.m')
    cd(eeglabDir);eeglab;clear;close all;cd ..
else
    eeglabDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/eeglab2019_1';
end

% load data
load([sourceDir '/' thisFilename])

% use double precision for ICA 
EEG.data = double(EEG.data); 

% get data rank
if ndims(EEG.data)==3
    dataRank = sum(EEG.etc.clean_channel_mask); % get data rank
else
   disp('NOT EPOCHED DATA - CHECK DATA RANK CALC!')
   return
end

% attempt to run AMICA on data and apply ICLabel (display error if not
% working).  Note this can take a while!
try
    
    % run AMICA
    runamica15(EEG.data, ...
        'num_chans', EEG.nbchan,...
        'outdir', [icaDir '/' thisFilename],...
        'pcakeep', dataRank, 'num_models', 1,...
        'do_reject', 1, 'numrej', 15, 'rejsig', 3, 'rejint',1);
    
    EEG.etc.amica  = loadmodout15([icaDir '/' thisFilename]); % loads AMICA output from outdir
    EEG.etc.amica.S = EEG.etc.amica.S(1:EEG.etc.amica.num_pcs, :);
    EEG.icaweights = EEG.etc.amica.W;
    EEG.icasphere  = EEG.etc.amica.S;
    EEG = eeg_checkset(EEG, 'ica');
    
    % apply IC Label
    EEG = iclabel(EEG);
    
    % add operations to EEG log
    EEG.preproSettings.ICA = 'yes';
    EEG.preproSettings.ICLabel = 'yes';

    % save data
    save([icaDir '/' thisFilename(1:end-5) '3.mat'],'EEG','-v7.3')
     
catch e
    header = ['Error running ICA PREPROCESSING for ' filename];
    message = sprintf('The identifier was:\n%s.\nThe message was:\n%s', e.identifier, e.message);
    error(message)
end

return