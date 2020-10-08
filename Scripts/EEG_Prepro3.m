%{
EEG_Prepro3
Author: Tom Bullock
Date created: 10.07.20
Date updated: 10.07.20

Purpose: Run ICA (AMICA) and apply IC Label

Notes: this will typically be run in parallel on cluster, so just grab all
prepro2 files in that directory and run through AMICA

TO DO:
Make it so that the ICA script ran run in parallel for cluster use

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
sourceDir = [rDir '/' 'EEG_Prepro2'];  
destDir = [rDir '/' 'EEG_Prepro3']; 

% add dependencies to path
addpath(genpath([rDir '/' 'Dependencies']))

% change dir to source dir (files ready to be run through ICA), get list of
% files, then change dir back
cd(sourceDir)
d=dir('*.mat');
cd ..

% loop through files and run ICA
for i=1:length(d)
    thisFilename = d(i).name;
    EEG_ATTLAB_ICA(sourceDir,destDir,thisFilename)    
end