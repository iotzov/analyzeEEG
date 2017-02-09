load bigS
load aliceVolumes
load aliceInfo

for i = 2:101

  data = {alice_fwd(:,:,1:i) alice_bwd(:,:,1:i)};

  ids = [subjects.id]; ids = ids(1:i); uniqueIDs = unique(ids);

  refsubjects = [subjects.group]; refsubjects = refsubjects(1:i); refsubjects = {find(refsubjects==1) find(refsubjects==1)};

  [isc, persub, w, a] = multiStimISC(data, refsubjects, 250);

  s(1:max(ids)) = Subject(1);

  for j = ids
    s(j) = subjects(find(uniqueIDs==j));
  end

  for k = 1:2
    for j = ids

      idx = find(ids==j);

      s(j).ISC = [s(j).ISC persub{k}(:,idx)];

    end
  end

  testingMakeChart(s([s.id]~=1), {'fwd' 'bwd'}, 3, a, i)

end

%for i = 3:4

%  data = {alice_fwd(:,:,1:i) alice_bwd(:,:,1:i)};

%  groups = [bigS.group]; groups = groups(1:i);
%  s = [bigS.id]; s = s(1:i); s2 = unique(s);

%  refsubjects = {find(groups==1) find(groups==1)};

%  [isc, persub, w, a] = multiStimISC(data, refsubjects, 250);

%  tempSubjects = subjects(1:length(s2));

%  for j=1:2

%    for k=s

%      idx = find(s2==k);
%      if(length(idx)>0)
%        tempSubjects(s==k).ISC = [tempSubjects(s==k).ISC persub{j}(:,idx)]
%      else
%        tempSubjects(s==k).ISC = [tempSubjects(s==k).ISC {[]}];
%      end

%    end

%  end

%  testingMakeChart()

%end
