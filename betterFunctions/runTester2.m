load bigS
load aliceVolumes
load aliceInfo

q = size(alice_fwd, 3);

z = ones(q, 1);z=z';

z(find([bigS.id]==221))=0;
z(find([bigS.id]==218))=0;
z(find([bigS.id]==209))=0;
z(find([bigS.id]==223))=0;
z(find([bigS.id]==212))=0;
z(find([bigS.id]==214))=0;

alice_fwd(:,:,~z) = [];
alice_bwd(:,:,~z) = [];
bigS(~z) = [];

q = size(alice_fwd, 3);

for i = 2:q

  data = {alice_fwd(:,:,1:i) alice_bwd(:,:,1:i)};

  ids = [bigS.id]; ids = ids(1:i); uniqueIDs = unique(ids);

  refsubjects = [bigS.group]; refsubjects = refsubjects(1:i); refsubjects = {find(refsubjects==1) find(refsubjects==1)};

  [isc, persub, w, a] = multiStimISC(data, refsubjects, 250);

  s(1:max(ids)) = Subject(1);

  for j = ids
    s(j) = subjects(find(uniqueIDs==j));
  end

  for k = 1:2
    for j = uniqueIDs

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
