function xticklabels(labels, a)
%xticks sets xticks

  if nargin < 2
    a = gca;
  end

  set(a, 'XTickLabel', labels);

end
