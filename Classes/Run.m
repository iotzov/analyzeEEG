classdef Run

properties

data            % EEG data for this run
file            % name of the original data file
chanlocs        % channel location struct
processed       % bool variable indicating if data is preprocessed or not
event           % event struct of original run file
subject         % subject ID
dataQuality     % data quality ranking from 0 to 2, 0 being bad and 2 being great
badChannels     % which channels in the recording are bad and should be removed
fs              % sampling rate of the recording
eogChannels     %* which channels if any are EOG channels
stimNames       %* names of the stimuli presented
stimLengths     %* array of the lengths of stims presented (if stimEnd-stimStart > stimLength then samples trimmed from the beginning until they are equal)
stimStart       %* array of the start times of stimuli (start times should be the first sample to include)
stimEnd         %* array of the end times of stimuli (end times should be the last sample to include)
stimIDs         %* IDs of the stimuli, should be in same order as stimStart and stimLengths

% * indicates properties that should be set manually

end

methods
function obj = Run(setHeader)
  if nargin>0
    obj.data = double(setHeader.data');
    obj.event = setHeader.event;
    obj.chanlocs = setHeader.chanlocs;
    obj.file = setHeader.filename;
    obj.subject = str2num(obj.file(3:5));
    obj.processed = 0;
    obj.fs = setHeader.srate;
  end
end

function obj = getBadChannels(obj)

  [obj.badChannels obj.dataQuality] = getBadChans_Raw(obj);

end

function obj = preprocess(obj)
  obj.processed = 1; % Set processed flag to 1

  options.badchannels = obj.badChannels;
  options.eogchannels = obj.eogChannels;

  temp = preprocessEEG_RPCA(obj.data, obj.fs, options);
  %temp = preprocessEEG(obj.data, obj.eogChannels, obj.badChannels, obj.fs);
  obj.data = {};

  for i = 1:length(obj.stimLengths)
    %obj.data{i} = temp(obj.stimStart(i):obj.stimStart(i) + obj.stimLengths(i), :);
    obj.data{i} = temp(obj.stimStart(i):obj.stimEnd(i), :);
    if(length(obj.data{i}) - obj.stimLengths(i)+1 < 0)
        obj.data{i} = temp(obj.stimStart(i):obj.stimStart(i)+obj.stimLengths(i)-1, :);
    else
        obj.data{i} = obj.data{i}(length(obj.data{i}) - obj.stimLengths(i)+1:end, :);
    end
  end

end

function data = extract(obj, stimIndex)
  % Takes ID of desired sequence and returns requested EEG data
  % Returns desired sequence based on input
  canExtract = find(obj.stimIDs==stimIndex);
  if(canExtract)
    data = obj.data{canExtract};
  else
    data = [];
  end
end

function data = extractManually(obj, startIndex, sampleLength)
  data = obj.data(startIndex:startIndex+sampleLength-1,:);
end

function subjects = getSubjects(obj)

  s = [obj.subject];
  S = unique(s);

  subjects = Subject(1);

  for i = 1:length(S)
    subjects(i) = Subject(S(i));
    subjects(i) = subjects(i).addRun(obj(find(s==S(i))));
  end

end

end

end
