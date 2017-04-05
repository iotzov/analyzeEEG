function [subjects results] = subjectMultiStimISC(subjects, stimIDs)

  for i = 1:length(stimIDs)

    order{i} = [];
    data{i} = [];
    refs{i} = [];

    for j = 1:length(subjects)

      temp = subjects(j).volumize(stimIDs(i));
      if(~isempty(temp))
        data{i} = cat(3, data{i}, temp);
        order{i} = [order{i} repmat(subjects(j).id, 1, size(temp, 3))];
      end

    end

    refs{i} = find(order{i}<300);

  end

  temp = struct();

  [results.isc results.persub results.w results.a] = multiStimISC(data, refs, subjects(1).runs(1).fs);

  for j = 1:length(subjects)

    for i = 1:length(stimIDs)

      f = find(order{i}==subjects(j).id);
      subjects(j).ISC{i} = results.persub{i}(:,f);

    end

  end

end
