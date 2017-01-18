eeg = eeg([dataInfo.healthy])
dataInfo = dataInfo([dataInfo.healthy])

YF = [];
YB = [];

for i = 1:length(eeg)
  eeg(i).fwd = eeg(i).fwd*w;
  eeg(i).bwd = eeg(i).bwd*w;
  YF = [YF; eeg(i).fwd];
  YB = [YB; eeg(i).bwd];
end
