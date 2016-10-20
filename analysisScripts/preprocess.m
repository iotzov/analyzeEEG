% preprocess_merging_before_pca_150306.m
% Created by Agustin Petroni on November 2014. Last mod March 2015
% modified by Lucas Parra April 1, 2015 
% Input:  'EEGraw_' files created in egi2mat.m
% Output: 'EEGppmerg_' files

clear all;
addpath(genpath('~/matlab/inexact_alm_rpca'));

% load some shared settings 
load('settings','path_glob','fsref','chan_eog','chan_eeg');

% horrendous way of communicating parameters set by a different program!
padding_start   = 4; % 4 seconds of padding
padding_end     = 0.5; % 1 seconds of padding

% mean movie duration at 500Hz and fsref (desired length for all) 
mean_samples = [58994 45189 137400 50363 85885 85570]; 
mean_samples_new = round(mean_samples/500*fsref); 

% directories with subject data
subfiles = dir([path_glob 'm*' ]);

% for all subjects
for nn = 1:length(subfiles)
    
    subjdir = [path_glob subfiles(nn).name filesep];
    
    % EEG files for this subjects
    eegfiles = dir([subjdir 'EEGraw_*']);    
    
    % things to keep track for every eegfile processed
    video_nrs=[]; alleeg = {}; duration = [];
    
    for w = 1:length(eegfiles)
        
        % which video are we loading
        video_number = str2num(eegfiles(w).name(8));
        
        % load eeg data for that video
        load([subjdir eegfiles(w).name]);
        fs=eeg.srate;
        padding = eeg.extrapadding;
        %padding_start=eeg.padding_start;
        %padding_end=eeg.padding_end;
        eeg = double(eeg.data)';

        
        % keep user entertained
        str=['Subject ' num2str(nn) ': ' subfiles(nn).name ', video: ' num2str(video_number)];
        disp(str)
        
        % only select movies with difference less than 100ms from mean
        deviation = length(eeg)-(padding_start+padding_end)*fs-mean_samples(video_number);
        if abs(deviation)> fs*0.100
            disp([num2str(video_number) ' not processed, length off by (s):' num2str(deviation/fs)]);
        else
            
            % replace padded zeros (if any) with first valid sample to avoid filter-transients
            eeg(1:padding,:) = repmat(eeg(padding+1,:), [padding 1]);
            
            % Filter
            eeg = eeg-repmat(eeg(1,:),[length(eeg) 1]);
            [b,a]=butter(4,       1/(fs/2),'high'); eeg = filter(b,a,eeg);
            [b,a]=butter(4,[58 61]./(fs/2),'stop'); eeg = filter(b,a,eeg);
            
            % downsample
            eeg = resample(eeg,fsref,fs);
            
            % Cut tails
            eeg = eeg(round(padding_start*fsref)+1:end-round(padding_end*fsref),:);
            
            % Standartize length 
            new = mean_samples_new(video_number)-1; old=length(eeg)-1;
            eeg=interp1((0:old)',eeg,(0:new)'/new*old);
            
            % EOG removal
            eog = eeg(:,chan_eog); 
            eeg = eeg(:,chan_eeg);
            eog = eog(:,find(sum(eog)~=0)); % exclude eog channels == 0 
            eeg = eeg - eog * (eog\eeg);
            
            % show user how it's going
            subplot(2,1,1); imagesc(eeg'); caxis([-100 100]);
            title(str); drawnow
            
            alleeg{end+1} = eeg';
            duration(end+1) = length(eeg);
            video_nrs(end+1) = video_number;
        end
        
    end
        
    % stack them together
    alleeg = [alleeg{:}]';
    
    if ~isempty(alleeg);
        
        % Run robust PCA
        alleeg  = inexact_alm_rpca(alleeg);
        
        % show user how it's going
        subplot(2,1,2); imagesc(alleeg'); caxis([-100 100]);
        title(subfiles(nn).name); drawnow
        
        % save each separately, will all pertinent information
        tmarkers = [0 cumsum(duration)];
        for p = 1:length(tmarkers)-1
            eeg = alleeg(tmarkers(p)+1 : tmarkers(p+1),:)';
            fs=fsref/2;
            save([subjdir 'EEGppmerg_' num2str(video_nrs(p))],'eeg','fs','chan_eeg');
        end
        
    end
    
end

