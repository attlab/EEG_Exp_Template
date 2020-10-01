%{
EEG_Merge_Recordings
Author: Tom Bullock
Date created: 09.30.20
Date updated: 09.30.20

Purpose: example script for merging broken/interrupted recordings

Inputs: 
brokenFilePath
mergedFileName: your chosen filename (must have .mat extension)
varargin: a cell array of partial recordings, number is flexible e.g.
{'sj01_cond1_part1.vhdr','sj01_cond1_part2.vhdr',...}.  You must provide
full filename including extension.  The script can merge either Biosemi
files (.bdf) or Brain Vision (.vhdr') files.

Outputs: will merge partial recording files in the order provded in the cell array
 and output a '.mat' file to the same directory as the partial recordings

Dependencies: 
EEGLAB toolbox
EEG_ATTLAB_Merge_Partial_Recordings

%}

% add dependencies to path
addpath(genpath('/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/Dependencies'))

% add eeglab to path
eeglabDir = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/eeglab2019_1'; % set eeglab path
cd(eeglabDir); eeglab; clear; close all;

% your inputs
brokenDataPath = '/Users/tombullock/Documents/Psychology/ATTLAB_Repos/EEG_Exp_Template/EEG_Raw'; % what directory are the to-be-merged files in?
mergedFilename = 'sj01_cond01_RIT.mat'; % what is the desired output filename? (must end in .mat)
varargin = {'sj01_Cond01_RIT.vhdr','sj01_Cond02_RIT.vhdr'}; % as many files as you want to merge, must be in order, in cell array w/full extension

% run merge script
EEG_ATTLAB_Merge_Partial_Recordings(brokenDataPath,mergedFilename,varargin)