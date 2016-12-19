load /home/ivan/Documents/'Research Docs '/minConsciousEEG/processedDataWithInfo.mat

l = length(eeg); lf = 37038; lb = 37040; lt = lf+lb; % define lengths of fwd and bwd segments & total length
f = matfile('/home/ivan/Documents/Research Docs /minConsciousEEG/regressY.mat');

healthy = find([dataInfo.healthy]==1); patient = find([dataInfo.healthy]==0);

Y = []; X = []; Wf = []; Wb = [];

for i = 2:3

	X = repmat(eeg(i).fwd, [l-1 1]);
	Y = f.Y;
	Y(lt*(i-1)+1:lt*i, :) = [];
	Wf = X\Y;
end
