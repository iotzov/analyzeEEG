function displayFinalFourWay(resultStruct)

  f = figure;

%  [b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplaySegmented_FwdAndBwd(bwd, healthyIdx, patientIdx);
%  [isc, iscpersub_f, iscpersub_b, w, a, af, ab] = iscNoDisplaySegmented_FwdAndBwd_separateA(fwd, bwd, healthyIdx, patientIdx);

%  results.isc = isc;
%  results.iscpersub_f = iscpersub_f;
%  results.iscpersub_b = iscpersub_b;
%  results.w = w;
%  results.a = a;
%  results.af = af;
%  results.ab = ab;

  subs = resultStruct.subs;

  averagedfwd = []; averagedbwd=[]; group=[];

  for i=unique(subs)

    z=find(subs==i);
    averagedfwd = [averagedfwd mean(sum(resultStruct.iscpersub_f(1:3,z)))];
    averagedbwd = [averagedbwd mean(sum(resultStruct.iscpersub_b(1:3,z)))];
    group = [group i<300];

  end

  clf

subplot(1,2,1)
% plot fwd
for i = 1:13
  plot( 1, averagedfwd(i),'og'); hold on
  plot( 2, averagedbwd(i),'*r'); hold on
  plot([1 2], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
end

% plot bwd
for i=14:length(averagedfwd)
  plot( 3, averagedfwd(i),'og'); hold on
  plot( 4, averagedbwd(i),'*r'); hold on
  plot([3 4], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
end

xlim([0  5])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
xticks([1.5 3.5]); set(gca,'xticklabel',{'Control' 'Patient'}); legend('Forward', 'Backward');
  xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

  %f2 = figure;

  for i = 1:3
    subplot(3,2,i*2);
    topoplot(resultStruct.af(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
  end

  for i = 4:6
  %  subplot(2,3,i);
  %  topoplot(resultStruct.ab(:,i-3),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
  end




end
