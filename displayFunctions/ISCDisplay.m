function [ISCfigure] = ISCDisplay(isc, w, a, isc_persub)

  ISCfigure = figure;
  for i=1:3
      subplot(2,3,i);
      topoplot(a(:,i),'newChanLocs.loc','electrodes','off'); title(['a_' num2str(i)])
  end
  subplot(2,2,[3,4]); notBoxPlot(isc_persub(1:3,:)'); xlabel('Component'); ylabel('ISC'); title('Per subjects');
end
