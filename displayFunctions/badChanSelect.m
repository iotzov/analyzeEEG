function [badChannels, dataquality] = badChanSelect(inputEEG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function returns a vector containing user selections about each of the channels in inputEEG
%
% Input:
% 		inputEEG - MxN array of M samples by N electrodes
% 			** Input must be pre-processed before channel rating! **
% Output:
% 		badChannels - Vector of length N, contains only (0/1/2) based on user determination of channel quality
% 			badChannels(X) returns user-determined quality of channel #X
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


eegSize = size(inputEEG.fwd);

badChannels = []; removemore=1;

clf
imagesc(inputEEG.fwd'); h1=gca; caxis([-100 100]); set(h1,'xtick',[]);
title(['Select bad channels' ' ' inputEEG.subj]); set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

h2=axes('position',[0.1 0.03 0.8 0.05]); x=[-2 -1 0]; imagesc(x, 1, x);
set(h2,'xtick',x,'xticklabel',{'good','OK','bad'},'ytick',[]);
title('Click on quality to continue.');
axes(h1);
while(removemore)
pos=ginput(1);

if pos(1)>0
    badChannels = [badChannels round(pos(2))];
else
  removemore=0;
    dataquality = round(abs(pos(1)));
end

end

close
