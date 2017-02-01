%datapath = 'C:\Users\ivan\Documents\LucasResearch\minConData\'; % Include trailing '/'!
%load [datapath colors.mat];

[isc, iscpersub_f, iscpersub_b, w, a, af, ab] = iscNoDisplaySegmented_FwdAndBwd_separateA(structToVolume(eeg, 1:length(eeg), 1), structToVolume(eeg, 1:length(eeg), 0), find([dataInfo.healthy]==1), find([dataInfo.healthy]==0));

results.isc = isc;
results.iscpersub_f = iscpersub_f;
results.iscpersub_b = iscpersub_b;
results.w = w;
results.a = a;
results.af = af;
results.ab = ab;
results.subs = [dataInfo.subj];

f = figure;

subs = results.subs;
s = unique(subs);

averagedfwd = []; averagedbwd = []; group = [];

for i=s

  z=find(subs==i);
  averagedfwd = [averagedfwd mean(sum(results.iscpersub_f(1:3,z)))];
  averagedbwd = [averagedbwd mean(sum(results.iscpersub_b(1:3,z)))];
  group = [group i<300];

end

results.averagedfwd = averagedfwd;
results.averagedbwd = averagedbwd;

clf

subplot(1,2,1)
% plot fwd

subjectPlots = [];
subjectNames = {};

for i = 1:13
  subjectPlots = [subjectPlots plot( 1, averagedfwd(i),'Marker', 'o', 'Color', colorstruct.(['s' num2str(s(i))]), 'DisplayName', ['H' num2str(s(i))])]; hold on
  plot( 2, averagedbwd(i),'Marker', '*', 'Color', colorstruct.(['s' num2str(s(i))])); hold on
  plot([1 2], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
  subjectNames = [subjectNames ['H' num2str(s(i))]];
end

% plot bwd
for i=14:length(averagedfwd)
  subjectPlots = [subjectPlots plot( 3, averagedfwd(i),'Marker', 'o', 'Color', colorstruct.(['s' num2str(s(i))]), 'DisplayName', ['P' num2str(s(i))])]; hold on
  plot( 4, averagedbwd(i),'Marker', '*', 'Color', colorstruct.(['s' num2str(s(i))])); hold on
  plot([3 4], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
  subjectNames = [subjectNames ['P' num2str(s(i))]];
end

xlim([0  5])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
% xticks([1.5 3.5]);

set(gca, 'XTick', [1.5 3.5]); set(gca,'xticklabel',{'Control' 'Patient'});
xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

for i = 1:3
  subplot(3,2,i*2);
  topoplot(results.af(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
end

for i = 4:6
  %  subplot(2,3,i);
  %  topoplot(results.ab(:,i-3),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
end

[h,p1]=ttest2(results.averagedfwd(1:13), results.averagedfwd(14:end));
[h,p2]=ttest2(results.averagedbwd(1:14), results.averagedbwd(14:end));
[h,p3]=ttest2([results.averagedfwd(1:13)+results.averagedbwd(1:13)], [results.averagedfwd(14:end)+results.averagedbwd(14:end)]);
[h,p4] = ttest(results.averagedfwd(1:13) - results.averagedbwd(1:13));
[h,p5] = ttest(results.averagedfwd(14:end) - results.averagedbwd(14:end));
subplot(1,2,1)
sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p1 p2 p3 p4 p5])
% legend('show', 'Location', 'southwest')
legend(subjectPlots, subjectNames);
