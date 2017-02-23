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
  end

  methods
    function obj = Run(setHeader)
      obj.data = setHeader.data';
      obj.event = setHeader.event;
      obj.chanlocs = setHeader.chanlocs;
      obj.file = setHeader.filename;
      obj.subject = str2num(obj.file(3:5));
      obj.processed = 0;
      obj.fs = setHeader.srate;
    end

    function obj = getBadChannels(obj)
      [obj.badChannels obj.dataQuality] = getBadChans_Raw(obj);
    end

    function obj = preprocess(obj)
      obj.processed = 1;
      obj.data = preprocessEEG(obj.data, obj.eogchannels, obj.badChannels, obj.fs);
    end

    function data = extract(obj, stimIndex)
      % Takes index of stimBoundaries and extracts relevant data epoch
      % Returns desired sequence based on input
      data = obj.data(obj.stimStart(stimIndex):obj.stimStart(stimIndex)+obj.stimLengths(stimIndex)-1,:);
    end

    function data = extractManually(obj, startIndex, sampleLength)
      data = obj.data(startIndex:startIndex+sampleLength-1,:);
    end
  end

end
