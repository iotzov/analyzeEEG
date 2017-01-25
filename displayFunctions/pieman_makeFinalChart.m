%[b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
%load /home/ivan/Documents/ResearchDocs/pieman_isc/preprocessedv2.mat
%good = [piemanInfo.dataQuality]>0;
%piemanInfo = piemanInfo(good);
%piemandata = piemandata(good);

%for i = 1:33
%  piemandata(i).fwd = piemandata(i).fwd(:, 1:37);
%  piemandata(i).bwd = piemandata(i).bwd(:, 1:37);
%  piemandata(i).scram = piemandata(i).scram(:, 1:37);
%end

results = iscNoDisplaySegmented_pieman(structToVolume(piemandata, 1:32, 1), structToVolume(piemandata, 1:32, 0), structToVolume(piemandata, 1:32, 2), 1:12, 13:32);


% displayFinalFourWay(results)

%{averagedfwd = []; averagedbwd=[]; group=[];

%for i=unique(results.subs)

%  z=find(results.subs==i);
%  averagedfwd = [averagedfwd mean(sum(results.iscpersub_f(1:3,z)))];
%  averagedbwd = [averagedbwd mean(sum(results.iscpersub_b(1:3,z)))];
%  group = [group i<300];

%end

%results.averagedfwd = averagedfwd;
%results.averagedbwd = averagedbwd;

%}

sumf = [];
sumb = [];
sums = [];

for i = 1:32
  sumf = [sumf sum(results.persub_f(1:3,i))];
  sumb = [sumb sum(results.persub_b(1:3,i))];
  sums = [sums sum(results.persub_s(1:3,i))];
end

results.persub_s = sums;
results.persub_b = sumb;
results.persub_f = sumf;

subplot(1,2,1)
% plot fwd
for i = 1:13
  plot( 1, results.persub_b(i),'og'); hold on
  plot( 2, results.persub_f(i),'*r'); hold on
  plot( 3, results.persub_s(i),'+b'); hold on
  plot([1 2], [results.persub_b(i) results.persub_f(i)],'-k'); hold on
  plot([2 3], [results.persub_f(i) results.persub_s(i)],'-k'); hold on
end

% plot bwd
for i=14:32
  plot( 4, results.persub_b(i),'og'); hold on
  plot( 5, results.persub_f(i),'*r'); hold on
  plot( 6, results.persub_s(i),'+b'); hold on
  plot([4 5], [results.persub_b(i) results.persub_f(i)],'-k'); hold on
  plot([5 6], [results.persub_f(i) results.persub_s(i)],'-k'); hold on
end

xlim([0  7])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
xticks([2 5]); set(gca,'xticklabel',{'Control' 'Patient'}); legend('Forward', 'Backward', 'Scrambled');
  xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

  %f2 = figure;

  for i = 1:3
    subplot(3,2,i*2);
    topoplot(results.A_f(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
  end

%[h,p1]=ttest(results.averagedfwd);
[h,p2]=ttest2(results.persub_f(1:13), results.persub_f(14:end));
[h,p3]=ttest2(results.persub_b(1:14), results.persub_b(14:end));
[h,p8]=ttest2(results.persub_s(1:14), results.persub_s(14:end));
[h,p5]=ttest2([results.persub_f(1:13)+results.persub_b(1:13)+results.persub_s(1:13)], [results.persub_f(14:end)+results.persub_b(14:end)+results.persub_s(14:end)]);
[h,p6]= ttest(results.persub_f(1:13) - results.persub_b(1:13));
[h,p7]= ttest(results.persub_f(14:end) - results.persub_b(14:end));
[h,p9]= ttest(results.persub_f(14:end) - results.persub_s(14:end));
subplot(1,2,1)
sigstar({[2 5] [1 4] [1 6] [1 2] [4 5] [3 6] [5 6]}, [p2 p3 p5 p6 p7 p8 p9])
legend('Backward', 'Forward', 'Scrambled', 'Location', 'southwest')
