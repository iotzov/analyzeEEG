function xticks(ticks, a)
%xticks sets xticks

  if nargin < 2
    a = gca;
  end

  set(a, 'XTick', ticks);

end
