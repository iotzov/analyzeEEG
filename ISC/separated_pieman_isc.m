function [results] = separated_pieman_isc(fwddata, bwddata, scramdata, healthyIdx, patientIdx)
%

% some ISC processing parameters
gamma = 0.1; % shrinkage parameter; smaller gamma for less regularization
Nsec  = 5;  % time-window (in seconds) over which to compute time-reposeved ISC
Ncomp = 3;  % number of components to dispaly (all D are computed)

% T samples, D channels, N subjects
Xf = fwddata;
Xb = bwddata;
Xs = scramdata;
fs = 250;
[Tf,Df,Nf] = size(Xf);
[Tb,Db,Nb] = size(Xb);
[Ts,Ds,Ns] = size(Xs);

% standard eeg preprocessing (see function below)
%X = preprocess(X,eogchannels,badchannels,fs);

% discard the eog channels; we already used them in preprocess
%X = X(:,setdiff(1:D,eogchannels),:); D=size(X,2);

% now start the ISC code proper

% compute cross-covariance between all subjects i and j

% fwd run
Rij_f = permute(reshape(cov(Xf(:,:)),[Df Nf  Df Nf]),[1 3 2 4]); % check this line!!!

% bwd run
Rij_b = permute(reshape(cov(Xb(:,:)),[Db Nb  Db Nb]),[1 3 2 4]);

% scram run
Rij_s = permute(reshape(cov(Xs(:,:)),[Ds Ns  Ds Ns]),[1 3 2 4]);

% compute within- and between-subject covariances

% fwd run
Rw_f =       1/Nf* sum(Rij_f(:,:,1:Nf+1:Nf*Nf),3);  % pooled over all subjects
Rb_f = 1/(Nf-1)/Nf*(sum(Rij_f(:,:,:),3) - Nf*Rw_f);  % pooled over all pairs of subjects

% bwd run
Rw_b =       1/Nb* sum(Rij_b(:,:,1:Nb+1:Nb*Nb),3);  % pooled over all subjects
Rb_b = 1/(Nb-1)/Nb*(sum(Rij_b(:,:,:),3) - Nb*Rw_b);  % pooled over all pairs of subjects

% scram run
Rw_s =       1/Ns* sum(Rij_s(:,:,1:Ns+1:Ns*Ns),3);  % pooled over all subjects
Rb_s = 1/(Ns-1)/Ns*(sum(Rij_s(:,:,:),3) - Ns*Rw_s);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
% fwd run
Rw_reg_f = (1-gamma)*Rw_f + gamma*mean(eig(Rw_f))*eye(size(Rw_f));

% bwd run
Rw_reg_b = (1-gamma)*Rw_b + gamma*mean(eig(Rw_b))*eye(size(Rw_b));

% scram run
Rw_reg_s = (1-gamma)*Rw_s + gamma*mean(eig(Rw_s))*eye(size(Rw_s));

% +++ If multiple stimuli are available, then Rw and Rb should be averaged over
% stimuli here prior to computing W and A +++

Rw_reg_fs = mean(cat(4,Rw_reg_f, Rw_reg_s),4);
Rb_fs = mean(cat(4,Rb_f, Rb_s),4);
Rw_fs = mean(cat(4,Rw_f, Rw_s),4);

Rw_reg_fb = mean(cat(4,Rw_reg_b, Rw_reg_f),4);
Rb_fb = mean(cat(4,Rb_b, Rb_f),4);
Rw_fb = mean(cat(4,Rw_b, Rw_f),4);

% compute correlated components W using regularized Rw, sort components by ISC
% fwd-scram computation
[W_fs,ISC_fs]=eig(Rb_fs,Rw_reg_fs); [ISC_fs,indx]=sort(diag(ISC_fs),'descend'); W_fs=W_fs(:,indx);

% fwd-bwd computation
[W_fb,ISC_fb]=eig(Rb_fb,Rw_reg_fb); [ISC_fb,indx]=sort(diag(ISC_fb),'descend'); W_fb=W_fb(:,indx);

