function [eegVol] = structToVolume(inputStruct, desired, direction)
%
% This function returns a volume of (samples * channels * subjects) from inputStruct
%
% Input:   inputStruct - The struct used to house the EEG data
%          desired - vector of desired EEG data out of 92 available
% 				 direction - (1 or 0), 1 for fwd, 0 for bwd

	eegVol = [];

if(direction)
	for i = desired

		eegVol = cat(3, eegVol, inputStruct(i).fwd);

	end
else
	for i = desired

		eegVol = cat(3, eegVol, inputStruct(i).bwd);

	end
end

	eegVol = double(eegVol);

end
