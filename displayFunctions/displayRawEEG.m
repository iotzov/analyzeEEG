function displayRawEEG(eegData, fs)
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

[b,a,k]=butter(5,0.5/fs*2,'high'); sos = zp2sos(b,a,k);

[T,D]=size(eegData);

eegData = eegData-repmat(eegData(1,:),T,1);  % remove starting offset to avoid filter transient

eegData = sosfilt(sos,eegData);

imagesc(eegData'); caxis([-100 100]);
