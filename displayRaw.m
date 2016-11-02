files = dir('dataMatFiles/*.mat');

for i=1:length(files)
    load(['dataMatFiles/' files(i).name]);
    fs = eegData.srate;
    x = eegData.data(1:37,:)';
    xclean = preprocess(x,33:37,{[]},fs);
    imagesc(xclean'); caxis([-100 100]);
    title(files(i).name);
    pause
end
