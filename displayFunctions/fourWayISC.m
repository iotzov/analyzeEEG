function fourWayISC(fwd, bwd, healthyIdx, patientIdx)

  f = figure;

  [isc, iscpersub, iscpersec, w, a] = iscNoDisplay_Segmented(fwd, healthyIdx, patientIdx);
  subplot(2,2,1); notBoxPlot(iscpersub(1:3, healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Fwd'); ylim([-.01 .1]);
  subplot(2,2,2); notBoxPlot(iscpersub(1:3, patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Fwd'); ylim([-.01 .1]);

  [isc, iscpersub, iscpersec, w, a] = iscNoDisplay_Segmented(bwd, healthyIdx, patientIdx);
  subplot(2,2,3); notBoxPlot(iscpersub(1:3, healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Healthy vs. Healthy - Bwd'); ylim([-.01 .1]);
  subplot(2,2,4); notBoxPlot(iscpersub(1:3, patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Patient vs. Healthy - Bwd'); ylim([-.01 .1]);

end
