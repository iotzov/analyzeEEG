function [del, thet, alph, bet] = showPower(pxx, fbin)

del  = [0.5 3.5];
thet = [3.5 7.0];
alph = [7.0 13.0];
bet  = [13.0 30.0];

del  = bandpower(pxx, fbin, del, 'psd');
thet = bandpower(pxx, fbin, thet, 'psd');
alph = bandpower(pxx, fbin, alph, 'psd');
bet  = bandpower(pxx, fbin, bet, 'psd');
tot_bands  = bandpower(pxx, fbin, [.5 30], 'psd');
tot  = bandpower(pxx, fbin, 'psd');


disp(['del  : ' num2str( del  ) ' |  % of tot_bands = ' num2str( (del  / tot_bands) * 100 )]);
disp(['thet : ' num2str( thet ) ' |  % of tot_bands = ' num2str( (thet / tot_bands) * 100 )]);
disp(['alph : ' num2str( alph ) ' |  % of tot_bands = ' num2str( (alph / tot_bands) * 100 )]);
disp(['bet  : ' num2str( bet  ) ' |  % of tot_bands = ' num2str( (bet  / tot_bands) * 100 )]);
disp(['tot  : ' num2str( tot  ) ' |  % of total = ' num2str( (tot  / tot) * 100 )]);
disp(['tot_bands  : ' num2str( tot_bands  ) ' |  % of tot_bandsal = ' num2str( (tot_bands  / tot_bands) * 100 )]);

end
