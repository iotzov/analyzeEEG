function [ISC,ISC_persubject,ISC_persecond,W,A] = iscNoDisplay_Segmented(datafile, healthyIdx, patientIdx)
%

% some ISC processing parameters
gamma = 0.1; % shrinkage parameter; smaller gamma for less regularization
Nsec  = 5;  % time-window (in seconds) over which to compute time-reposeved ISC
Ncomp = 3;  % number of components to dispaly (all D are computed)

% T samples, D channels, N subjects
X = datafile;
fs = 250;
[T,D,N] = size(X);

% standard eeg preprocessing (see function below)
%X = preprocess(X,eogchannels,badchannels,fs);

% discard the eog channels; we already used them in preprocess
%X = X(:,setdiff(1:D,eogchannels),:); D=size(X,2);

% now start the ISC code proper

% compute cross-covariance between all subjects i and j
Rij = permute(reshape(cov(X(:,:)),[D N  D N]),[1 3 2 4]); % check this line!!!

% compute within- and between-subject covariances
Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
Rw_reg = (1-gamma)*Rw + gamma*mean(eig(Rw))*eye(size(Rw));

% +++ If multiple stimuli are available, then Rw and Rb should be averaged over
% stimuli here prior to computing W and A +++

% compute correlated components W using regularized Rw, sort components by ISC
[W,ISC]=eig(Rb,Rw_reg); [ISC,indx]=sort(diag(ISC),'descend'); W=W(:,indx);

% compute forward model ("scalp projections") A
A=Rw*W*inv(W'*Rw*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
for i=1:N
    Rw=0; for j=healthyIdx, if i~=j, Rw = Rw+(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    Rb=0; for j=healthyIdx, if i~=j, Rb = Rb+(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

% Compute ISC resolved in time
for t = 1:floor((T-Nsec*fs)/fs)
    Xt = X((1:Nsec*fs)+(t-1)*fs,:,:);
    Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
    Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
    Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
    ISC_persecond(:,t) = diag(W'*Rb*W)./diag(W'*Rw*W);
end

%{% show some results
if ~exist('topoplot') | ~exist('notBoxPlot')
    warning('Get display functions topoplot, notBoxPlot where you found this file or on the web');
else
    for i=1:Ncomp
        subplot(2,Ncomp,i);
        topoplot(A(:,i),'newChanLocs.loc','electrodes','off'); title(['a_' num2str(i)])
    end
    subplot(2,2,3); notBoxPlot(ISC_persubject(1:Ncomp,healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Per subjects - Healthy'); ylim([-.01 0.1]);
    subplot(2,2,4); notBoxPlot(ISC_persubject(1:Ncomp,patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Per subjects - Patient'); ylim([-.01 0.1]);
    %subplot(2,2,4); plot(ISC_persecond(1:Ncomp,:)'); xlabel('Time (s)'); ylabel('ISC'); title('Per second');
end
%}

%{for i=1:N
  if(any(i==healthyIdx))
    Rw=0; for j=healthyIdx, if i~=j, Rw = Rw+(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    Rb=0; for j=healthyIdx, if i~=j, Rb = Rb+(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
  else
    Rw=0; for j=patientIdx, Rw = Rw+(Rij(:,:,i,i)+Rij(:,:,j,j)); end;
    Rb=0; for j=patientIdx, Rb = Rb+(Rij(:,:,i,j)+Rij(:,:,j,i)); end;
    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
    %Rw=0; for j=1:N, if i~=j, Rw = Rw+1/(N-1)*(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
    %Rb=0; for j=1:N, if i~=j, Rb = Rb+1/(N-1)*(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
    %ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
  end
end
%}


% ### Run all the code above with phase-randomized Xr to get chance values
% of ISC measures under the null hypothesis of no ISC.
