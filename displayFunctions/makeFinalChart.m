%[b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
load ../../minConsciousEEG/processedDataWithInfo.mat
[isc, iscpersub_f, iscpersub_b, w, a, af, ab] = iscNoDisplaySegmented_FwdAndBwd_separateA(structToVolume(eeg, 1:85, 1), structToVolume(eeg, 1:85, 0), 1:43, 44:85);

results.isc = isc;
results.iscpersub_f = iscpersub_f;
results.iscpersub_b = iscpersub_b;
results.w = w;
results.a = a;
results.af = af;
results.ab = ab;
results.subs = [dataInfo.subj];

displayFinalFourWay(results)

averagedfwd = []; averagedbwd=[]; group=[];

for i=unique(results.subs)

  z=find(results.subs==i);
  averagedfwd = [averagedfwd mean(sum(results.iscpersub_f(1:3,z)))];
  averagedbwd = [averagedbwd mean(sum(results.iscpersub_b(1:3,z)))];
  group = [group i<300];

end

results.averagedfwd = averagedfwd;
results.averagedbwd = averagedbwd;

%[h,p1]=ttest(results.averagedfwd);
[h,p2]=ttest2(results.averagedfwd(1:13), results.averagedfwd(14:end));
[h,p3]=ttest2(results.averagedbwd(1:14), results.averagedbwd(14:end));
[h,p5]=ttest2([results.averagedfwd(1:13)+results.averagedbwd(1:13)], [results.averagedfwd(14:end)+results.averagedbwd(14:end)]);
[h, p6] = ttest(results.averagedfwd(1:13) - results.averagedbwd(1:13));
[h, p7] = ttest(results.averagedfwd(14:end) - results.averagedbwd(14:end));
subplot(1,2,1)
sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p2 p3 p5 p6 p7])
legend('Forward', 'Backward', 'Location', 'southwest')
