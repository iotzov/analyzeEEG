function f = displaySubjectColors(numSubjects, colors, symbols, ids)

  if(isempty(symbols))
      symbols = repmat('*',[1 numSubjects]);
  end
  
  if(isempty(ids))
      ids = 1:numSubjects;
  end

  f = figure;

  for i = 1:numSubjects

    rectangle('Position', [1 numSubjects-i 1 1], 'FaceColor', colors(i,:)); hold on;

    text(2.1, numSubjects-i+0.5, symbols(i), 'Color', colors(i,:), 'FontSize', 15);
%     plot([2.05 2.15], [numSubjects-i+0.5 numSubjects-i+0.5], 'Color', colors(i,:)); hold on;

%     if(ids(i) < 300)
%         text(2.2, numSubjects-i+0.5, ['Control ' num2str(ids(i))]);
%     else
%         text(2.2, numSubjects-i+0.5, ['Patient ' num2str(ids(i))]);
%     end

    text(2.2, numSubjects-i+0.5, num2str(ids(i)));

  end

  xlim([1 2.4]);

  ylim([0 numSubjects])

  set(gca, 'xtick', [])

  set(gca, 'ytick', [])

  hold off

end
