function [psdEEG, fbin] = getPSD(eeg, fs, window, overlap)

  if nargin<4
    window  = 125;
    overlap = 100;
  end

  padTo = ceil(length(eeg)/window); % find how much to pad with zeros to prevent cut-offs in pwelch
  padTo = padTo*fs;

  eeg(length(eeg):padTo, :) = 0;

  [psdEEG, fbin] = pwelch(eeg, window, overlap, [], fs);

end
%  N = length(eeg);
%
%  dft = fft(eeg);
%  dft = dft(1:N/2+1, :);
%
%  psdEEG = (1/(fs*N)) * abs(dft).^2;
%  psdEEG(2:end-1, :) = 2*psdEEG(2:end-1, :);
%
%  f = 0:fs/length(eeg):fs/2;
%
%end
