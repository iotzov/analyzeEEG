% Converts files from .set format into .mat format for loading into other scripts
% -
% -
% -

settings

files = dir([global_path '*.set'])

saveLoc = input('Enter full path of save location (folder): ')

for x = 1:length(files)

