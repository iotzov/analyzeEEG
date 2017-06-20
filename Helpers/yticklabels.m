function yticklabels(labels, a)
%xticks sets xticks

  if nargin < 2
    a = gca;
  end

  set(a, 'YTickLabel', labels);

end
