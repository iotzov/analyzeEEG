clear all

% load some shared settings 
load('settings','path_glob');

files_eeg_all = dir([path_glob 'm*' ]);
all_names = {files_eeg_all.name};

triggers = [81:86];
end_triggers = triggers+20;
padding_start   = 4; % 4 seconds of padding
padding_end     = 0.5; % 0.5 seconds of padding

for i=1:length(all_names),
    pth = [path_glob all_names{i} filesep];
    
    raw_files = dir([pth 'm*.raw']);
    for j=1:length(raw_files),
        clear pEEG;
        pEEG =pop_readegi([pth raw_files(j).name], []);  % EEGLAB function for opening EGI
        
        if ~isempty(pEEG.event), % make sure there are events to analyze
            for k=1:length(triggers), % run through and find triggers
                idx = find([ str2double({pEEG.event.type}) ] == triggers(k));
                
              
                
                for t=idx % foreach trigger index found
                    disp(['found trigger ' pEEG.event(t).type]);
                    if (str2double(pEEG.event(t+1).type) ~= end_triggers(k)),
                        disp('there is a problem'); 
                    else
                        eeg = pEEG;
                        
                        
                        
                        % zero pad the begining of the data matrix if not
                        % enough samples
                        padding = [];
                        if ((eeg.event(t).latency-padding_start*eeg.srate) < 1),
                            start_index = 1;
                            %padding = zeros(eeg.nbchan, (padding_start*eeg.srate-eeg.event(t).latency)+1 );
                            padding = repmat(eeg.data(:,start_index), 1, (padding_start*eeg.srate-eeg.event(t).latency)+1); 
                        else
                            start_index = eeg.event(t).latency - padding_start*eeg.srate;
                        end
                        end_index = eeg.event(t+1).latency + padding_end*eeg.srate;
                        
                        
                        % make new strusture for the movie data
                        data = [padding eeg.data(:,start_index:end_index)];
                        time = eeg.times(start_index:end_index);
                        
                        
                        eeg.data = data;
                        eeg.xmax = (length(data)-1)/eeg.srate; % recalculate xmax
                        eeg.times = (0:1:(length(data)-1))/eeg.srate;
                        eeg.event = eeg.event(t:t+1);
                        eeg.pnts = length(data);
                        eeg.urevent = eeg.urevent(t:t+1);
                        eeg.movie_length = length(eeg.data);
                        eeg.extrapadding = size(padding,2);
                        eeg.padding_start = padding_start;
                        eeg.padding_end = padding_end;
                        
                        eeg.data(end+1,:) = 0;
                        eeg.nbchan = eeg.nbchan+1;
                        eeg = pop_chanedit(eeg,  'load',{'GSN-HydroCel-129.sfp', 'filetype', 'sfp'});
                        
                        
                        %save the movie to a mat file
                        filename = [pth 'EEGraw_' num2str(rem(triggers(k), 10))];
                        disp(['saving... ' filename]);
                        save(filename, 'eeg'); % disp(['raw file' raw_files(j).name]); pause;
                    end
                end
            end
        end
    end
end
