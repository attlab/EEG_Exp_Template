function EEG = EEG_ATTLAB_Apply_Reference(EEG,thisRef)
%{
EEG_ATTLAB_Apply_Reference
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.30.20
Date updated: 09.30.20
Purpose: Re-references data using channel labels as inputs

Inputs
EEG: EEGLAB structure
thisRef: either [] (avg. ref) or a cell array of chans e.g. {'EXG1','EXG2'}

Outputs
EEG: EEGLAB Structure

%}

if isempty(thisRef)
    disp('Using Average Reference')
else
    channelIndex = EEG_ATTLAB_Channel_Index_Finder(EEG,thisRef);
    if length(thisRef)==length(channelIndex)
        disp('Using selected channels as reference')
    else
        disp('Selected Reference Channels Not Available!  ABORT!')
        return
    end
end
EEG = pop_reref( EEG, thisRef,'keepref','on');

return