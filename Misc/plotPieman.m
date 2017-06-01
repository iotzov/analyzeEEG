% options

load colors.mat

fontSize = 14;

fwdMarker = 'o';
bwdMarker = '*';

piemanChart = figure;

for i = 1:length(pieman)

    values(i, 1) = mean(sum(pieman(i).ISC{3}(1:3,:), 1), 2); % fwd
    values(i, 2) = mean(sum(pieman(i).ISC{1}(1:3,:), 1), 2); % bwd
    values(i, 3) = mean(sum(pieman(i).ISC{2}(1:3,:), 1), 2); % scr

    pieman(i).color = colors(i, :);

end

for i = 1:length(pieman)

    if(pieman(i).healthy)

        plot(0.5, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
        plot(1.0, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
        plot(1.5, values(i, 2), 'Marker', bwdMarker, 'Color', pieman(i).color); hold on;
        plot([0.5 1.0 1.5], [values(i, 1) values(i, 2) values(i, 3)], 'Color', pieman(i).color); hold on;

    else

        plot(2.5, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
        plot(3.0, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
        plot(3.5, values(i, 2), 'Marker', bwdMarker, 'Color', pieman(i).color); hold on;
        plot([2.5 2.0 3.5], [values(i, 1) values(i, 2) values(i, 3)], 'Color', pieman(i).color); hold on;

    end

end

xlim([0 4])
ylabel('ISC')

xticks([1 3])
xticklabels({'Healthy' 'Patient'})
ylim([-.01 .04])
title('Individual Subject ISC')
set(gcf, 'Position', [-1852 255 762 719])
set(findall(gcf,'-property','FontSize'),'FontSize',fontSize)
set(findall(gcf,'-property','FontName'),'FontName', 'Helvetica')

piemanBar = figure;

bar(1, mean(values([pieman.healthy], 1)), 'FaceColor', [91 204 42]/255); hold on;   % healthy - fwd
bar(2, mean(values([pieman.healthy], 2)), 'FaceColor', [219 26 26]/255); hold on;   % healthy - bwd
bar(3, mean(values([pieman.healthy], 3)), 'FaceColor', [219 26 26]/255); hold on;   % healthy - scr
bar(5, mean(values(~[pieman.healthy], 1)), 'FaceColor', [91 204 42]/255); hold on;  % patient - fwd
bar(6, mean(values(~[pieman.healthy], 2)), 'FaceColor', [219 26 26]/255); hold on;  % patient - bwd
bar(7, mean(values(~[pieman.healthy], 3)), 'FaceColor', [219 26 26]/255); hold on;   % healthy - bwd

xticks([2 6])
xticklabels({'Healthy' 'Patient'})
legend('Forward', 'Backward')
legend boxoff
set(findall(gcf,'-property','FontSize'),'FontSize', fontSize)
set(findall(gcf,'-property','FontName'),'FontName', 'Helvetica')
set(gcf, 'Position', [-1728 191 687 692])

% [h1 p1] = ttest(values([pieman.healthy], 1), values([pieman.healthy], 2));
% [h2 p2] = ttest(values(~[pieman.healthy], 1), values(~[pieman.healthy], 2));

% sigstar({[1 2] [4 5]}, [p1 p2])

topoplots = figure;

for i = 1:3

%     subplot(3, 1, i);
    subplot(1,3,i);
    topoplot(result.a(:,i), pieman(1).runs(1).chanlocs, 'electrodes', 'off')
    title(['Component ' num2str(i)]);

end

colormap(cbrewer('div', 'Spectral', 30));
set(gcf, 'Position', [-1508 464 1093 298]);

% aliceChartAndBar = figure;
% 
% xlim([0 6])
% ylabel('ISC')
% ylim([-.01 .04])
% set(gcf, 'Position', [-1852 255 762 719])
% 
% a1 = bar(1, mean(values([pieman.healthy], 1)), 'FaceColor', [91 204 42]/255); hold on;   % healthy - fwd
% a2 = bar(2, mean(values([pieman.healthy], 2)), 'FaceColor', [219 26 26]/255); hold on;   % healthy - bwd
% a3 = bar(4, mean(values(~[pieman.healthy], 1)), 'FaceColor', [91 204 42]/255); hold on;  % patient - fwd
% a4 = bar(5, mean(values(~[pieman.healthy], 2)), 'FaceColor', [219 26 26]/255); hold on;  % patient - bwd
% 
% for i = 1:length(pieman)
% 
%     values(i, 1) = mean(sum(pieman(i).ISC{1}(1:3,:), 1), 2); % fwd
%     values(i, 2) = mean(sum(pieman(i).ISC{2}(1:3,:), 1), 2); % bwd
% 
% end
% 
% for i = 1:length(pieman)
% 
%     if(pieman(i).healthy)
% 
%         plot(1, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
%         plot(2, values(i, 2), 'Marker', bwdMarker, 'Color', pieman(i).color); hold on;
%         plot([1 2], [values(i, 1) values(i, 2)], 'Color', pieman(i).color); hold on;
% 
%     else
% 
%         plot(4, values(i, 1), 'Marker', fwdMarker, 'Color', pieman(i).color); hold on;
%         plot(5, values(i, 2), 'Marker', bwdMarker, 'Color', pieman(i).color); hold on;
%         plot([4 5], [values(i, 1) values(i, 2)], 'Color', pieman(i).color); hold on;
% 
%     end
% 
% end
% 
% xticks([1.5 4.5])
% xticklabels({'Healthy' 'Patient'})
% set(gcf, 'Position', [-1478 191 631 693])
% set(findall(gcf,'-property','FontSize'),'FontSize', fontSize)
% ylim([-.01 .04])
% 
% saveas(aliceBar, 'Alice_Bar.svg')
% saveas(aliceChart, 'Alice_Chart.svg')
% saveas(aliceChartAndBar, 'Alice_ChartAndBar.svg')
% saveas(topoplots, 'Alice_topoplots.svg')
% close all
