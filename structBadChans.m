function [eegStruc] = structBadChans(eeg)

  eegStruc = eeg;

  for i = 1:length(eegStruc)

    eegStruc(i).badChannels = badChanSelect(eegStruc(i));

  end

end
