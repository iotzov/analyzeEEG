classdef Subject

  properties
    id
    healthy
    color
    runs
    numRuns
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
      for i = 1:length(obj.runs)
        data(:,:,i) = obj.runs(i).extract(stimIndex);
      end
    end
  end

end
