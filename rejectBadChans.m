% Generates file subjects_data_ratings.mat containing subject names, data 
% quality for each video file (0=bad, 1=OK, 2=good, NaN=no data available), 
% and list of bad channels. Loads subjects_data_ratings.mat if it already exists.
% To redo from scratch, be sure to delete it first.

clear all

% load some shared settings 
load('settings','M','path_glob','subject_rating_file');

% get list of directories that are 'm' followed by number
current_subjects = dir([path_glob 'm*' ]);
i=1;
while i<=length(current_subjects)
    if isempty(str2num(current_subjects(i).name(2:end)))
        current_subjects(i)=[];
    else
        i=i+1;
    end
end

% load data if file already exists
if exist(subject_rating_file)
    load(subject_rating_file,'subjectname','dataquality','bad_channels');
else % initialize structure
    subjectname = {}; % string indicating directory where data is saved for each subject
    dataquality = []; % rating 0-2 for each of M eeg files for each subject
    bad_channels ={}; % list of bad channels for each eeg file M * # of subjects
end

clf
% for all subjects in the directory
for i=1:length(current_subjects)
    
    % check if current subject i is in the list of subject names already
    indx=1;
    while indx<=length(subjectname) ...
            && ~strcmp(current_subjects(i).name,subjectname{indx})
        indx=indx+1;
    end
    
    % not found, needs adding
    if indx>length(subjectname)
        
        % add subject to the list
        subjectname{indx} = current_subjects(i).name;
        
        % now get quality for those video files that exist
        for v = 1:M
            name = [path_glob, subjectname{indx},'/EEGppmerg_' num2str(v) '.mat'];
            if exist(name)
                load(name);
                
                % enter bad channels
                bad_channels{v,indx} = [];
                removemore=1;
                while removemore
                    eeg(bad_channels{v,indx},:)=0;
                    clf
                    imagesc(eeg); h1=gca; caxis([-100 100]); set(h1,'xtick',[]); 
                    title(['subject ' num2str(indx) ', movie  ' num2str(v) '  ' subjectname{indx} 10 'Select bad channels']);
            
                    h2=axes('position',[0.1 0.03 0.8 0.05]); x=[-2 -1 0]; imagesc(x, 1, x); 
                    set(h2,'xtick',x,'xticklabel',{'good','OK','bad'},'ytick',[]);
                    title('Click on quality to continue.');
                    axes(h1);
                    
                    pos=ginput(1);
                    if pos(1)>0
                        bad_channels{v,indx} = [bad_channels{v,indx} round(pos(2))];
                    else
                        removemore=0;
                        dataquality(v,indx) = round(abs(pos(1)));
                    end
                end
            else
                dataquality(v,indx)=NaN; % when video file missing
            end
        end
        
        % finished lableing all videos for this new subject, so now save
        save(subject_rating_file, 'subjectname','dataquality','bad_channels')

    end
end


