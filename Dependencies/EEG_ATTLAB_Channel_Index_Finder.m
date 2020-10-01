function channelIndex = EEG_ATTLAB_Channel_Index_Finder(EEG,theseChannelLabels)
%{
EEG_ATTLAB_Channel_Index_Finder
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.30.20
Date updated: 09.30.20
Purpose: find and output channel indices based on channel label inputs

Inputs
EEG: EEGLAB structure
theseChannelLabels: a cell array of channel labels e.g. {'Pz','Oz'}

Outputs
EEG: EEGLAB Structure

%}

cnt=0; channelIndex = [];
for i=1:length(theseChannelLabels)
    thisChan = theseChannelLabels{i};
    for j=1:length(EEG.chanlocs)
        if strcmp(EEG.chanlocs(j).labels,thisChan)
            cnt=cnt+1;
            channelIndex(cnt) = j;
        end
    end
end

if isempty(channelIndex)
    disp('No Channels Found')
    beep
else
    
end

return