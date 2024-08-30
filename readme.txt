LFPdataFor folder contains five monkey data, first three letters of each folder refer to monkey's name.
Three monkeys have both (spatial and feature) task and two monkey have spatial task only in this dataset.
Further this dataset divided in two pre-training and post-training folder.
All data folder contains .mat files, each corresponding to one LFP site (labeled, based on the channel number).
Each LFP filename is structured as: adr001_1_CH1_S6 
-first three letters refer to the monkey, e.g. ADR
-next one digit number '_1_' or '_2_' references the sequential stimulus set used (spatial or feature task); some sessions '_3_' or '_4_' also represents the spatial and feature task.
-CH1...CH12' represents the lfp sites (Electrode).
-Last two characters refer to correct (State code 7) or error trials (State code 6). Error trials are inlcuded only in post-training sessions.

Trials in .mat file are organized in “classes”, based on the identity of the cue (first stimulus). For example, there are nine possible locations of stimuli in the spatial set that appear as cues.

The .mat file also consists of fields named with 'Cue_onT', 'Sample_onT', 'Target_onT', 'Class', Trial_Num', 'Rewarded’, etc. 
Cue_onT will be the time (s) of the cue onset, the same for Sample_onT, Reward_onT and Target_onT. 
The SyncLFP field contains the LFP data in a single trial, aligned with Cue_onT. 
The LFP data starts with first 500 samples (1 sec) as baseline (taken from 1.2-.2 sec of end of the trials (intra-trial period). 
Next 500 samples (1sec) as fixation period and then starts with cue onset (.5 sec), delay1 (1.5 sec), sample (.5sec), delay2 (1.5 sec) and reward (1 sec). 
This way each trial consists of 3500 samples (7sec).










