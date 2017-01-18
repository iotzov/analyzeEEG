eeg = eeg([dataInfo.healthy])
dataInfo = dataInfo([dataInfo.healthy])

Y = []

for i = 1:length(eeg)
  eeg(i).fwd = eeg(i).fwd*w;
  eeg(i).bwd = eeg(i).bwd*w;
  Y = [Y; eeg(i).fwd];
  Y = [Y; eeg(i).bwd];
end
