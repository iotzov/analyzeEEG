function [desiredIndices] = getDesiredIndices(inputData, healthy, run, quality, subject)
% 
% This function returns the indices out of the 92 available sessions of the ones matching the passed criteria
%
% function [desiredIndices] = getDesiredIndices(inputData, healthy, run, quality, subject)
%
% Input:
% 		inputData - 92 element struct array of data
% 		healthy   - (1 or 0) if subject is healthy/patient respectively
% 		run       - string matching the desired run #
% 		quality   - (0, 1, or 2) depending on quality of desired data
% 		subject   - string containing name of desired subject
% 		
% 		**** 		ANY EMPTY PARAMETERS WILL BE INTERPRETED AS WILDCARDS 		****
% Output:
% 		desiredIndices - vector of indices of data matching passed criteria


desiredIndices = [];

for i = 1:length(inputData)

	hCheck = healthy==inputData(i).healthy;
	rCheck = run==inputData(i).run;
	rCheck = rCheck(4);
	qCheck = quality==inputData(i).dataQuality;
	sCheck = contains(inputData(i).subj, subject);

	if(isempty(healthy))
		hCheck=1;
	end

	if(isempty(run))
		rCheck=1;
	end

	if(isempty(quality))
		qCheck=1;
	end

	if(isempty(subject))
		sCheck=1;
	end

	if(hCheck && rCheck && qCheck && sCheck)
		desiredIndices = [desiredIndices i];
	end
end

end
