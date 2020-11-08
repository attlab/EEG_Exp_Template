% TASK:

% Your job is to create a script that will load each ICA preprocessed EEG
% dataset, generate IC Plots for all components, then save those plots as
% image files in a new folder.

% PSEUDO CODE:

% set up directories, paths etc

% create a list of filenames in your ICA preprocessed directory (use "dir"
% function)

% start looping through filenames

% load EEG data for each filename

% set EEGLAB Path (if not already set)
eeglabDir = '/Users/tombullock/Documents/MATLAB/eeglab2019_1';
if ~exist('eeglab.m')
    cd(eeglabDir);eeglab;clear;close all;cd ..
    eeglabDir = '/Users/tombullock/Documents/MATLAB/eeglab2019_1';
else
    eeglabDir = '/Users/tombullock/Documents/MATLAB/eeglab2019_1';
end

% set directories
rDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template';
sourceDir = [rDir '/' 'EEG_Prepro3'];  
destDir = [rDir '/' 'Plots']; 

% add dependencies to path
addpath(genpath([rDir '/' 'Dependencies']))

% change dir to source dir (files ready to be run through ICA), get list of
% files, then change dir back
cd(sourceDir)
d=dir('*.mat');
cd ..

% subjects for processing
subjects = 1:3;

% save IC plots using this code (you'll need to modify lines 22,23,35 to
% work with your filename)
for i=1:2
    iSub=1:length(subjects)
    sjNum = subjects(iSub);
    
    if i==1; mapID=2;
    elseif i==2; mapID=1;
    end
    
    filename = 'sj2_b01.mat';
    
    sjNum=filename(3); % pull out the subject number from the filename
    seNum=filename(6:7); % pull out the session number from the filename
    
    h=gcf; % gets the current figure
    
    % generate IC plots (this should bring up two figures)
    pop_viewprops(EEG,0,1:size(EEG.icaweights,1),'freqrange',[2,50])
    
    saveas(h,[destDir '/' sprintf('sj%s_se%s_map%d_iclabels.jpg',sjNum,seNum,mapID)],'jpeg')
    
    close
    
end

close all

% end loop, load next filename