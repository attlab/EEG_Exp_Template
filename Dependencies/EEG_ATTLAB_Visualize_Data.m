function dataCheck = EEG_ATTLAB_Visualize_Data(EEG,originalEEG) 
%{
EEG_ATTLAB_Visualize_Data
Author: Tom Bullock, UCSB Attention Lab
Date created: 09.30.20
Date updated: 09.30.20
Purpose: after running clean_artifacts, run this to display and contrast
the new "clean" dataset with the old dataset.  The script launches
vis_artifacts (see EEGLAB function help for more info) then waits for a
"Y"(Yes I've seen the data and I'm happy with it) to proceed onwards with
the script or "N" (No, I've seen the data and something's wrong) to quit.

Inputs
EEG: EEGLAB structure
thisRef: either [] (avg. ref) or a cell array of chans e.g. {'EXG1','EXG2'}

Outputs
EEG: EEGLAB Structure

%}
            
close all
disp('Visualizing clean/original channel data')
vis_artifacts(EEG,originalEEG);
fig=figure(gcf);
disp('To continue, press "Y", To quit, press "Q"')
pressLoop=1;
while pressLoop
    was_a_key = waitforbuttonpress;
    if was_a_key && strcmp(get(fig, 'CurrentKey'), 'y')
        pressLoop=0;
        disp('DATA GOOD! CONTINUE!')
        dataCheck=1; % data check = good (1)
        close all
    elseif was_a_key && strcmp(get(fig, 'CurrentKey'), 'q')
        pressLoop=0;
        disp('DATA BAD! EXITING SCRIPT!')
        dataCheck=0; % data check = not good (0)
        return
    end
end

return