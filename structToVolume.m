function [eegVol] = structToVolume(inputStruct, desired)
% 
% This function returns a volume of (samples * channels * subjects) from inputStruct
% 
% Input:   inputStruct - The struct used to house the EEG data
%          desired - vector of desired EEG data out of 92 available

	eegVol = inputStruct(desired(1)).fwd;

	for i = 2:length(desired)

		eegVol = cat(3, eegVol, inputStruct(i).fwd);
	end

end
