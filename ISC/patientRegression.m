datapath = '../../minConsciousEEG/';
load([datapath 'processedDataWithInfo.mat'],'dataInfo','eeg');
Ncomp=3;

N = length(eeg); % number of subjects
lf = size(eeg(1).fwd,1); lb = size(eeg(1).bwd,1); lt = lf+lb; % define lengths of fwd and bwd segments & total length
f = matfile([datapath 'regressY.mat']);
Y = f.Y(:,1:Ncomp); % Projected components, using W from only the healthies, that has the healthy subjects only

healthy = [dataInfo.healthy];

for i = 1:N

    i

    Yi = Y;
    if healthy(i) % 
	  Yi(lt*(i-1)+1:lt*i, :) = [];
    end

    X = repmat([eeg(i).fwd; eeg(i).bwd], [length(Yi)/lt 1]);

    Wf(:,:,i) = X\Yi; % check that they are similar to the W from ISC on normals, with Fwd and Bwd combined, wheras patienst we expect to be potentially quite different

    for j=1:Ncomp
        cc = corrcoef([Yi(:,j) X*Wf(:,j,i)]);
        isc(i,j) = cc(1,2);
    end

end
