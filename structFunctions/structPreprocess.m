for i = 1:length(piemandata)
  temp = preprocessEEG(double(piemandata(i).data)', [38:39], piemanInfo(i).badChannels, 250);

  piemandata(i).fwd = temp(piemandata(i).fwd(1):piemandata(i).fwd(1) + 112562, :);
  piemandata(i).bwd = temp(piemandata(i).bwd(1):piemandata(i).bwd(1) + 112562, :);
  piemandata(i).scram = temp(piemandata(i).scram(1):piemandata(i).scram(1) + 112562, :);

end
