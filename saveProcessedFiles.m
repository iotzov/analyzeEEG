% This script pulls raw files from the directory specified in settings_local.m
% The files are processed thru preprocessEEG.m, and saved under the specified save directory
% That is all.

% Get settings
settings_local

% Get list of unprocessed files
files = dir([RAW_DATA_PATH '*.mat'])

% Initialize stats file
stats = {};
stats{1,1} = 'Name';
stats{1,2} = 'Total Length';
stats{1,3} = 'Length Fwd';
stats{1,4} = 'Length Bwd';
stats{1,5} = 'Sampling Rate';
stats{2,1} = [];
stats{2,1} = {};

% Loop thru all files, processing and saving
for i = 1:length(files)

	load([RAW_DATA_PATH files(i).name])


	fs = eegData.srate; % Get sampling rate
	x = eegData.data(1:37, :)'; % Get all channels except for reference channels and transpose
	eegData.data = preprocessEEG(x, 33:37, [], fs);
	

	% Update stats
	stats{2,5} = [stats{2,5} fs]; 
	stats{2,1} = [stats{2,1} files(i).name]; % Save name to stats file
	e = [eegData.event.latency];
	fwdS = e(1);
	fwdE = e(2);
	bwdS = e(3);
	bwdE = e(4);
	stats{2,2} = [stats{2,2} length(eegData.data)];
	stats{2,3} = [stats{2,3} fwdE-fwdS];
	stats{2,4} = [stats{2,4} bwdE-bwdS];

	eegData.fwd = eegData.data(fwdS:fwdE, :);
	eegData.bwd = eegData.data(bwdS:bwdE, :);

	save([RAW_DATA_PATH files(i).name], 'eegData')

	disp(['Progress: ' num2str((i/length(files)) * 100) '%'])
end

keep stats
