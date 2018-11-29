function fig = plotBehaviorInfo(data, conditionNames, colors, markers, lineType)
%plotBehaviorInfo - Description
%
% Syntax: fig = plotBehaviorInfo(data, [conditionNames], [colors])
%
% Long description

% data - array of size MxN, will plot M points for each of N columns
% conditionNames - cell array of length N of condition names
% colors - Mx3 array of colors for each row in data
    
[M N] = size(data);

if nargin < 5
    lineType = '-';
end
if nargin < 4
    for i = 1:N
        markers{i} = 'o';
    end
end
if nargin < 3
    colors = jet;
end
if nargin < 2
    for i = 1:N
        conditionNames{i} = ['condition ' num2str(i)];
    end
end

fig = figure;

hold on;

for i = 1:M

    for j = 1:N

        plot(j, data(i,j), 'color', colors(i,:), 'marker', markers{j});

    end

    plot([1:N], data(i,:), 'color', colors(i,:));

end

xticks([1:N]);
xticklabels(conditionNames);

xlim([0.5 N+.5]);

end