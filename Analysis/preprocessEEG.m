% -------------------------------------------------------------------------
function X = preprocessEEG(X,eogchannels,badchannels,fs,fsDesired,skip)
% X = preprocessEEG(X,eogchannels,badchannels,fs,fsDesired,skip)
% 	X 		- EEG data
% 	eogchannels     - array of eog channnel indices (will be cropped out)
% 	badchannels     - array of bad channels (will be 0'd out)
% 	fs 		- sampling rate of EEG
% 	fsDesired 	- desired sampling rate (OPTIONAL)
% 	skip 		- skip this many initial samples (OPTIONAL)
%
% All the usual EEG preprocessing, except epoching and epoch rejection as
% there are not events to epoch with in natural stimuli. duh! Instead, bad
% data is set = 0 in the continuous stream, which makes sense when
% computing covariance matrices but maybe not for other purposes.

if nargin < 5

	skip      = 0;
	fsDesired = [];

elseif nargin < 5

	skip = 0;

end

debug = 0;   % turn this on to show data before/after preprocessing.
stdThresh=4; % samples larger this many STDs will be marked as outliers
HPcutoff =0.5; % HP filter cut-off frequequency in Hz

% pick your preferred high-pass filter
[b,a,k]=butter(5,HPcutoff/fs*2,'high'); sos = zp2sos(b,a,k);

[T,D]=size(X);


% Preprocess data

data = X(:,:);

% remove starting offset to avoid filter transient
data = data-repmat(data(1,:),T,1);

% show the original data
if debug, subplot(2,1,1); imagesc((1:T)/fs,1:D,data'); title('work in progress'); end

% high-pass filter
data = sosfilt(sos,data);

% regress out eye-movements;
data = data - data(:,eogchannels) * (data(:,eogchannels)\data);

% resample, if necessary
if(fsDesired)

	data = resample(data, fsDesired, fs);
	[T, D] = size(data);

end

% detect outliers above stdThresh per channel;
data(abs(data)>stdThresh*repmat(std(data),[T 1])) = NaN;

% remove 40ms before and after;
h=[1; zeros(round(0.04*fs)-1,1)];
data = filter(h,1,flipud(filter(h,1,flipud(data))));

% Mark outliers as 0, to avoid NaN coding and to discount noisy channels
data(isnan(data))=0;

% also zero out bad channels
data(:,badchannels(:))=0;

% remove eog channels
data(:,eogchannels) = [];

% show the result of all this
if debug, subplot(2,1,2); imagesc((1:T)/fs,1:D,data'); caxis([-100 100]); xlabel('Time (s)'); drawnow; end

X = data(1+skip:end,:);

end
