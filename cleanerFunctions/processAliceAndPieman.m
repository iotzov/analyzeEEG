dataDir = 'F:\Work Files\brianData\pieman\';

load([dataDir 'aliceRuns_04-04-17.mat'], 'runs');
load([dataDir 'piemanRuns.mat'], 'h');
load([dataDir 'subjectColors.mat'], 'colors');

disp('Done Loading')

p = Plotter();
p.stimNames = {'Fwd-A' 'Bwd-A' 'Bwd-P' 'Scr-P' 'Fwd-P'};

runs([runs.dataQuality]==0) = [];
h([h.dataQuality]==0) = [];

for i = 1:length(runs)

  runs(i).stimIDs = [1 2];

end

for i = 1:length(h)

  h(i).stimIDs = [3 4 5];

end

s = unique([runs.subject h.subject]);

disp('Now preprocessing.')

for i = 1:length(s)

  subjects(i) = Subject(s(i));
  subjects(i) = subjects(i).addRun(runs([runs.subject]==s(i))); % Add Alice data into Subjects container
  subjects(i) = subjects(i).addRun(h([h.subject]==s(i)));       % Add Pieman data into Subjects container

  subjects(i) = subjects(i).preprocess();

  disp(['Subject ' num2str(i) ' done.'])

end

disp('Calculating ISC.')
[subjects results] = subjectMultiStimISC(subjects, [1:5]);
disp('Done.')

p.w = results.w;
p.a = results.a;
p.chanlocs = subjects(1).runs(1).chanlocs;

p.plotISC(subjects)
p.plotTopoplot()
