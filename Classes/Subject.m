classdef Subject

  properties
    id
    healthy
    color
    runs
    numRuns
    numComps = 3;
    ISC
  end

  methods
    function obj = addRun(obj, run)
      obj.runs= [obj.runs run];
      obj.numRuns = length(obj.runs);
    end
    function obj = Subject(id)
      obj.color = rand(1,3);
      obj = obj.setID(id);
    end
    function obj = setID(obj, id)
      obj.id = id;
      obj.healthy = id<300;
    end
    function obj = preprocess(obj)
      for j = 1:length(obj)
        for i = 1:length(obj(j).runs)
          obj(j).runs(i) = obj(j).runs(i).preprocess();
        end
      end
    end
    function data = volumize(obj, stimIndex)
      data = [];
      for i = 1:length([obj.runs])
        temp = obj.runs(i).extract(stimIndex);
        if(~isempty(temp))
          data = cat(3, data, temp);
        end
      end
    end
    function meanISC = getMeanISC(obj, stimNumber)
      isc = [];
      for i = 1:length(obj.runs)
        isc = [isc obj.runs(i).ISC{stimNumber}];
      end
      meanISC = mean(sum(isc(1:3,:)));
    end
    function plotSelf(obj)
      for i=1:length(obj.ISC)
        if(~isempty(obj.ISC{i}))
          values(i) = mean(sum(obj.ISC{i}(1:3,:)));
        else
          values(i) = NaN;
        end
      end
      plot([1:length(obj.ISC)], values, 'Marker', 'o', 'Color', obj.color); hold on;
      text(0.8, double(values(1)), num2str(obj.id), 'FontSize', 6, 'Color', obj.color); hold on;
    end
  end

end
