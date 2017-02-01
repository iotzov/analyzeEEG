gamma = 0.1; % shrinkage parameter; smaller gamma for less regularization
Nsec  = 5;  % time-window (in seconds) over which to compute time-reposeved ISC
Ncomp = 3;  % number of components to dispaly (all D are computed)
% T samples, D channels, N subjects
XPf = pieman_fwd;
XPb = pieman_bwd;
XPs = pieman_scr;
XAf = alice_fwd;
XAb = alice_bwd;
fs = 250;
[TPf,DPf,NPf] = size(XPf);
[TPb,DPb,NPb] = size(XPb);
[TPs,DPs,NPs] = size(XPs);
[TAf,DAf,NAf] = size(XAf);
[TAb,DAb,NAb] = size(XAb);
% compute cross-covariance between all subjects i and j

% ------------------- PIEMAN -------------------------

% fwd run
RijP_f = permute(reshape(cov(XPf(:,:)),[DPf NPf  DPf NPf]),[1 3 2 4]); % check this line!!!

% bwd run
RijP_b = permute(reshape(cov(XPb(:,:)),[DPb NPb  DPb NPb]),[1 3 2 4]);

% scram run
RijP_s = permute(reshape(cov(XPs(:,:)),[DPs NPs  DPs NPs]),[1 3 2 4]);

% compute within- and between-subject covariances

% fwd run
RwP_f =       1/NPf* sum(RijP_f(:,:,1:NPf+1:NPf*NPf),3);  % pooled over all subjects
RbP_f = 1/(NPf-1)/NPf*(sum(RijP_f(:,:,:),3) - NPf*RwP_f);  % pooled over all pairs of subjects

% bwd run
RwP_b =       1/NPb* sum(RijP_b(:,:,1:NPb+1:NPb*NPb),3);  % pooled over all subjects
RbP_b = 1/(NPb-1)/NPb*(sum(RijP_b(:,:,:),3) - NPb*RwP_b);  % pooled over all pairs of subjects

% scram run
RwP_s =       1/NPs* sum(RijP_s(:,:,1:NPs+1:NPs*NPs),3);  % pooled over all subjects
RbP_s = 1/(NPs-1)/NPs*(sum(RijP_s(:,:,:),3) - NPs*RwP_s);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
% fwd run
Rw_regP_f = (1-gamma)*RwP_f + gamma*mean(eig(RwP_f))*eye(size(RwP_f));

% bwd run
Rw_regP_b = (1-gamma)*RwP_b + gamma*mean(eig(RwP_b))*eye(size(RwP_b));

% scram run
Rw_regP_s = (1-gamma)*RwP_s + gamma*mean(eig(RwP_s))*eye(size(RwP_s));

% ------------------------ ALICE -------------------------------------
RijA_f = permute(reshape(cov(XAf(:,:)),[DAf NAf  DAf NAf]),[1 3 2 4]); % check this line!!!

% bwd run
RijA_b = permute(reshape(cov(XAb(:,:)),[DAb NAb  DAb NAb]),[1 3 2 4]);

% compute within- and between-subject covariances

% fwd run
RwA_f =       1/NAf* sum(RijA_f(:,:,1:NAf+1:NAf*NAf),3);  % pooled over all subjects
RbA_f = 1/(NAf-1)/NAf*(sum(RijA_f(:,:,:),3) - NAf*Rw_f);  % pooled over all pairs of subjects

% bwd run
RwA_b =       1/NAb* sum(RijA_b(:,:,1:NAb+1:NAb*NAb),3);  % pooled over all subjects
RbA_b = 1/(NAb-1)/NAb*(sum(RijA_b(:,:,:),3) - NAb*RwA_b);  % pooled over all pairs of subjects

% shrinkage regularization of Rw
% fwd run
Rw_regA_f = (1-gamma)*RwA_f + gamma*mean(eig(RwA_f))*eye(size(RwA_f));

% bwd run
Rw_regA_b = (1-gamma)*RwA_b + gamma*mean(eig(RwA_b))*eye(size(RwA_b));

% +++ If multiple stimuli are available, then Rw and Rb should be averaged over
% stimuli here prior to computing W and A +++

Rw_reg = mean(cat(4,Rw_regP_f, Rw_regP_b, Rw_regP_s, Rw_regA_f, Rw_regA_b),4);
Rb = mean(cat(4,RbP_f, RbP_b, RbP_f, RbA_f, RbA_b),4);
Rw = mean(cat(4,RwP_f, RwP_b, RwP_f, RwA_f, RwA_b),4);

% compute correlated components W using regularized Rw, sort components by ISC
[W,ISC]=eig(Rb,Rw_reg); [ISC,indx]=sort(diag(ISC),'descend'); W=W(:,indx);

