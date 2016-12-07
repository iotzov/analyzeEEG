function fourWayISC(fwd, bwd, healthyIdx, patientIdx, dataInfo)

  f = figure;

  [b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplay_Segmented(bwd, healthyIdx, patientIdx);
  [isc, iscpersub, iscpersec, w, a] = iscNoDisplay_Segmented(fwd, healthyIdx, patientIdx);

  subs = [dataInfo.subj];
  averagedfwd = []; averagedbwd=[];

  for i=unique(subs)

    z=find(subs==i);
    averagedfwd = [averagedfwd mean(sum(iscpersub(1:3,z)))];
    averagedbwd = [averagedbwd mean(sum(b_iscpersub(1:3,z)))];

  end

  clf

  subplot(2,2,3); notBoxPlot(averagedbwd(1:13)); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Bwd'); ylim([-.01 .07]);
  subplot(2,2,4); notBoxPlot(averagedbwd(14:end)); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Bwd'); ylim([-.01 .07]);


  subplot(2,2,1); notBoxPlot(averagedfwd(1:13)); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Fwd'); ylim([-.01 .07]);
  subplot(2,2,2); notBoxPlot(averagedfwd(14:end)); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Fwd'); ylim([-.01 .07]);

  f2 = figure;

  for i = 1:3
    subplot(2,3,i);
    topoplot(a(:,i),'test.loc','electrodes','off'); title(['a_' num2str(i) '-Fwd'])
  end

  for i = 4:6
    subplot(2,3,i);
    topoplot(b_a(:,i),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
  end




end
