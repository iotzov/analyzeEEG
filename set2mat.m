% Converts files from .set format into .mat format for loading into other scripts
% -
% -
% -

scriptSettings

files = dir([inputFilePath '*.set'])

saveLoc = input('Enter full path of save location (folder with trailing "/"): ', 's')

cd(inputFilePath)

for x = 1:length(files)

	eegData = pop_loadset(files(x).name, '.')
	save([saveLoc files(x).name(1:end-4)], 'eegData')
	clear eegData
end

disp('done')
