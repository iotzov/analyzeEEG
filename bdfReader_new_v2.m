% read in raw bdf and create matlab structures
clear all;  clc;
% Biosemi - 64 Channels
% cd('Desktop/Experiments')

% run script to set all file names and other experiment info
set_subject_filenames % defines subjects, movienames, good_subjects

%Filter we will use:
fsref = 256; 
[hpnum,hpdenom]=butter(4,0.3/fsref*2,'high'); % drift removal
[notchnum,notchdenom]=butter(4,[59 61]/fsref*2,'stop'); % 60Hz line noise
a = poly([roots(hpdenom);roots(notchdenom)]);
b = conv(hpnum,notchnum);
clear hpnum hpdenom notchnum notchdenom;
% freqz(b,a,fsref*8,fsref); xlim([0 1]) % check filter

% processing the ii-th subject 

for ii=last_subjects
    
    disp(subjects(ii).bdf)
    
    % load data
    [data,fs,nseconds] = bdfread_jacek(subjects(ii).bdf);

    clf 
    plot(data(:,end)); title(subjects(ii).bdf);
    drawnow;
    
    if rem(size(data,2),32)~=9, error('This subjects may be missing EOG electrodes!'); end
    
    % dump all channels above 64 but keep EOG and trigger channels 
    data = data(:,[1:64 end-8:end]);
    N = size(data,2);
          
    % Subtracting offset
    data(:,1:N-1) = data(:,1:N-1) - repmat(data(1,1:N-1), [size(data, 1) 1]);
        
    % harmonize sampling rate
    if fs~=fsref % Resample so that fs=fsref
        data2= resample(data,fsref,fs);
        if fs>fsref % Alter the trigger so that it has the correct number of values
            data2(:,N) = downsample(data(:,N),fs/fsref);
        else
            tmp = repmat(data(:,N),[1 fsref/fs])';
            data2(:,N) = tmp(:);
        end
        data=data2; clear data2;
    end
    
    % fitler the data
    data(:,1:N-1) = filter(b,a,data(:,1:N-1));
    
    % detect start (=0) and end times (coded as negative values)
    ttime = find(diff(data(:,N))>0)+1; % indices of triggers
    tvalue = data(ttime,N); % all trigger values
    for j=1:length(tvalue)-2
        % detect starts
        if tvalue(j)==69 && tvalue(j+1)==1
            tvalue(j) = 0; 
        end
        % detect the end if 
        if tvalue(j)>tvalue(j+1) && tvalue(j+1)~=1 ... % a jump down but not carryover
          || j~=1 && tvalue(j)==69 && tvalue(j+1)==69 ... % odd case of 69 sec long clip that is not the last one
          || tvalue(j)+1<tvalue(j+1) &&  tvalue(j+1)==69 ... % a jump up by more than one to 69 (clip less than 68 sec)
          || tvalue(j)+1==69 && tvalue(j+2)==1 % odd case of 68 sec long clip
          tvalue(j) = -tvalue(j);
        end
    end
    tvalue(end) = -tvalue(end); % last event is always the end of a clip (we hope)
    
    stindx1 = find(tvalue==0); % Indices of "starts"
    stindx2 = find(tvalue<0); % Indices of "ends"
    
    % Reject up to 1 false end (movie for which only the end was played)
    if length(stindx1)<length(stindx2)
        for j=1:length(stindx1)-1
            if stindx2(j)==stindx1(j)-1
                tvalue(stindx2(j)) = -tvalue(stindx2(j));
            break
            end
        end
    end
    
    % Remove videos with duration shorter than 30 sec (false start)
    for j=1:length(stindx2)
        if abs(tvalue(stindx2(j)))<=30
            tvalue(stindx2(j)) = -tvalue(stindx2(j));
            tvalue(stindx1(j)) = tvalue(stindx1(j)+1);
        end
    end
    clear stindx 1 stindx 2;
    stindx = find(tvalue==0);
    starttime = ttime(stindx);
    duration  = -tvalue(find(tvalue<0));
    
    
    % Find order of movies for individual
    load(subjects(ii).movieorder, 'r');
    
    if length(duration)~=length(r), error('A movie clip may be missing in the EEG data. Check movieorder variable'); end;
        
    clf
    
    % prealocate so code in the future does not crash
    M = length(moviename); % number of movies we could have best case
    eeg=cell(1,M);
    
    % some movies may have been already saved from a different subject file
    if exist(subjects(ii).segmentedeeg)
        load(subjects(ii).segmentedeeg,'eeg');
    end
    
    % for all movies could be had in principle
    for i=1:length(duration)
        
        % select from starttime to duration * inter-trigger-interval (avg.
        % sampling rate)
        t = ttime(stindx(i)+(1:duration(i))); % sample index of each "1s" trigger
        iti(i) = round(mean(diff(t)));    % inter-trigger-interval in integer samples 
        selrange = starttime(i)+(1:duration(i)*iti(i));
        eeg{r(i)} = data(selrange,:);

        subplot(M/2,2,i); imagesc(eeg{r(i)}'); 
        title(moviename{r(i)})
        axis off;  caxis([-200 200])
        drawnow
        
    end
    
    save(subjects(ii).segmentedeeg,'eeg','moviename','fsref'); 
 
end
