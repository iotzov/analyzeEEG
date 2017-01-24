%[b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
load C:\Users\ivan\Documents\LucasResearch\minConData\preprocessedv2_pieman.mat
good = [piemanInfo.dataQuality]>0;
piemanInfo = piemanInfo(good);
piemandata = piemandata(good);
results = separated_pieman_isc(structToVolume(piemandata, 1:33, 1), structToVolume(piemandata, 1:33, 0), structToVolume(piemandata, 1:33, 2), 1:13, 14:33);

% FWD - BWD figure

f = figure;

subplot(1,2,1)
% plot fwd
for i = 1:13
plot( 1, results.persub_Wfb_f(i),'og'); hold on
plot( 2, results.persub_Wfb_b(i),'*r'); hold on
plot([1 2], [results.persub_Wfb_f(i) results.persub_Wfb_b(i)],'-k'); hold on
end

% plot bwd
for i=14:33
plot( 3, results.persub_Wfb_f(i),'og'); hold on
plot( 4, results.persub_Wfb_b(i),'*r'); hold on
plot([3 4], [results.persub_Wfb_f(i) results.persub_Wfb_b(i)],'-k'); hold on
end

xlim([0  5])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
set(gca, 'XTick', [1.5 3.5]); set(gca,'xticklabel',{'Control' 'Patient'}); legend('Forward', 'Backward');
xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

%f2 = figure;

for i = 1:3
  subplot(3,2,i*2);
  topoplot(results.A_fb(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
end

[h,p2]=ttest2(results.persub_Wfb_f(1:13), results.persub_Wfb_f(14:end));
[h,p3]=ttest2(results.persub_Wfb_b(1:14), results.persub_Wfb_b(14:end));
[h,p5]=ttest2([results.persub_Wfb_f(1:13)+results.persub_Wfb_b(1:13)], [results.persub_Wfb_f(14:end)+results.persub_Wfb_b(14:end)]);
[h, p6] = ttest(results.persub_Wfb_f(1:13) - results.persub_Wfb_b(1:13));
[h, p7] = ttest(results.persub_Wfb_f(14:end) - results.persub_Wfb_b(14:end));
subplot(1,2,1)
sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p2 p3 p5 p6 p7])
legend('Forward', 'Backward', 'Location', 'southwest')

% FWD - SCRAM figure

f2 = figure;

subplot(1,2,1)
% plot fwd
for i = 1:13
plot( 1, results.persub_Wfs_f(i),'og'); hold on
plot( 2, results.persub_Wfs_s(i),'*r'); hold on
plot([1 2], [results.persub_Wfs_f(i) results.persub_Wfs_s(i)],'-k'); hold on
end

% plot bwd
for i=14:33
plot( 3, results.persub_Wfs_f(i),'og'); hold on
plot( 4, results.persub_Wfs_s(i),'*r'); hold on
plot([3 4], [results.persub_Wfs_f(i) results.persub_Wfs_s(i)],'-k'); hold on
end

xlim([0  5])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
set(gca, 'XTick', [1.5 3.5]); set(gca,'xticklabel',{'Control' 'Patient'}); legend('Forward', 'Scrambled');
xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

%f2 = figure;

for i = 1:3
  subplot(3,2,i*2);
  topoplot(results.A_fs(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
end

[h,p2]=ttest2(results.persub_Wfs_f(1:13), results.persub_Wfs_f(14:end));
[h,p3]=ttest2(results.persub_Wfs_s(1:14), results.persub_Wfs_s(14:end));
[h,p5]=ttest2([results.persub_Wfs_f(1:13)+results.persub_Wfs_s(1:13)], [results.persub_Wfs_f(14:end)+results.persub_Wfs_s(14:end)]);
[h, p6] = ttest(results.persub_Wfs_f(1:13) - results.persub_Wfs_s(1:13));
[h, p7] = ttest(results.persub_Wfs_f(14:end) - results.persub_Wfs_s(14:end));
subplot(1,2,1)
sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p2 p3 p5 p6 p7])
legend('Forward', 'Scrambled', 'Location', 'southwest')
