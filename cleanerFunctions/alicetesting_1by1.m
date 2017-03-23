dataDir = '/home/ivan/Documents/ResearchDocs/brianData/aliceTesting/new/';
saveDir = '/home/ivan/Documents/ResearchDocs/brianData/aliceTesting/new/mapped_1by1/';
numStims = 2;

load([dataDir 'aliceRuns.mat'])
load([dataDir 'mapping.mat'])

iscresults = struct();

masterRuns = runs([runs.dataQuality]>0); clear runs;

for q = 2:length(masterRuns)

  runs = masterRuns(1:q);

  for z = 1:length(runs)
    runs(z).data = runs(z).data(:, mapping);
  end

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

  iscresults(q).w = w;
  iscresults(q).a = a;
  iscresults(q).isc = isc;
  iscresults(q).persub = persub;

  %newMakeChart(subjects, a)

  %set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
  %saveas(gcf, [saveDir 'ISC_2thru' num2str(q)], 'png');
  %pause(10)
  %close

end

save([saveDir 'iscResults'], 'iscresults')
