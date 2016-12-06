for i = 1:length(eeg)
  temp = preprocessEEG(double(eeg(i).raw)', [38:39], [], 250);

  templat = [eeg(i).event.latency];

  eeg(i).fwd = temp(templat(1):templat(2), :);
  eeg(i).bwd = temp(templat(3):templat(4), :);

end
