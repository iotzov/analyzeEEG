function [results] = fourWayISC_runAveraged_sameW(fwd, bwd, healthyIdx, patientIdx, dataInfo)

  f = figure;

  %[b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
  [isc, iscpersub_f, iscpersub_b, w, a, af, ab] = iscNoDisplaySegmented_FwdAndBwd_separateA(fwd, bwd, healthyIdx, patientIdx);

  results.isc = isc;
  results.iscpersub_f = iscpersub_f;
  results.iscpersub_b = iscpersub_b;
  results.w = w;
  results.a = a;
  results.af = af;
  results.ab = ab;

  subs = [dataInfo.subj];
  results.subs = subs;
  averagedfwd = []; averagedbwd=[]; group=[];

  for i=unique(subs)

    z=find(subs==i);
    averagedfwd = [averagedfwd mean(sum(iscpersub_f(2,z)))];
    averagedbwd = [averagedbwd mean(sum(iscpersub_b(2,z)))];
    group = [group i<300];

  end

  results.averagedfwd = averagedfwd;
  results.averagedbwd = averagedbwd;

  clf

% plot fwd
for i = 1:13
  plot( 1, averagedfwd(i),'og'); hold on
  plot( 2, averagedbwd(i),'*r'); hold on
  plot([1 2], [averagedfwd(i) averagedbwd(i)],'-'); hold on
end

% plot bwd
for i=14:length(averagedfwd)
  plot( 3, averagedfwd(i),'og'); hold on
  plot( 4, averagedbwd(i),'*r'); hold on
  plot([3 4], [averagedfwd(i) averagedbwd(i)],'-'); hold on
end

%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
  set(gca,'xticklabel',{'Control, Fwd', 'Control, Bkw', 'Patient, Fwd', 'Patient, Bkw'});
  xlabel('Group'); ylabel('Sum ISC'); title('Forward and Backward ISC Values - Same Components'); ylim([-.01 .07]);

  f2 = figure;

  for i = 1:3
    subplot(2,3,i);
    topoplot(af(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) '-Fwd'])
  end

  for i = 4:6
    subplot(2,3,i);
    topoplot(ab(:,i-3),'test.loc','electrodes','off'); title(['Component ' num2str(i-3) '-Bwd'])
  end




end
