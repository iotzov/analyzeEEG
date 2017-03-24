addpath('~/matlab')
if ~exist('ALLEEG')
    addpath('~/matlab/eeglab13_4_4b')
    eeglab
end
keep ALLEEG

load('filenames.mat','filenames_diff','filenames_same');
filenames = filenames_diff;

D = 37;

for k=3 % 1:size(filenames,2);
    figure(k)
    
    for j=1:size(filenames,1)
        h = pop_loadset(filenames{j,k});
        for i=1:length(h.event)/2
            tmp = h.data(1:D,h.event((i-1)*2+1).latency:h.event(i*2).latency);
            data{i,j}=tmp-repmat(mean(tmp,2),1,size(tmp,2));
            type{j,k}=h.event((i-1)*2+1).type;
        end
    end
    
    fs = h.srate;
    
    seg = size(data,1);
    for i=1:seg
        L = min(length(data{i,1}),length(data{i,2}));
        subplot(1,seg,i)
        R = corrcoef([data{i,1}(:,1:L)' data{i,2}(:,1:L)']);
        imagesc(R(1:D,D+1:end)>0.99); colorbar
    end
    
    
    
    seg = size(data,1);
    for i=1:seg
        L = min(length(data{i,1}),length(data{i,2}));
        for j=1:2
            subplot(2,seg,(i-1)*2+j)
            [R,fbin] = pwelch(data{i,j}(:,1:L)',fs/2,[],[],fs);
            plot(fbin,db(R)); xlim([min(fbin) max(fbin)]);
            xlabel('Freq (Hz)')
            ylabel('Power (dB)')
            tmp = filenames{j,k}; tmp(tmp=='_')= ' ';
            title([tmp ': ' type{j,k}])
        end
    end

    saveas(gcf,[filenames{j,k}(1:end-3) 'png'])
    
end

