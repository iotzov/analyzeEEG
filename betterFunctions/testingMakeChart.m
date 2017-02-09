function [chart] = testingMakeChart(results, stimNames, numComponents, a, numRuns)

  numStims = length(stimNames); numSubs = length(results);

  chart = figure;

  % Plot healthy
  subplot(1,2,1)

  temp = results([results.group]==1);

  for i = 1:length(temp)

    for j = 1:numStims

      if(temp(i).ISC{j})
        plot(j, mean(sum(temp(i).ISC{j}(1:numComponents,:))), 'Color', temp(i).color, 'Marker', 'o'); hold on;
        text(j+.1, mean(sum(temp(i).ISC{j}(1:numComponents,:))), num2str(temp(i).id), 'FontSize', 6, 'Color', temp(i).color)
      end

    end

    for j = 2:numStims

      if(~isempty(temp(i).ISC{j}) && ~isempty(temp(i).ISC{j-1}))
        plot([j-1 j], [mean(sum(temp(i).ISC{j-1}(1:numComponents,:))) mean(sum(temp(i).ISC{j}(1:numComponents,:)))], 'Color', temp(i).color, 'LineStyle', '-'); hold on;
      end

    end

  end

  title('ISC per Subject by Stimulus - Healthy'); set(get(gca,'YLabel'),'String','ISC'); set(get(gca,'XLabel'),'String','Stimulus');
  set(gca,'XTick',[1:numStims]); set(gca, 'XTickLabels', stimNames); xlim([0 numStims+1]); ylim([-0.02 0.08]);

  % Plot patient
  subplot(1,2,2)

  temp = results([results.group]==0);

  for i = 1:length(temp)

    for j = 1:numStims

      if(temp(i).ISC{j})
        plot(j, mean(sum(temp(i).ISC{j}(1:numComponents,:))), 'Color', temp(i).color, 'Marker', 'o'); hold on;
        text(j+.1, mean(sum(temp(i).ISC{j}(1:numComponents,:))), num2str(temp(i).id), 'FontSize', 6, 'Color', temp(i).color)
      end

    end

    for j = 2:numStims

      if(~isempty(temp(i).ISC{j}) && ~isempty(temp(i).ISC{j-1}))
        plot([j-1 j], [mean(sum(temp(i).ISC{j-1}(1:numComponents,:))) mean(sum(temp(i).ISC{j}(1:numComponents,:)))], 'Color', temp(i).color, 'LineStyle', '-'); hold on;
      end

    end

  end

  title('ISC per Subject by Stimulus - Patient'); set(get(gca,'YLabel'),'String','ISC'); set(get(gca,'XLabel'),'String','Stimulus');
  set(gca,'XTick',[1:numStims]); set(gca, 'XTickLabels', stimNames); xlim([0 numStims+1]); ylim([-0.02 0.08]);

  set(gcf, 'Position', get(0,'Screensize')); % maximize figure
  saveas(gcf, ['aliceResults run1 thru ' num2str(numRuns)], 'jpeg')
  close

  figure

  for i = 1:numComponents
    subplot(3,2,i*2);
    topoplot(a(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
  end

  saveas(gcf, ['aliceResults run1 thru ' num2str(numRuns) ' projections'], 'jpeg')
  close


end
