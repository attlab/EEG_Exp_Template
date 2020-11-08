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

% generate IC plots (this should bring up two figures)
pop_viewprops(EEG,0,1:size(EEG.icaweights,1),'freqrange',[2,50])

% save IC plots using this code (you'll need to modify lines 22,23,35 to
% work with your filename)
for i=1:2
    
    if i==1; mapID=2;
    elseif i==2; mapID=1;
    end
    
    h=gcf; % gets the current figure
    
    sjNum=filename(3:5); % pull out the subject number from the filename
    seNum=filename(9:10); % pull out the session number from the filename
    
    saveas(h,[plotDestDir '/' sprintf('sj%s_se%s_map%d_iclabels.jpg',sjNum,seNum,mapID)],'jpeg')
    
    close
    
end

close all

% end loop, load next filename