% compute forward model ("scalp projections") A
A_fs=Rw_fs*W_fs*inv(W_fs'*Rw_fs*W_fs);

A_fb=Rw_fb*W_fb*inv(W_fb'*Rw_fb*W_fb);
% fwd
%A_f=Rw_f*W*inv(W'*Rw_f*W);
% bwd
%A_b=Rw_b*W*inv(W'*Rw_b*W);
% scram
%A_s=Rw_s*W*inv(W'*Rw_s*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
for i=1:Nf

    % FWD - SCRAM WEIGHTS HERE

    % fwd run
    Rw_f=0; for j=healthyIdx, if i~=j, Rw_f = Rw_f+(Rij_f(:,:,i,i)+Rij_f(:,:,j,j)); end; end
    Rb_f=0; for j=healthyIdx, if i~=j, Rb_f = Rb_f+(Rij_f(:,:,i,j)+Rij_f(:,:,j,i)); end; end
    persub_Wfs_f(:,i) = diag(W_fs'*Rb_f*W_fs)./diag(W_fs'*Rw_f*W_fs);

    % scram run
    Rw_s=0; for j=healthyIdx, if i~=j, Rw_s = Rw_s+(Rij_s(:,:,i,i)+Rij_s(:,:,j,j)); end; end
    Rb_s=0; for j=healthyIdx, if i~=j, Rb_s = Rb_s+(Rij_s(:,:,i,j)+Rij_s(:,:,j,i)); end; end
    persub_Wfs_s(:,i) = diag(W_fs'*Rb_s*W_fs)./diag(W_fs'*Rw_s*W_fs);

    % FWD - BWD WEIGHTS HERE

    % fwd run
    Rw_f=0; for j=healthyIdx, if i~=j, Rw_f = Rw_f+(Rij_f(:,:,i,i)+Rij_f(:,:,j,j)); end; end
    Rb_f=0; for j=healthyIdx, if i~=j, Rb_f = Rb_f+(Rij_f(:,:,i,j)+Rij_f(:,:,j,i)); end; end
    persub_Wfb_f(:,i) = diag(W_fb'*Rb_f*W_fb)./diag(W_fb'*Rw_f*W_fb);

    % bwd run
    Rw_b=0; for j=healthyIdx, if i~=j, Rw_b = Rw_b+(Rij_b(:,:,i,i)+Rij_b(:,:,j,j)); end; end
    Rb_b=0; for j=healthyIdx, if i~=j, Rb_b = Rb_b+(Rij_b(:,:,i,j)+Rij_b(:,:,j,i)); end; end
    persub_Wfb_b(:,i) = diag(W_fb'*Rb_b*W_fb)./diag(W_fb'*Rw_b*W_fb);

end

results = struct();

results.ISC_fs = ISC_fs;
results.ISC_fb = ISC_fb;
results.persub_Wfs_s = persub_Wfs_s;
results.persub_Wfs_f = persub_Wfs_f;
results.persub_Wfb_b = persub_Wfb_b;
results.persub_Wfb_f = persub_Wfb_f;
results.W_fs = W_fs;
results.W_fb = W_fb;
results.A_fs = A_fs;
results.A_fb = A_fb;

%{ Compute ISC resolved in time
%for t = 1:floor((T-Nsec*fs)/fs)
%    Xt = X((1:Nsec*fs)+(t-1)*fs,:,:);
%    Rij = permute(reshape(cov(Xt(:,:)),[D N  D N]),[1 3 2 4]);
%    Rw =       1/N* sum(Rij(:,:,1:N+1:N*N),3);  % pooled over all subjects
%    Rb = 1/(N-1)/N*(sum(Rij(:,:,:),3) - N*Rw);  % pooled over all pairs of subjects
%    ISC_persecond(:,t) = diag(W'*Rb*W)./diag(W'*Rw*W);
%end
%
% show some results
%if ~exist('topoplot') | ~exist('notBoxPlot')
%    warning('Get display functions topoplot, notBoxPlot where you found this file or on the web');
%else
%    for i=1:Ncomp
%        subplot(2,Ncomp,i);
%        topoplot(A(:,i),'test.loc','electrodes','off'); title(['a_' num2str(i)])
%    end
%    subplot(2,2,3); notBoxPlot(ISC_persubject(1:Ncomp,healthyIdx)'); xlabel('Component'); ylabel('ISC'); title('Per subjects - Healthy'); ylim([-.01 0.1]);
%    subplot(2,2,4); notBoxPlot(ISC_persubject(1:Ncomp,patientIdx)'); xlabel('Component'); ylabel('ISC'); title('Per subjects - Patient'); ylim([-.01 0.1]);
%    %subplot(2,2,4); plot(ISC_persecond(1:Ncomp,:)'); xlabel('Time (s)'); ylabel('ISC'); title('Per second');
%end
%%}

%{for i=1:N
%  if(any(i==healthyIdx))
%    Rw=0; for j=healthyIdx, if i~=j, Rw = Rw+(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
%    Rb=0; for j=healthyIdx, if i~=j, Rb = Rb+(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
%    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
%  else
%    Rw=0; for j=patientIdx, Rw = Rw+(Rij(:,:,i,i)+Rij(:,:,j,j)); end;
%    Rb=0; for j=patientIdx, Rb = Rb+(Rij(:,:,i,j)+Rij(:,:,j,i)); end;
%    ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
%    %Rw=0; for j=1:N, if i~=j, Rw = Rw+1/(N-1)*(Rij(:,:,i,i)+Rij(:,:,j,j)); end; end
%    %Rb=0; for j=1:N, if i~=j, Rb = Rb+1/(N-1)*(Rij(:,:,i,j)+Rij(:,:,j,i)); end; end
%    %ISC_persubject(:,i) = diag(W'*Rb*W)./diag(W'*Rw*W);
%  end
%end
%%}


% ### Run all the code above with phase-randomized Xr to get chance values
% of ISC measures under the null hypothesis of no ISC.
