classdef SubjectOriginal

  properties
    id
    group
    color
    ISC
  end

  methods
    function obj = SubjectOriginal(myID)
      obj.id = myID;
      obj.group = myID<300;
      obj.color = rand(1,3);
      obj.ISC = {};
    end
  end

end
