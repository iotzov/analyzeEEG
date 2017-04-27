classdef Processor

  properties
    subjects
    isc
    persub
    w
    a
  end

  methods
    function obj = preprocess(obj)
      for i = 1:length(obj.subjects)
        obj.subjects(i) = obj.subjects(i).preprocess();
      end
    end

    function obj = runISC(obj)
      fwd = []; bwd = []; r = [obj.subjects]; r = [r.runs]; r = find([r.subject]<300);
      for i = 1:length(obj.subjects)
        fwd = cat(3, fwd, obj.subjects(i).volumize(1));
        bwd = cat(3, bwd, obj.subjects(i).volumize(2));
      end
      [obj.isc obj.persub obj.w obj.a] = multiStimISC({fwd bwd}, {r r}, 250);
    end

    function chart = makeChart(obj)
      chart = figure;
      numComps = 3;

      % Plot healthy stuff

      subplot(2,6,[1,3])
      s = [obj.subjects.id];
      r = [obj.subjects.runs]; r = [r.subject];

      s = s(s<300);

      for i = 1:length(s)
        for j = 1:length(obj.persub)
          plot(j, mean(sum(obj.persub{j}(1:numComps,r==s(i)))), 'Color', obj.subjects(i).color, 'Marker', 'o'); hold on;
          text(j+.1, mean(sum(obj.persub{j}(1:numComps,r==s(i)))), num2str(obj.subjects(i).id), 'FontSize', 6, 'Color', obj.subjects(i).color)
        end

        for j = 2:length(obj.persub)
          plot([j-1 j], [mean(sum(obj.persub{j-1}(1:numComps,r==s(i)))) mean(sum(obj.persub{j}(1:numComps,r==s(i))))], 'Color', obj.subjects(i).color, 'LineStyle', '-'); hold on;
        end
      end

      title('ISC per Subject by Stimulus - Healthy'); set(get(gca,'YLabel'),'String','ISC'); set(get(gca,'XLabel'),'String','Stimulus');
      set(gca,'XTick',[1:length(obj.persub)]); set(gca, 'XTickLabels', {'Forward' 'Backward'}); xlim([0 length(obj.persub)+1]); ylim([-0.04 0.1]);


      % Plot patient stuff

      subplot(2,6,[4,6])
      s = [obj.subjects.id];
      r = [obj.subjects.runs]; r = [r.subject];

      s = s(s>300);

      for i = 1:length(s)
        for j = 1:length(obj.persub)
          plot(j, mean(sum(obj.persub{j}(1:numComps,r==s(i)))), 'Color', obj.subjects(i).color, 'Marker', 'o'); hold on;
          text(j+.1, mean(sum(obj.persub{j}(1:numComps,r==s(i)))), num2str(obj.subjects(i).id), 'FontSize', 6, 'Color', obj.subjects(i).color)
        end

        for j = 2:length(obj.persub)
          plot([j-1 j], [mean(sum(obj.persub{j-1}(1:numComps,r==s(i)))) mean(sum(obj.persub{j}(1:numComps,r==s(i))))], 'Color', obj.subjects(i).color, 'LineStyle', '-'); hold on;
        end
      end

      title('ISC per Subject by Stimulus - Patient'); set(get(gca,'YLabel'),'String','ISC'); set(get(gca,'XLabel'),'String','Stimulus');
      set(gca,'XTick',[1:length(obj.persub)]); set(gca, 'XTickLabels', {'Forward' 'Backward'}); xlim([0 length(obj.persub)+1]); ylim([-0.04 0.1]);

      % Topoplots
      subplot(2,6,[7,8])
      topoplot(obj.a(:,1),obj.subjects(1).runs(1).chanlocs(1:37),'electrodes','off'); title(['Component ' num2str(1) ''])


      subplot(2,6,[9,10])
      topoplot(obj.a(:,2),obj.subjects(1).runs(1).chanlocs(1:37),'electrodes','off'); title(['Component ' num2str(2) ''])

      subplot(2,6,[11,12])
      topoplot(obj.a(:,3),obj.subjects(1).runs(1).chanlocs(1:37),'electrodes','off'); title(['Component ' num2str(3) ''])

    end
  end

end
