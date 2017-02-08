function [figHandle] = displayISC_perSubject(iscPerSub, subjects, referenceStatus, stimLabels, colors)
  % iscPerSub is the value returned by the multiISC function
  % subjects is a cell array of arrays of subject IDs (order should be same as subject order in corresponding EEG data volume)
  % referenceStatus is a cell of boolean arrays, 1 if subject is in reference group and 0 otherwise
  % stimLabels is a cell of strings representing names of the stimuli
  % colors is a struct of RGB colors, field names are == 'S' + subjectID



  Nstims = length(iscPerSub);
  averaged = {};

  for s = 1:Nstims

    temp = [];

    for i = unique(subjects{s})

      z = find(subjects{s}==i);
      temp = [temp mean(sum(iscPerSub{s}(1:2,z)))];

    end

    averaged{s} = temp;

  end

  plots = [];
  names = {};


  for i = 1:Nstims-1

    tsubs1 = unique(subjects{i});
    tsubs2 = unique(subjects{i+1});

    % Plot first group and connect with colored line
    for j = subjects{i}(referenceStatus{i})

      plots = [plots plot(i, averaged{i}(find(tsubs1==j)), 'Color', colors.(['s' num2str(j)]), 'Marker', 'o')]; hold on;
      plot(i+1,   averaged{i+1}(find(tsubs2==j)), 'Color', colors.(['s' num2str(j)]), 'Marker', 'o'); hold on;
      plot([i i+1], [averaged{i}(find(tsubs1==j)) averaged{i+1}(find(tsubs2==j))], 'Color', colors.(['s' num2str(j)]), 'LineStyle', '-'); hold on;
      names = [names ['H' num2str(j)]];

    end

    % Plot second group and connect with colored line
    for j = subjects{i}(~referenceStatus{i})

      plots = [plots plot(i+2, averaged{i}(find(tsubs1==j)), 'Color', colors.(['s' num2str(j)]), 'Marker', 'o')]; hold on;
      plot(i+3,   averaged{i+1}(find(tsubs2==j)), 'Color', colors.(['s' num2str(j)]), 'Marker', 'o'); hold on;
      plot([i+2 i+3], [averaged{i}(find(tsubs1==j)) averaged{i+1}(find(tsubs2==j))], 'Color', colors.(['s' num2str(j)]), 'LineStyle', '-'); hold on;
      names = [names ['P' num2str(j)]];

    end

  end

  xlim([0 Nstims+3]); set(gca,'XTick',1:Nstims*2); set(gca, 'xticklabel', [stimLabels stimLabels]); set(get(gca,'XLabel'),'String','Group'); set(get(gca,'YLabel'),'String','Sum ISC');
  title('ISC Values');
  %legend(plots, names, 'Location', 'eastoutside');

end
