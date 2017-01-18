eeg = eeg([dataInfo.healthy])
dataInfo = dataInfo([dataInfo.healthy])

for i = 1:length(eeg)
  projected_eeg(i).fwd = eeg(i).fwd*w;
  projected_eeg(i).bwd = eeg(i).bwd*w;
end
