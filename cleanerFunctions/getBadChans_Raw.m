function [badChannels, dataquality] = badChanSelect(inputEEG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function returns a vector containing user selections about each of the channels in inputEEG
%
% Input:
% 		inputEEG - Run class w/data and fs attributes
%
% Output:
% 		badChannels - Vector of length N, contains only (0/1/2) based on user determination of channel quality
% 			badChannels(X) returns user-determined quality of channel #X
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs = inputEEG.fs;

[b,a,k]=butter(5,0.5/fs*2,'high'); sos = zp2sos(b,a,k);

[T,D]=size(inputEEG.data);

inputEEG.data = inputEEG.data-repmat(inputEEG.data(1,:),T,1);  % remove starting offset to avoid filter transient

inputEEG.data = sosfilt(sos,inputEEG.data);

inputEEG.data = inputEEG.data - inputEEG.data(:,38:39) * (inputEEG.data(:,38:39)\inputEEG.data);

badChannels = []; removemore=1;

clf
imagesc(inputEEG.data'); h1=gca; caxis([-100 100]); set(h1,'xtick',[]);
title(['Select bad channels' ' ' num2str(inputEEG.subject)]); set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

h2=axes('position',[0.1 0.03 0.8 0.05]); x=[-2 -1 0]; imagesc(x, 1, x);
set(h2,'xtick',x,'xticklabel',{'good','OK','bad'},'ytick',[]);
title('Click on quality to continue.');
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
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
