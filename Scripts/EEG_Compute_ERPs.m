%{
EEG_Compute_ERPs
Author: Tom Bullock, UCSB Attention Lab
Date created: 10.27.20

Notes:

Trial data are in EEG.trialMat.  Important column headings are:
col3 = trial number
col4 = stimulus type (100 = go, 2 = go, 1 = no-go person, 3 = repeat)
col5 = response (0=no press, 16=press)
col6 = RT
col7 = image code

For previous ERP scripts (many useful notes on subject exceptions for RIT):
/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/Scripts_Old/fromProjects/Analysis_Scripts/EEG_Compile_ERPs_TargetLocked.m


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
sourceDirEEG = [rDir '/' 'EEG_Prepro3']; % final stage EEG preprocessed data
destDirectoryERPs = [rDir '/' 'Data_Compiled']; % compiled ERPs

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
        load([sourceDirEEG '/' sprintf('sj%02d_cd%02d_ri_prepro3.mat',sjNum,iCond)]);
        
        % get index of "eye"components from ICLabel
        badIC_idx  = find(EEG.etc.ic_classification.ICLabel.classifications(:,3) >= 0.7); % > 70% chance of occular artifact
        
        % reject bad "eye" components
        EEG = pop_subcomp(EEG, badIC_idx, 0,0);
        
        % extract trialMat from structure for ease of coding
        trialMat = EEG.trialMat;
        
        % loop through trials
        goCnt=0; nogoCnt=0; %create counters
        for iTrial=1:length(EEG.epoch)
            
            % parse trials depending on whether they are "go" or "nogo"
            if trialMat(iTrial,4)==100 || trialMat(iTrial,4)==2 % if "go" trial
                goCnt=goCnt+1;
                erp_go(:,:,goCnt) = EEG.data(:,:,iTrial);
            else % if "nogo" trial
                nogoCnt=nogoCnt+1;
                erp_nogo(:,:,nogoCnt) = EEG.data(:,:,iTrial);
            end
             
        end
        
        % average across trials to create ERPs
        ERP.erp_go(iSub,iCond,:,:) = mean(erp_go,3);
        ERP.erp_nogo(iSub,iCond,:,:) = mean(erp_nogo,3);
        
        clear erp_go erp_nogo

    end
    
end

%% quick plot ERPs (compare go and no-go trials)

% set scalp channels (electrodes) to plot
theseChannelLabels = {'POz','P3','P4'}; % parietal channels
channelIndex = EEG_ATTLAB_Channel_Index_Finder(EEG,theseChannelLabels);

% get actual times (s) from EEG mat
theseTimes = EEG.times;

% plot grand average ERPs (i.e. averaged over participants)
erp_go_avg = squeeze(mean(mean(ERP.erp_go(:,1,channelIndex,:),1),3));
erp_nogo_avg = squeeze(mean(mean(ERP.erp_nogo(:,1,channelIndex,:),1),3));

plot(theseTimes,erp_go_avg,...
    'LineWidth',3,...
    'Color','g'); hold on
plot(theseTimes,erp_nogo_avg,...
    'LineWidth',3,...
    'Color','r'); 
