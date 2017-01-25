function displayEEG(eegData, fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function displays raw EEG data with the minimum amount of processing required for viewing
% 	The only processing performed is high-pass filtering and offset removal in order to facilitate viewing
%
%
% Input:
% 	eegData - MxN array of M samples by N electrodes
% 	fs - sampling rate in Hz
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imagesc(eegData'); caxis([-100 100]);
