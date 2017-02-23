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
  end

end
