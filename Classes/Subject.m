classdef Subject

  properties
    id              % Subject ID
    healthy         % bool - is subject healthy?
    color           % RGB color to assign to subject
    runs            % array of run objects belonging to this subject
    numRuns         % length of runs array
    numComps = 3;   % number of ISC components to work with
    ISC             % ISC values
    stimIDs         % IDs of subject's available stims
    paperID         % ID of the subject in the paper
    marker          % Plot marker for this subject
  end

  methods

    function obj = addRun(obj, run)
      obj.runs= [obj.runs run];
      obj.numRuns = length(obj.runs);
      obj.stimIDs = unique([obj.stimIDs [obj.runs.stimIDs]]);
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

    function [data, order] = volumize2(obj, stimIndex)
      % This function returns a volume of all EEG data matching requested stim index
      % data = AxBxC matrix of SamplesxChannelsxRuns
      % order = array of subject IDs corresponding to order of C dimension in data

      data = [];
      order = [];

      runs = [obj.runs];

	    total = 0;

      for i = 1:length(runs)

        temp = runs(i).extract(stimIndex);
        if ~isempty(temp)
          data = cat(3, data, temp);
          order = [order runs(i).subject];
	        total = total + 1;
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

    function isc = getISC(obj, stimNumber)
      isc = [];
      x = find(obj.stimIDs==stimNumber);
      if ~isempty(x)
        isc = mean(sum(obj.ISC{stimNumber}(1:obj.numComps,:), 1), 2);
      else
        isc = NaN;
      end

    end

    function plotSelf(obj, marker)

      if nargin < 2
        marker = 'o';
      end

      for i=1:length(obj.ISC)
        if(~isempty(obj.ISC{i}))
          values(i) = mean(sum(obj.ISC{i}(1:obj.numComps,:), 1), 2);
        else
          values(i) = NaN;
        end
      end

      plot([1:length(obj.ISC)], values, 'Marker', marker, 'Color', obj.color); hold on;
      text(0.8, double(values(1)), num2str(obj.id), 'FontSize', 6, 'Color', obj.color); hold on;

    end

    function [obj iscresults] = runISC(obj)

      stims = unique([obj.stimIDs]);
      subs = [obj.id];

      for i = 1:length(stims)
        [data{i} order{i}] = obj.volumize2(stims(i));
        ref{i} = find(order{i} < 300);
      end

      [iscresults.isc iscresults.iscpersub iscresults.w iscresults.a] = multiStimISC_v2(data, ref, 250);
      %[iscresults.isc iscresults.iscpersub iscresults.w iscresults.a] = multiStimISC(data, ref, 250);

      for i = 1:length(subs)

        for j = 1:length(iscresults.iscpersub)

          idx = find(order{j} == subs(i));

          obj(i).ISC{j} = iscresults.iscpersub{j}(:,idx);

        end

      end

%       for i = 1:3
%         subplot(3,1,i);
%         topoplot(iscresults.a(:,i), obj(1).runs(1).chanlocs);
%       end

    end
    
    function obj = assignISCToRuns(obj)
        
        for i = 1:length(obj)
            
            for j = 1:size(obj(i).ISC{1}, 2)
                
                obj(i).runs(j).ISCFA = obj(i).ISC{1}(:, j);
                obj(i).runs(j).ISCBA = obj(i).ISC{2}(:, j);
                
            end
            
        end
        
        for i = 1:length(obj)
            
            for j = 1:size(obj(i).ISC{3}, 2)
                
                obj(i).runs(j+size(obj(i).ISC{1}, 2)).ISCFP = obj(i).ISC{3}(:, j);
                obj(i).runs(j+size(obj(i).ISC{1}, 2)).ISCBP = obj(i).ISC{4}(:, j);
                
            end
            
        end
        
    end

  end

end
