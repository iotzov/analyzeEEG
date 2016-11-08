% This script takes in all of the files in the PROCESSED directory specified in settings_local
% and turns their fwd and bwd fields into a single volume that can have ISC run on it

settings_local

files = dir([PROCESSED_DATA_PATH '*.mat']);

allDataFwd = zeros(37040, 37, length(files));
allDataBwd = zeros(37040, 37, length(files));

for i = 1:length(files)

	load([PROCESSED_DATA_PATH files(i).name])
	allDataFwd(1:length(eegData.fwd),:,i) = eegData.fwd;
	allDataBwd(1:length(eegData.bwd),:,i) = eegData.bwd;
end

dataSetOrder = {files.name};
keep allDataBwd allDataFwd dataSetOrder
save('processedVolume')
