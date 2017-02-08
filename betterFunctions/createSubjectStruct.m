function [results] = createSubjectStruct(iscpersub, subs, subjects)
  % iscpersub - Cell array that is returned by the multi-stim ISC function, length == # of stimuli
  % subs - Cell array of subject names for each stim - (length == # of stimuli)
  % subjects - Subject class array, length = # of unique subjects, id property must be pre-set

  numStims = length(iscpersub);
  s = [subjects.id];

  for i = 1:numStims

    for j = s

      idx = find(subs{i}==j);

      if(length(idx)>0)
        subjects(s==j).ISC = [subjects(s==j).ISC iscpersub{i}(:,idx)];
      else
        subjects(s==j).ISC = [subjects(s==j).ISC {[]}];
      end

    end

  end

  %q = [];
  %for i = 1:length(s)
  %  for j = 1:length()
  %  q = cat(2, q, subjects(i).runs);
  %end

  %for i = 1:length(s)

  %  t = {};
  %  a = q(:,i);
  %  for j=
  %end


  results=subjects;

end
