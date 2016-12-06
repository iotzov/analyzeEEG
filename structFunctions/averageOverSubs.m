function [averagedfwd, averagedbwd] = averageOverSubs(eeg)

  subs = [eeg.subj];
  averagedfwd = []; averagedbwd=[];

  for i=unique(subs)

    z=find(subs==i);
    tempf=[]; tempb=[];

    for i=1:length(z)

      tempf=cat(3, tempf, eeg(z(i)).fwd);
      tempb=cat(3, tempb, eeg(z(i)).bwd);

    end

    averagedfwd = cat(3, averagedfwd, mean(tempf, 3));
    averagedbwd = cat(3, averagedbwd, mean(tempb, 3));

  end
end
