function [eegStruc] = structBadChans(eeg)

  eegStruc = eeg;

  for i = 1:length(eegStruc)

    [a b] = badChanSelect(eegStruc(i));
    eegStruc(i).badChannels = a;
    eegStruc(i).dataQuality = b;

  end

end
