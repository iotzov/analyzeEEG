function [resultsF, resultsB] = fourWayISC_runAveraged_LP(fwd, bwd, healthyIdx, patientIdx, dataInfo)

  f = figure;
  resultsB=struct();
  resultsF=struct();


  [b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplay_Segmented(bwd, healthyIdx, patientIdx);
  [isc, iscpersub, iscpersec, w, a] = iscNoDisplay_Segmented(fwd, healthyIdx, patientIdx);

  resultsB.isc = b_isc;
  resultsB.iscpersub = b_iscpersub;
  resultsB.iscpersec = b_iscpersec;
  resultsB.w = b_w;
  resultsB.a = b_a;

  
  resultsF.isc = isc;
  resultsF.iscpersub = iscpersub;
  resultsF.iscpersec = iscpersec;
  resultsF.w = w;
  resultsF.a = a;

  subs = [dataInfo.subj];
  averagedfwd = []; averagedbwd=[]; group=[];

  for i=unique(subs)

    z=find(subs==i);
    averagedfwd = [averagedfwd mean(sum(iscpersub(1:3,z)))];
    averagedbwd = [averagedbwd mean(sum(b_iscpersub(1:3,z)))];
    group = [group i<300];

  end

  clf

  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
  set(gca,'xticklabel',{'Control, Fwd', 'Control, Bkw', 'Patient, Fwd', 'Patient, Bkw'});
  xlabel('Group'); ylabel('ISC'); title('ISC values'); ylim([-.01 .07]);

  f2 = figure;

  for i = 1:3
    subplot(2,3,i);
    topoplot(a(:,i),'test.loc','electrodes','off'); title(['a_' num2str(i) '-Fwd'])
  end

  for i = 4:6
    subplot(2,3,i);
    topoplot(b_a(:,i-3),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
  end




end
