function fourWayISC(fwd, bwd, healthyIdx, patientIdx)

  f = figure;

  [b_isc, b_iscpersub, b_iscpersec, b_w, b_a] = iscNoDisplay_Segmented(bwd, healthyIdx, patientIdx);
  [isc, iscpersub, iscpersec, w, a] = iscNoDisplay_Segmented(fwd, healthyIdx, patientIdx);

  subplot(2,2,3); notBoxPlot(b_iscpersub(1:3, healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Bwd'); ylim([-.01 .1]);
  subplot(2,2,4); notBoxPlot(b_iscpersub(1:3, patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Bwd'); ylim([-.01 .1]);

  subplot(2,2,1); notBoxPlot(iscpersub(1:3, healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Fwd'); ylim([-.01 .1]);
  subplot(2,2,2); notBoxPlot(iscpersub(1:3, patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Fwd'); ylim([-.01 .1]);

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
