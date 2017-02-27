dataDir = '/home/ivan/Documents/ResearchDocs/minConsciousEEG/Alice_Set_Files/';
dataFormat = '.set';
eogchannels = 38:39;
stimNames = {'Forward' 'Backward'};
stimLengths = [37037 37039];
numStims = length(stimLengths);
% if value below is 1, user will be prompted to manually select bad channels for each run
% if value is 0, bad channel data will be assumed to be located in dataDir/badChannels.mat
pickBadChannels = 0;

files = dir([dataDir '*' dataFormat]);

if(pickBadChannels)
  for i = 1:length(files)

    runs(i) = Run(pop_loadset([dataDir files(i).name]));
    runs(i).eogchannels = eogchannels;
    runs(i).stimNames = stimNames;
    runs(i).stimLengths = stimLengths;
    runs(i).stimStart(1) = runs(i).event(1).latency;
    runs(i).stimStart(2) = runs(i).event(3).latency;
    runs(i) = runs(i).getBadChannels();
    runs(i) = runs(i).preprocess();

  end
else
  load([dataDir 'badChannels.mat'])
  for i = 1:length(files)
    runs(i) = Run(pop_loadset([dataDir files(i).name]));
    runs(i).eogchannels = eogchannels;
    runs(i).stimNames = stimNames;
    runs(i).stimLengths = stimLengths;
    runs(i).data = double(runs(i).data);
    runs(i).stimStart(1) = runs(i).event(1).latency;
    runs(i).stimStart(2) = runs(i).event(3).latency;
    runs(i).badChannels = badChannels{i};
    runs(i).dataQuality = dataQuality{i};
    runs(i) = runs(i).preprocess();
  end
end

save([dataDir 'aliceRuns'], 'runs', '-v7.3')

ISCdata = {};
refSubjects = {};
fs = runs(1).fs;

for i = 1:numStims
  ISCdata{i} = [];
  for j = 1:length(runs)
    ISCdata{i} = cat(3, ISCdata{i}, runs(j).extract(i));
  end
  refSubjects{i} = find([runs.subject]<300);
end

[isc persub w a] = multiStimISC(ISCdata, refSubjects, fs);

for j = 1:length(runs)
  for i = 1:numStims
    runs(j).ISC{i} = persub{i}(:,j);
  end
end

s = [runs.subject];
sunique = unique(s);

for i = 1:length(sunique)

  subjects(i) = Subject();
  subjects(i) = subjects(i).setID(sunique(i));
  current = runs([runs.subject]==sunique(i));

  for j = 1:length(current)
    subjects(i) = subjects(i).addRun(current(j));
  end

end

save([dataDir 'aliceSubjects_Processed'], 'subjects', '-v7.3')

newMakeChart(subjects)
