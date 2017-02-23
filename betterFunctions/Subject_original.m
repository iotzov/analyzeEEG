classdef Subject_original

  properties
    id
    group
    color
    ISC
  end

  methods
    function obj = Subject(myID)
      obj.id = myID;
      obj.group = myID<300;
      obj.color = rand(1,3);
      obj.ISC = {};
    end
  end

end
