dataDir = ''; % INCLUDE TRAILING '/'
saveDir = ''; % INCLUDE TRAILING '/'
scriptPath = ''; % Path to the various eeg processing scripts, also include '/'

addpath(genpath(scriptPath));

fsDesired = 512; % All files will be sampled down to this rate
getBadChannels = 1; % Set 1 to prompt for bad channel selection for each file, set to path of bad channel file to load that instead

if(ischar(getBadChannels)) % Check if getBadChannels is a string, if it is, load it and then set it to 0
  load(getBadChannels)
  getBadChannels=0;
end

files = dir([dataDir '*.mat']);

for i = 1:length(files)
  currentSubject = str2num(files(i).name(8:9)); % Get currentSubject in number form for easier comparison

  if(currentSubject==19) % Skip subject 19 because the file is corrupted somehow
    continue
  end

  load([dataDir files(i).name])

  eeg = struct();
  eeg.fs = h.

  if(getBadChannels)
                      % Do something to get the bad channels here
  end
end
