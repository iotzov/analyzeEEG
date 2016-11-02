% Run settings script to set up environment variables
settings_local

% Get all mat files in raw data directory
files = dir([RAW_DATA_PATH '*.mat']);

% Loop through all files, preprocessing and displaying
for i=1:length(files)
    load([RAW_DATA_PATH files(i).name]);
    fs = eegData.srate;
    x = eegData.data(1:37,:)';
    xclean = preprocessEEG(x,33:37,[],fs);
    imagesc(xclean'); caxis([-100 100]);
    title(files(i).name);
    pause
end
