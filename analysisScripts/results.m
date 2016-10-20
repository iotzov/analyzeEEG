if  ~exist('eeglab'), % start UGGLY eeglab only once so we can use topoplot
    addpath('/home/lparra/matlab/eeglab13_4_4b/'); eeglab; % yuck!
end
clear all

show_labels = 0; % set this to 1 if you want to look at the behario labels

load('settings','electrode_loc_file','chan_eeg','movies_dir','category','movies','behaviorfile');

% get electrode locations
elocs = readlocs(electrode_loc_file, 'filetype', 'sfp');
elocs = elocs(chan_eeg);

% show overall results for all movies and all subjects
figure(1); clf
load([movies_dir 'ISCdata_category_' 'all']);
Ncomp=length(ISC_avg);
subplot(2,1,1); bar(ISC_permov');
legend({movies(:).acronym});
maplimits = [min(A_avg(:)) max(A_avg(:))];
for k=1:Ncomp
    subplot(2,Ncomp,Ncomp+k);
    topoplot(A_avg(:,k),elocs,'numcontour',5,'plotrad',0.5,'electrodes','off','maplimits',maplimits);
    title(['C' num2str(k), ' ' 'all']);
end



% show behavior/ISC correlation
whichcomp = 1:3; % select here which component to concider
figure(2); clf
[M,Ncomp]=size(ISC_permov);
[behavior,~,properties]=loadbehavior(behaviorfile,{},{});
[cbeh,pbeh] = nancorrcoef(behavior);
subplot(2,2,1); imagesc(behavior); title('behabior')
xlabel('behavior')
ylabel('participant')
subplot(2,2,3); imagesc(cbeh.*(pbeh<0.01)); caxis([-1 1]); 
title('behavior correlation, p<0.01');
ylabel('behavior')
xlabel('behavior')
iscall=[];vlabel=[];
for v=1:M
    behavior=loadbehavior(behaviorfile,subjects{v},{});
    isc = nanmean(ISC_persubj{v}(:,whichcomp),2); 
    [cbehisc(:,v),p(:,v)] = nancorrcoef(behavior,isc);
    iscall = [iscall;isc];
    vlabel=[vlabel; v*ones(size(isc))];
    Nsubj(v) = size(isc,1);
end
subplot(4,2,2); boxplot(iscall,vlabel,'labels',{movies(:).acronym});
title(['ISC sum:' num2str(whichcomp)])
subplot(4,2,4); bar(Nsubj); set(gca,'xticklabel',{movies(:).acronym})
title('number of useful subjects')
subplot(2,2,4); imagesc(cbehisc.*(p<0.01));  caxis([-1 1]); 
title('behavior/sumISC correlation, p<0.01'); colorbar
set(gca,'xticklabel',{movies(:).acronym})
ylabel('behavior')

if show_labels
    % tell us the labels
    pos = 1;
    while pos>=0 & pos<=length(properties)
        disp([properties{pos} ]);
        pos = ginput(1); pos=round(pos(2));
    end
end

% do spatial mapps differ by movie
figure(3); clf
maplimits = [min(A_movie(:)) max(A_movie(:))];
for v=1:M
    for k=1:Ncomp
        subplot(M,Ncomp,(v-1)*Ncomp+k);
        topoplot(A_movie(v,:,k),elocs,'numcontour',5,'plotrad',0.5,'electrodes','off','maplimits',maplimits);
        title(['C' num2str(k), ' ' movies(v).acronym]);
    end
end


% do spatial mapps differe by category (we know they do not differe by movie)
figure(4); clf
maplimits = [min(A_avg(:)) max(A_avg(:))];
Ncond=length(category);
for c=1:Ncond
    load([movies_dir 'ISCdata_category_' category(c).name], 'A_avg');
    for k=1:Ncomp
        subplot(Ncond,Ncomp,(c-1)*Ncomp+k);
        topoplot(A_avg(:,k),elocs,'numcontour',5,'plotrad',0.5,'electrodes','off','maplimits',maplimits);
        title(['C' num2str(k), ' ' category(c).name]);
    end
end

