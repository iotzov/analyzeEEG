datapath = '../../../minConsciousEEG/';
load([datapath 'processedDataWithInfo.mat'],'dataInfo','eeg');
load([datapath 'projectedHealthyEEG.mat']);
load([datapath 'master_w.mat']);
Ncomp=3;

N = length(eeg); % number of subjects
lf = size(eeg(1).fwd,1); lb = size(eeg(1).bwd,1); lt = lf+lb; % define lengths of fwd and bwd segments & total length
%f = matfile([datapath 'regressY.mat']);
%Y = f.Y(:,1:Ncomp); % Projected components, using W from only the healthies, that has the healthy subjects only

%dataInfo = dataInfo([dataInfo.healthy]);
subs = [dataInfo.subj];

i = 1;
while i <= N

    current = find(subs==subs(i));

    'combined'
    i

    Yi = [];
    for j = 1:length(projected_eeg)
      if(subs(j)==subs(i))
        continue
      end
      Yi = [Yi; projected_eeg(j).fwd];
      Yi = [Yi; projected_eeg(j).bwd];
    end


  %  X = repmat([eeg(i).fwd; eeg(i).bwd], [length(Yi)/lt 1]);
    units = length(Yi)/lt;
    repeats = floor(units/length(current));
    remainder = rem(units, length(current));

    X = [];
    for j = 1:length(current)
      X = [X; eeg(current(j)).fwd];
      X = [X; eeg(current(j)).bwd];
    end

    X = repmat(X, [repeats 1]);
    if remainder ~= 0
      X = [X; X(1:lt*remainder,:)];
    end

%    Wf(:,:,i) = X\Yi; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different
    Wf(:,:,i) = master_w;

    for j=1:Ncomp
        cc = corrcoef([Yi(:,j) X*Wf(:,j,i)]);
        isc(i,j) = cc(1,2);
    end

    'fwd'
    i

    Yi = [];
    for j = 1:length(projected_eeg)
      if(subs(j)==subs(i))
        continue
      end
      Yi = [Yi; projected_eeg(j).fwd];
    %  Yi = [Yi; projected_eeg(j).bwd];
    end


    %X = repmat([eeg(i).fwd; eeg(i).bwd], [length(Yi)/lt 1]);
    units = length(Yi)/lf;
    repeats = floor(units/length(current));
    remainder = rem(units, length(current));

    X = [];
    for j = 1:length(current)
      X = [X; eeg(current(j)).fwd];
  %    X = [X; eeg(current(j)).bwd];
    end

    X = repmat(X, [repeats 1]);
    if remainder ~= 0
      X = [X; X(1:lf*remainder,:)];
    end

%    Wf_F(:,:,i) = X\Yi; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different
    Wf_F(:,:,i) = master_w;

    for j=1:Ncomp
        cc = corrcoef([Yi(:,j) X*Wf_F(:,j,i)]);
        isc_F(i,j) = cc(1,2);
    end

    'bwd'
    i

    Yi = [];
    for j = 1:length(projected_eeg)
      if(subs(j)==subs(i))
        continue
      end
    %  Yi = [Yi; projected_eeg(j).fwd];
      Yi = [Yi; projected_eeg(j).bwd];
    end


    %X = repmat([eeg(i).fwd; eeg(i).bwd], [length(Yi)/lt 1]);
    units = length(Yi)/lb;
    repeats = floor(units/length(current));
    remainder = rem(units, length(current));

    X = [];
    for j = 1:length(current)
  %    X = [X; eeg(current(j)).fwd];
      X = [X; eeg(current(j)).bwd];
    end

    X = repmat(X, [repeats 1]);
    if remainder ~= 0
      X = [X; X(1:lb*remainder,:)];
    end

%    Wf_B(:,:,i) = X\Yi; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different
    Wf_B(:,:,i) = master_w;
    for j=1:Ncomp
        cc = corrcoef([Yi(:,j) X*Wf_B(:,j,i)]);
        isc_B(i,j) = cc(1,2);
    end

    i = i+length(current);

end

regressionChart
