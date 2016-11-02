function [processed] = filterEEG(eegData)
% Returns pre-processed EEG data after being passed the raw EEG struct file

fs = eegData.srate;

eegData = pop_eegfiltnew(eegData, 0.5, 0);
eegData = pop_eegfiltnew(eegData, 59, 61, 826, 1, [], 1);
processed=eegData.data;
