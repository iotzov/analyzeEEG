classdef Run

  properties
    data
    file
    chanlocs
    processed
    event
    subject
    dataQuality
    badChannels
    fs
    eogchannels
    stimNames
    stimLengths
    stimStart
    ISC
    name
    stimIDs % 1=aliceFWD, 2=aliceBWD, 3=piemanFWD, 4=piemanBWD, 5=piemanSCR
  end

  methods
  function obj = Run(setHeader)
    if ~isfield(setHeader, 'BDF')
      obj.data = setHeader.data';
      obj.event = setHeader.event;
      obj.chanlocs = setHeader.chanlocs;
      obj.file = setHeader.filename;
      obj.subject = str2num(obj.file(3:5));
      obj.processed = 0;
      obj.fs = setHeader.srate;
    else
      obj.data = sread(setHeader);
      obj.event = setHeader.EVENT;
      [pwd '/' 'BioSemi64.locs']
      obj.chanlocs = pop_readlocs([pwd '/' 'BioSemi64.loc']);
      obj.file = [setHeader.FILE.Path '/' setHeader.FILE.Name];
      obj.subject = str2num(setHeader.FILE.Name(end));
      obj.processed = 0;
      obj.fs = setHeader.SampleRate;
    end
    end

    function obj = getBadChannels(obj)
      [obj.badChannels obj.dataQuality] = getBadChans_Raw(obj);
    end

    function obj = preprocess(obj)
      obj.processed = 1; % Set processed flag to 1
      obj.chanlocs(obj.eogchannels) = []; % Remove EOG channels from channel locations
      temp = obj.data;
      obj.data = {};
      % Pre
      for i = 1:length(obj.stimLengths)
        obj.data{i} = preprocessEEG(temp(obj.stimStart(i):obj.stimStart(i)+obj.stimLengths(i)-1,:), obj.eogchannels, obj.badChannels, obj.fs);
      end
      %obj.data = preprocessEEG(obj.data, obj.eogchannels, obj.badChannels, obj.fs);
    end

    function data = extract(obj, stimIndex)
      % Takes index of stimBoundaries and extracts relevant data epoch
      % Returns desired sequence based on input
      %data = obj.data(obj.stimStart(stimIndex):obj.stimStart(stimIndex)+obj.stimLengths(stimIndex)-1,:);
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
  end

end
