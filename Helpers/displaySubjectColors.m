function f = displaySubjectColors(numSubjects, colors, symbols, ids)

  f = figure;

  for i = 1:numSubjects

    rectangle('Position', [1 numSubjects-i 1 1], 'FaceColor', colors(i,:)); hold on;

    text(2.1, numSubjects-i+0.5, symbols(i), 'Color', colors(i,:));

    text(2.2, numSubjects-i+0.5, ['Subject ' num2str(ids(i))]);

  end

  xlim([1 3]);

  ylim([0 numSubjects])

  set(gca, 'xtick', [])

  set(gca, 'ytick', [])

  hold off

end
