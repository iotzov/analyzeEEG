function fourWayISC_runAveraged_sameW(fwd, bwd, healthyIdx, patientIdx, dataInfo)

  f = figure;

  %[b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
  [isc, iscpersub_f, iscpersub_b, w, a] = iscNoDisplaySegmented_FwdAndBwd(fwd, bwd, healthyIdx, patientIdx);

  subs = [dataInfo.subj];
  averagedfwd = []; averagedbwd=[]; group=[];

  for i=unique(subs)

    z=find(subs==i);
    averagedfwd = [averagedfwd mean(sum(iscpersub_f(1:3,z)))];
    averagedbwd = [averagedbwd mean(sum(iscpersub_b(1:3,z)))];
    group = [group i<300];

  end

  clf

  notBoxPlot([averagedfwd(1:13)',[averagedfwd(14:end) 0]', averagedbwd(1:13)', [averagedbwd(14:end) 0]']); legend;
  set(gca,'xticklabel',{'Control, Fwd', 'Patient, Fwd', 'Control, Bkw', 'Patient, Bkw'});
  xlabel('Group'); ylabel('ISC'); title('ISC values'); ylim([-.01 .07]);

  f2 = figure;

  for i = 1:3
    subplot(2,3,i);
    topoplot(a(:,i),'test.loc','electrodes','off'); title(['a_' num2str(i) '-Fwd'])
  end

  for i = 4:6
    subplot(2,3,i);
    topoplot(a(:,i-3),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
  end




end
