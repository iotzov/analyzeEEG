dataDir = '/home/ivan/Documents/ResearchDocs/minConsciousEEG/Alice_Set_Files/';
saveDir = '';

load([dataDir 'aliceRuns.mat'])

runsToExclude = [8,10,11,13,17,85];

% Inform user # of files being excluded because of bad data quality
disp('Number of runs being excluded due to bad data quality: ');
disp(length(find([runs.dataQuality]==0))+length(runsToExclude));

% Remove bad runs
runs = runs([runs.dataQuality]>0);

runs(runsToExclude) = [];

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

iscresults = struct();
iscresults.w = w;
iscresults.a = a;
iscresults.isc = isc;
iscresults.persub = persub;

% save([dataDir 'aliceSubjects_Processed'], 'subjects', 'iscresults', '-v7.3')

newMakeChart(subjects, a)

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
saveas(gcf, [saveDir 'topoplot'], 'png');
close

set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
saveas(gcf, [saveDir 'ISC'], 'png');
close
