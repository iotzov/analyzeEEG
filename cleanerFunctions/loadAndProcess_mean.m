dataDir = '/home/ivan/brianData/';
dataFormat = '.set';
saveDir = '/home/ivan/brianData/missing1_results/';
eogchannels = 38:39;
stimNames = {'Forward' 'Backward'};
stimLengths = [37037 37039];
numStims = length(stimLengths);

addpath(genpath('/home/ivan/eegMinCon-analyze'))

load([dataDir 'aliceRuns.mat'], 'runs')
load([dataDir 'subjectColors.mat'])

	s = [runs.subject];
  sunique = unique(s);

  for i = 1:length(sunique)

    subjects(i) = Subject();
    subjects(i) = subjects(i).setID(sunique(i));
    subjects(i).color = colors(sunique(i),:);
    current = runs([runs.subject]==sunique(i));

    for j = 1:length(current)
      subjects(i) = subjects(i).addRun(current(j));
    end

  end

	ISCdata = {};
	ISCdata{1} = [];
	ISCdata{2} = [];

	for q = 1:length(subjects)

		averagedSubjects(q) = Subject();
		averagedSubjects(q) = averagedSubjects(q).setID(sunique(q));
		averagedSubjects(q).color = colors(sunique(q),:);
		current = runs([runs.subject]==sunique(q));
		averagedSubjects(q) = averagedSubjects(q).addRun(current(1));

		for j = 1:length(current)
			toaveragefwd(:,:,j) = current(j).extract(1);
			toaveragebwd(:,:,j) = current(j).extract(2);
		end

		toaveragefwd = mean(toaveragefwd, 3);
		toaveragebwd = mean(toaveragebwd, 3);

		ISCdata{1} = cat(3, ISCdata{1}, toaveragefwd);
		ISCdata{2} = cat(3, ISCdata{2}, toaveragebwd);

	end


  refSubjects = {};
	refSubjects{1} = find([averagedSubjects.id]<300);
	refSubjects{2} = find([averagedSubjects.id]<300);
  fs = 250;

  [isc persub w a] = multiStimISC(ISCdata, refSubjects, fs);

	runs = [averagedSubjects.runs];

  for j = 1:length(runs)
    for i = 1:numStims
      runs(j).ISC{i} = persub{i}(:,j);
    end
  end

	for j = 1:length(runs)
		averagedSubjects(j).runs(1) = runs(j);
	end


  save([saveDir 'aliceSubjects_averaged'], 'averagedSubjects', '-v7.3')

  newMakeChart(subjects, a)

  set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
  saveas(gcf, [saveDir 'averaged_topoplots'], 'png')
  close

  set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
  saveas(gcf, [saveDir 'averaged_ISC'], 'png')
  close
