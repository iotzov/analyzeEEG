function [eegVolume] = strucToVolume(input, FWDorBWD, desiredRun)
  % Pass 1 for  fwd runs, or 0 for bwd runs
  % Pass [] as value for desiredRun to get all runs

  if(FWDorBWD==1)
    if(isempty(desiredRun))
      eegVolume = input(1).fwd;
      for i = 2:length(input)
        eegVolume = cat(3, eegVolume, input(i).fwd);
      end
    else

      desired = [];
      for i = 1:length(input)
        if(input(i).run==desiredRun)
          desired = [desired i];
        end
      end

      eegVolume = input(desired(1)).fwd;
      for i = desired(2:end)
        eegVolume = cat(3, eegVolume, input(i).fwd);
      end
    end
  end

  if(FWDorBWD==0)
    if(isempty(desiredRun))
      eegVolume = input(1).bwd;
      for i = 2:length(input)
        eegVolume = cat(3, eegVolume, input(i).bwd);
      end

    else

      desired = [];
      for i = 1:length(input)
        if(input(i).run==desiredRun)
          desired = [desired i];
        end
      end

      eegVolume = input(desired(1)).bwd;
      for i = desired(2:end)
        eegVolume = cat(3, eegVolume, input(i).bwd);
      end
    end
  end
