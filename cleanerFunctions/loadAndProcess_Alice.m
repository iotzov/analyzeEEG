dataDir = '';
dataFormat = '.set';
eogchannels = 38:39;
stimNames = {'Forward' 'Backward'};
stimLengths = [37037 37039]

files = dir([dataDir '*' dataFormat]);

for i = 1:length(files)

  runs(i) = Run(pop_loadset(files(i).name));
  runs(i).eogchannels = eogchannels;
  runs(i).stimNames = stimNames;
  runs(i).stimLengths = stimLengths;

end

save([dataDir 'aliceRuns'], 'runs', '-v7.3')

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

save([dataDir 'aliceSubjects'], 'subjects', '-v7.3')

for i = 1:length(subjects)

  subjects(i) = subjects(i).preprocess();

end
