datapath = '../../../minConsciousEEG/';
load([datapath 'processedDataWithInfo.mat'],'dataInfo','eeg');
Ncomp=3;

N = length(eeg); % number of subjects
lF = size(eeg(1).fwd,1); lB = size(eeg(1).bwd,1); lT = lF+lB; % define lengths of fwd and bwd segments & total length
f = matfile([datapath 'regressY_separate.mat']);
YF = f.YF(:,1:Ncomp); % Projected components, using W from only the healthies, that has the healthy subjects only
YB = f.YB(:,1:Ncomp);

healthy = [dataInfo.healthy];

for i = 1:N

% Forward isc run
    i
    'fwd'

    YiF = YF;
    if healthy(i) %
	  YiF(lF*(i-1)+1:lF*i, :) = [];
    end

    X = repmat(eeg(i).fwd, [length(YiF)/lF 1]);

    Wf_F(:,:,i) = X\YiF; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different

    for j=1:Ncomp
        cc = corrcoef([YiF(:,j) X*Wf_F(:,j,i)]);
        isc_F(i,j) = cc(1,2);
    end

% Backward isc run
    'bwd'

    YiB = YB;
    if healthy(i) %
	  YiB(lB*(i-1)+1:lB*i, :) = [];
    end

    X = repmat(eeg(i).bwd, [length(YiB)/lB 1]);

    Wf_B(:,:,i) = X\YiB; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different

    for j=1:Ncomp
        cc = corrcoef([YiB(:,j) X*Wf_B(:,j,i)]);
        isc_B(i,j) = cc(1,2);
    end

end
