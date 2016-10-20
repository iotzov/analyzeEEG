function [Rpool,Rxy] = make_covariance_matrices(x,D,permutationList,TimePeriod)

% make_covariance_matrices:

% Inputs:
% x = EEG Data (Time x Channels x subjects)
% D = Number of channels in EEG data
% permutationList = a matrix of pairs of subjects, numbered by where they 
% are in x. size(permutationList) = number of pairs x 2
% TimePeriod = (if relevant) time period over which you will look at data

if nargin == 4
     x=x(TimePeriod,:,:);
end


Rxy = zeros(D);
Rpool = zeros(D);
for ii = size(permutationList,1):-1:1
    Rxy_ = cov([x(:,:,permutationList(ii,1)), x(:,:,permutationList(ii,2))]);
    Rxy = Rxy + Rxy_(1:D,D+1:2*D);
    Rpool = Rpool + Rxy_(1:D,1:D) + Rxy_(D+1:2*D,D+1:2*D);
end
Rxy = Rxy + Rxy';

end