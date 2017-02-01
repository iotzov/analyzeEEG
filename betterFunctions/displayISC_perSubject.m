function displayISC_perSubject(iscPerSub, subjects, referenceStatus, stimLabels, colors)
  % iscPerSub is the value returned by the multiISC function
  % subjects is a cell array of arrays of subject IDs (order should be same as subject order in corresponding EEG data volume)
  % referenceStatus is a cell of boolean arrays, 1 if subject is in reference group and 0 otherwise
  % stimLabels is a cell of strings representing names of the stimuli
  % colors is a struct of RGB colors, field names are == 'S' + subjectID

  Nstims = length(iscPerSub);
  averaged = {};

  for s = 1:Nstims

    for i = unique(subjects{s})

      z = find(subjects{s}==i);
      averaged{s} = [averaged{s} mean(sum(iscPerSub{s}(1:3,z)))];

    end

  end


  for i = 2:length(Nstims)
    for j = subjects{i-1}(referenceStatus)

      plot(i-1, averaged{i-1}, 'Color', colors.(['S' num2str(j)])); hold on;
      plot(i  ,   averaged{i}, 'Color', colors.(['S' num2str(j)])); hold on;
      plot(averaged{i-1}  ,   averaged{i}, 'Color', colors.(['S' num2str(j)])); hold on;
    end
  end

  xlim([0 Nstims+1]); xticks(1:Nstims); set(gca, 'xticklabel', stimLabels); set(get(gca,'XLabel'),'String','Group'); set(get(gca,'YLabel'),'String','Sum ISC');
  title('ISC Values')

end
