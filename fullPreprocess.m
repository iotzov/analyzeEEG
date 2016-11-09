settings_local 

savedir = '/home/ivan/Documents/Research Docs /minConsciousEEG/dataMatFiles/';
'/home/ivan/Documents/Research Docs /minConsciousEEG/eegLab-sets/'
scriptdir = '/home/ivan/Documents/Research Docs /eegMinCon-analyze';

files = dir(['/home/ivan/Documents/Research Docs /minConsciousEEG/eegLab-sets/' '*.set']);

for i = 1:length(files)

	temp = pop_loadset(['/home/ivan/Documents/Research Docs /minConsciousEEG/eegLab-sets/' files(i).name]);
	EEG = temp.data';
%	EEG = preprocessEEG(EEG, [38 39], [], 250);
	save([savedir files(i).name(1:end-4)], 'EEG')
	disp(['file ' num2str(i) ' done'])
end
clear

settings_local
saveProcessedFiles
volumize
