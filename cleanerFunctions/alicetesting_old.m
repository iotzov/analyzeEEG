dataDir = '/home/ivan/Documents/ResearchDocs/brianData/aliceTesting/old/';
dataFormat = '.set';
eogchannels = [];
stimNames = {'Forward' 'Backward'};
stimLengths = [37037 37039];
numStims = length(stimLengths);
% if value below is 1, user will be prompted to manually select bad channels for each run
% if value is 0, bad channel data will be assumed to be located in dataDir/badChannels.mat

files = dir([dataDir '*' dataFormat]);

load([dataDir 'nomatch.mat']);
%load([dataDir 'mapping.mat']);

files(nomatch) = [];

for i = 1:length(files)
  runs(i) = Run(pop_loadset([dataDir files(i).name]));
  runs(i).eogchannels = eogchannels;
  runs(i).stimNames = stimNames;
  runs(i).stimLengths = stimLengths;
  runs(i).data = double(runs(i).data);
  runs(i).stimStart(1) = runs(i).event(1).latency;
  runs(i).stimStart(2) = runs(i).event(3).latency;
  runs(i).badChannels = [];
  runs(i).dataQuality = 1;
  runs(i).data = runs(i).data(:,1:37);
  runs(i) = runs(i).preprocess();
%  runs(i).data = runs(i).data(:,mapping);
end

%save([dataDir 'aliceRuns'], 'runs', '-v7.3')

saveDir = dataDir;
runs = runs([runs.dataQuality]>0);
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
keyboard
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
iscresults = struct();
iscresults.w = w;
iscresults.a = a;
iscresults.isc = isc;
iscresults.persub = persub;
%save([dataDir 'aliceSubjects_Processed'], 'subjects', 'iscresults', '-v7.3')
newMakeChart(subjects, a)
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
%saveas(gcf, [saveDir 'topoplot'], 'png');
%close
%set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
%saveas(gcf, [saveDir 'ISC'], 'png');
%close
