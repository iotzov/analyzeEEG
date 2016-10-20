function permutationList = make_perm_list(Nsubj,subj)

% make_perm_list computes all possible pairs of subjects.

% Inputs:
%  Nsubj = The number of subjects
%  subj = The subject that you would like to pair with all others
%         (optional variable)

% Outputs:
%  permutationList: List of all pairs of subjects
%  Nperm: number of pairs

permutation = [1:Nsubj]';

if nargin == 1 
    permutationList = combnk(permutation,2);   
else
    permutation(subj)=[];
    permutationList = [subj*ones(Nsubj-1,1), permutation];
end

end