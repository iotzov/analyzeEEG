% Concatenates all subjects into a single volume separteally for each movie
% and saves it into 'movie' directory. Only uses data with decent quality,
% zeros out bad channels.
% Generates separate volumes for subjects matching various categories

clear all

% load some shared settings 
load('settings','M','path_glob','subject_rating_file','category','movies_dir','behaviorfile','conditions_to_run');

% for all demographic categories in conditions_to_run
for c = conditions_to_run
    
    % select subjects where the demographic feature is in desired range
    load(subject_rating_file, 'subjectname','dataquality','bad_channels');
    feature = loadbehavior(behaviorfile,subjectname,category(c).demographic);
    % subjects selection; missing features (NaN) will be droped here as well
    subset = find(category(c).range(1)<=feature & feature<=category(c).range(2));
    
    % for all video files, collect subjects in subjectname with that data
    for v = 1:M
        
        % these two variables will collect all subjects for this movie v
        movie_subs={}; movie=[]; s=0;
    
        % for all subjects that match the criterion
        for i=1:length(subset)
            
            videofile = [path_glob  subjectname{subset(i)}, '/EEGppmerg_', num2str(v), '.mat'];
            
            % check if it is available and of OK quality
            if  dataquality(v,subset(i))>0
                
                if ~exist(videofile)
                    warning(['Have labels for this file but it does not exist. Have to skip:' 10 videofile]);
                else
                    
                    % load it
                    load(videofile,'eeg');
                    
                    % zero out bad channels
                    eeg(bad_channels{v,subset(i)},:) = 0;
                    
                    % keep user entertained
                    clf; imagesc(eeg); caxis([-100 100]);
                    title([category(c).name ', movie ' num2str(v) ', ' subjectname{subset(i)} ])
                    drawnow;
                    
                    % add it to the existing data volume
                    s=s+1;
                    movie(:,:,s) = eeg;
                    movie_subs{s} = subjectname{subset(i)};
                end
            end
        end % subjects

        % show us something
        str = ['movie_' num2str(v) '_category_' category(c).name]; 
        disp([str ', # of subjects: ' num2str(s)]);
        
        % save all subjects for this movie and category
        if s, save([movies_dir str '.mat'],'movie','movie_subs'); end
        
    end % movies
    
end % categories
