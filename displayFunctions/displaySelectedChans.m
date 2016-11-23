function displaySelectedChans(inputStruc)

imagesc(inputStruc.fwd'); caxis([-100 100]);

yticks(sort(inputStruc.badChannels))
a = {};
for i=1:length(inputStruc.badChannels)
	a = [a 'bad'];
end
yticklabels(a)
set(gcf, 'units', 'normalized', 'outerposition', [0 0 1 1])
waitforbuttonpress
end
