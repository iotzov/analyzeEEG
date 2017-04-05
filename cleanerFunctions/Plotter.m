classdef Plotter

  properties
    stimNames
    w
    a
  end

  methods
    function plotISC(obj, subjects)
      if(any(~[subjects.healthy]))
        h = subjects([subjects.healthy]);
        p = subjects(~[subjects.healthy]);

        % Plot healthies
        subplot(1,2,1)
        for i = 1:length(h)
          h(i).plotSelf()
        end
        title('ISC per Subject by Stimulus - Healthy');
        set(get(gca,'YLabel'),'String','ISC');
        set(get(gca,'XLabel'),'String','Stimulus');
        set(gca,'XTick',[1:length(obj.stimNames)]);
        set(gca, 'XTickLabels', obj.stimNames);
        xlim([0 length(obj.stimNames)+1]);
        ylim([-0.02 0.15]);

        % Plot patients
        subplot(1,2,2)
        for i = 1:length(p)
          p(i).plotSelf()
        end
        title('ISC per Subject by Stimulus - Patient');
        set(get(gca,'XLabel'),'String','Stimulus');
        set(gca,'XTick',[1:length(obj.stimNames)]);
        set(gca, 'XTickLabels', obj.stimNames);
        xlim([0 length(obj.stimNames)+1]);
        ylim([-0.02 0.15]);
      else
        for i = 1:length(subjects)
          subjects(i).plotSelf()
        end
        title('ISC per Subject by Stimulus - Healthy');
        set(get(gca,'YLabel'),'String','ISC');
        set(get(gca,'XLabel'),'String','Stimulus');
        set(gca,'XTick',[1:length(obj.stimNames)]);
        set(gca, 'XTickLabels', obj.stimNames);
        xlim([0 length(obj.stimNames)+1]);
        ylim([-0.02 0.15]);
      end
    end
  end

end