% compute forward model ("scalp projections") A
A=Rw*W*inv(W'*Rw*W);

% +++ If multiple stimuli are available, then Rij as computed for each stimulus
% should be used in the following to compute ISC_persubject, and
% ISC_persecond +++

% Compute ISC resolved by subject, see Cohen et al.
for i=1:Nf

    % -----------------------------PIEMAN-------------------------------------

    % fwd run
    Rw_f=0; for j=healthyIdx, if i~=j, Rw_f = Rw_f+(Rij_f(:,:,i,i)+Rij_f(:,:,j,j)); end; end
    Rb_f=0; for j=healthyIdx, if i~=j, Rb_f = Rb_f+(Rij_f(:,:,i,j)+Rij_f(:,:,j,i)); end; end
    persub_Wfs_f(:,i) = diag(W_fs'*Rb_f*W_fs)./diag(W_fs'*Rw_f*W_fs);

    % scram run
    Rw_s=0; for j=healthyIdx, if i~=j, Rw_s = Rw_s+(Rij_s(:,:,i,i)+Rij_s(:,:,j,j)); end; end
    Rb_s=0; for j=healthyIdx, if i~=j, Rb_s = Rb_s+(Rij_s(:,:,i,j)+Rij_s(:,:,j,i)); end; end
    persub_Wfs_s(:,i) = diag(W_fs'*Rb_s*W_fs)./diag(W_fs'*Rw_s*W_fs);

    % bwd run
    Rw_b=0; for j=healthyIdx, if i~=j, Rw_b = Rw_b+(Rij_b(:,:,i,i)+Rij_b(:,:,j,j)); end; end
    Rb_b=0; for j=healthyIdx, if i~=j, Rb_b = Rb_b+(Rij_b(:,:,i,j)+Rij_b(:,:,j,i)); end; end
    persub_Wfb_b(:,i) = diag(W_fb'*Rb_b*W_fb)./diag(W_fb'*Rw_b*W_fb);

    % -----------------------------ALICE---------------------------------------

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



f = figure;

subs = results.subs;
s = unique(subs);

averagedfwd = []; averagedbwd = []; group = [];

for i=s

  z=find(subs==i);
  averagedfwd = [averagedfwd mean(sum(results.iscpersub_f(1:3,z)))];
  averagedbwd = [averagedbwd mean(sum(results.iscpersub_b(1:3,z)))];
  group = [group i<300];

end

results.averagedfwd = averagedfwd;
results.averagedbwd = averagedbwd;

clf

subplot(1,2,1)
% plot fwd

subjectPlots = [];
subjectNames = {};

for i = 1:13
  subjectPlots = [subjectPlots plot( 1, averagedfwd(i),'Marker', 'o', 'Color', colorstruct.(['s' num2str(s(i))]), 'DisplayName', ['H' num2str(s(i))])]; hold on
  plot( 2, averagedbwd(i),'Marker', '*', 'Color', colorstruct.(['s' num2str(s(i))])); hold on
  plot([1 2], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
  subjectNames = [subjectNames ['H' num2str(s(i))]];
end

% plot bwd
for i=14:length(averagedfwd)
  subjectPlots = [subjectPlots plot( 3, averagedfwd(i),'Marker', 'o', 'Color', colorstruct.(['s' num2str(s(i))]), 'DisplayName', ['P' num2str(s(i))])]; hold on
  plot( 4, averagedbwd(i),'Marker', '*', 'Color', colorstruct.(['s' num2str(s(i))])); hold on
  plot([3 4], [averagedfwd(i) averagedbwd(i)],'-k'); hold on
  subjectNames = [subjectNames ['P' num2str(s(i))]];
end

xlim([0  5])
%  notBoxPlot([averagedfwd(1:13)', averagedbwd(1:13)', [averagedfwd(14:end) 0]',[averagedbwd(14:end) 0]']); legend;
% xticks([1.5 3.5]);

set(gca, 'XTick', [1.5 3.5]); set(gca,'xticklabel',{'Control' 'Patient'});
xlabel('Group'); ylabel('Sum ISC'); title('ISC Values'); ylim([-.01 .03]);

for i = 1:3
  subplot(3,2,i*2);
  topoplot(results.af(:,i),'test.loc','electrodes','off'); title(['Component ' num2str(i) ''])
end

for i = 4:6
  %  subplot(2,3,i);
  %  topoplot(results.ab(:,i-3),'test.loc','electrodes','off'); title(['a_' num2str(i-3) '-Bwd'])
end

[h,p1]=ttest2(results.averagedfwd(1:13), results.averagedfwd(14:end));
[h,p2]=ttest2(results.averagedbwd(1:14), results.averagedbwd(14:end));
[h,p3]=ttest2([results.averagedfwd(1:13)+results.averagedbwd(1:13)], [results.averagedfwd(14:end)+results.averagedbwd(14:end)]);
[h,p4] = ttest(results.averagedfwd(1:13) - results.averagedbwd(1:13));
[h,p5] = ttest(results.averagedfwd(14:end) - results.averagedbwd(14:end));
subplot(1,2,1)
sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p1 p2 p3 p4 p5])
% legend('show', 'Location', 'southwest')
legend(subjectPlots, subjectNames);
