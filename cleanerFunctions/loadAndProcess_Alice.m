dataDir = '';
dataFormat = '.set';
eogchannels = 38:39;
stimNames = {'Forward' 'Backward'};
stimLengths = [37037 37039];
numStims = length(stimLengths);
% if value below is 1, user will be prompted to manually select bad channels for each run
% if value is 0, bad channel data will be assumed to be located in dataDir/badChannels.mat

files = dir([dataDir '*' dataFormat]);

for i = 1:length(files)

  runs(i) = Run(pop_loadset(files(i).name));
  runs(i).eogchannels = eogchannels;
  runs(i).stimNames = stimNames;
  runs(i).stimLengths = stimLengths;

end

save([dataDir 'aliceRuns'], 'runs', '-v7.3')

ISCdata = {};
refSubjects = {};
fs = runs(1).fs;

for i = 1:numStims
  for j = 1:length(runs)
    ISCdata{i} = cat(3, ISCdata{i}, runs(j).extract(i))
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
