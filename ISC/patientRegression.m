load ../processedDataWithInfo.mat

healthy = find([dataInfo.healthy]==1); patient = find([dataInfo.healthy]==0);

Y = []; X = [];

for i = healthy

  Y = cat(1, Y, eeg(i).fwd);
  Y = cat(1, Y, eeg(i).bwd);

end
