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
    function obj = Subject()
      obj.color = rand(1,3);
    end
    function obj = setID(obj, id)
      obj.id = id;
      obj.healthy = id<300;
    end
    function obj = preprocess(obj)
      for i = 1:length(obj.runs)
        obj.runs(i) = obj.runs(i).preprocess();
      end
    end
    function data = volumize(obj, stimIndex)
      for i = 1:length([obj.runs])
        data(:,:,i) = obj.runs(i).extract(stimIndex);
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
        values(i) = mean(sum(obj.ISC{i}(1:3,:)));
      end
      plot([1:length(obj.ISC)], values, 'Marker', 'o', 'Color', obj.color); hold on;
      text(0.7, values(1), num2str(obj.id), 'FontSize', 6, 'Color', obj.color); hold on;
  end

end
