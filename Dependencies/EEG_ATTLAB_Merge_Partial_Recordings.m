function EEG_ATTLAB_Merge_Partial_Recordings(brokenDataPath,mergedFilename,varargin)
%{
EEG_ATTLAB_Merge_Broken_Files
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.30.20
Date updated: 09.30.20

Purpose: merge files from an interrupted recording

Inputs: fill in...

%}

% % if no inputs, prompt
% if nargin==0
%     brokenDataPath = input('Enter full path to broken files: ');
%     mergedFilename = input('Enter desired merged filename with .mat extension: ')
%     varargin{1}{1} = input
% end

for i=1:length(varargin{1})
    disp(['Merging File ' num2str(i)])
    if i==1 % load first EEG file
        if strcmp(varargin{1}{i}(end),'r') % if brain vision files (.vhdr)
            EEGO = pop_fileio([brokenDataPath '/' varargin{1}{i}]);
        else % if biosemi files (bdf)
            EEGO = pop_biosig([brokenDataPath '/' varargin{1}{i}]);
        end
    else % load subsequent EEG file(s) and merge
        if strcmp(varargin{1}{i}(end),'r') % if brain vision files (.vhdr)
            EEG = pop_fileio([brokenDataPath '/' varargin{1}{i}]);
        else % if biosemi files (bdf)
            EEG = pop_biosig([brokenDataPath '/' varargin{1}{i}]);
        end
        EEGO = pop_mergeset(EEGO,EEG);
    end
end

EEG = EEGO;

% save merged data file as .mat
save([brokenDataPath '/' mergedFilename],'EEG')

return