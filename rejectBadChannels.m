function [bad_channels, dataquality] = removeBadChannels(eeg)
	bad_channels = [];
	dataquality = []
	removemore=1;
        while removemore
            eeg(bad_channels,:)=0;
            clf
            imagesc(eeg); h1=gca; caxis([-100 100]); set(h1,'xtick',[]); 
%            title(['subject ' num2str(indx) ', movie  ' num2str(v) '  ' subjectname{indx} 10 'Select bad channels']);
    
            h2=axes('position',[0.1 0.03 0.8 0.05]); x=[-2 -1 0]; imagesc(x, 1, x); 
            set(h2,'xtick',x,'xticklabel',{'good','OK','bad'},'ytick',[]);
            title('Click on quality to continue.');
            axes(h1);
            
            pos=ginput(1);
            if pos(1)>0
                bad_channels = [bad_channels round(pos(2))];
            else
                removemore=0;
                dataquality = round(abs(pos(1)));
            end
        end

% finished lableing all videos for this new subject, so now save
% save(subject_rating_file, 'subjectname','dataquality','bad_channels')
