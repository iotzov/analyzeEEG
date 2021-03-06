function newMakeChart(subjects, a)

figure;

subplot(1,2,1)

% Healthy Subjects section

temp = subjects([subjects.healthy]);

for i = 1:length(temp)
  for j = 1:length(temp(1).runs(1).stimNames)
    meanisc = temp(i).getMeanISC(j);
    plot(j, meanisc, 'Color', temp(i).color, 'Marker', 'o'); hold on;
    text(j+.1, meanisc, num2str(temp(i).id), 'FontSize', 6, 'Color', temp(i).color)
    healthyISC(i,j) = meanisc;
  end
	for j = 2:length(temp(1).runs(1).stimNames)
		meanisc1 = temp(i).getMeanISC(j-1);
		meanisc2 = temp(i).getMeanISC(j);
		plot([j-1 j], [meanisc1 meanisc2], 'Color', temp(i).color, 'LineStyle', '-'); hold on;
	end
end

[h, p] = ttest(healthyISC(:,1), healthyISC(:,2));
sigstar({[1 2]}, p)

title('ISC per Subject by Stimulus - Healthy');
set(get(gca,'YLabel'),'String','ISC');
set(get(gca,'XLabel'),'String','Stimulus');
set(gca,'XTick',[1:length(temp(1).runs(1).stimNames)]);
set(gca, 'XTickLabels', temp(1).runs(1).stimNames);
xlim([0 length(temp(1).runs(1).stimNames)+1]);
ylim([-0.04 0.2]);

% Patient Subjects section

subplot(1,2,2)

temp = subjects(~[subjects.healthy]);

if(~isempty(temp))
for i = 1:length(temp)
  for j = 1:length(temp(1).runs(1).stimNames)
    meanisc = temp(i).getMeanISC(j);
    plot(j, meanisc, 'Color', temp(i).color, 'Marker', 'o'); hold on;
    text(j+.1, meanisc, num2str(temp(i).id), 'FontSize', 6, 'Color', temp(i).color)
    patientISC(i,j) = meanisc;
  end
	for j = 2:length(temp(1).runs(1).stimNames)
                meanisc1 = temp(i).getMeanISC(j-1);
                meanisc2 = temp(i).getMeanISC(j);
                plot([j-1 j], [meanisc1 meanisc2], 'Color', temp(i).color, 'LineStyle', '-'); hold on;
        end

end

[h, p] = ttest(patientISC(:,1), patientISC(:,2));
sigstar({[1 2]}, p)

title('ISC per Subject by Stimulus - Patient');
set(get(gca,'YLabel'),'String','ISC');
set(get(gca,'XLabel'),'String','Stimulus');
set(gca,'XTick',[1:length(temp(1).runs(1).stimNames)]);
set(gca, 'XTickLabels', temp(1).runs(1).stimNames);
xlim([0 length(temp(1).runs(1).stimNames)+1]);
ylim([-0.04 0.2]);

[h p] = ttest2(healthyISC(:,1), patientISC(:,1))
title(['Healthy FWD vs Patient FWD, p= ' num2str(p)])

else
  temp = subjects([subjects.healthy]);
  title('no patients')
end


%figure;
%
%for i = 1:3
%  subplot(3,1,i)
%  topoplot(a(:,i), temp(1).runs(1).chanlocs(1:37), 'electrodes', 'off'); title(['Component' num2str(i)]);
%end
