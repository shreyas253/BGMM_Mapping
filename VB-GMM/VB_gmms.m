% (C) 2016 Shreyas Seshadri, Ulpu Remes and Okko Rasaen
% MIT license
% For license terms and references, see README.txt
function [ res ] = VB_gmms( x,prior,op )
%VB_GMMS - various Bayesian GMM learners
% INPUTS
%   x = data N*D
%   prior = object with different prior values depending on model type
%       'Full' and 'Tied' - m0, beta0, W0 and v0 (normal whisart - see Bishop)
%       'Diag' - m0, beta0, a0 and b0 (normal Gamma - see (http://www.albany.edu/~yy298919/realvb.pdf))
%       'Fixed' - m0,Pres0(params of gaussain modelling mean) and PresMain(fixed/known precision)
%   op = object vairous options
%       op.Pi_Type = 'DP', 'DD' or 'PYP'(include prior.g)
%       op.cov_Type = 'Tied', 'Full', 'Diag' or 'Fixed'
%       op.init_Type = 'random' or 'self'(include op.Init_r = initial reponsibilities)
%       op.repeats = no of reapeats of the whole EM procedure (e.g. 10 or 20)
%       op.stopCrit = 'freeEnergy' or 'number'(include op.noStop = number of EM iterations)
%        op.max_num_iter = maximum no of EM iterations 
%        op.K = max number of clusters
%        op.freethresh = threshold for freeEnergy(e.g. 1e-6)
%        op.reorder = binary to control whether to reorder (in descending) after each EM iteration 


[N,D] = size(x);
% seed = rand('state');
% res.seed = seed;


for itr = 1:op.repeats
    if strcmp(op.init_Type,'random')
        r = rand(N,op.K);
        r = r./repmat(sum(r,2),1,op.K);
    elseif strcmp(op.init_Type,'self')
        r = op.Init_r;        
    end
    [post,~] = postUpdate(x,r,prior,op);
    whileCheck =1;
    itr2=0;
    oldFreeEnergy = inf;
    fE = [];
    while whileCheck
        itr2 = itr2+1;
        [r,extra_E] = updateR(x,post,op); % E step
        if op.reorder
            [extra_E,r] = reorderFE(extra_E,r,op);
        end
        [post,extra_M] = postUpdate(x,r,prior,op); % M step
        extra = catstruct(extra_E,extra_M);
        %[~,fE(1,itr2),fE(2,itr2),fE(3,itr2),fE(4,itr2),fE(5,itr2),fE(6,itr2)] = freeEnergyCalc(prior,post,r,op,extra);
        if strcmp(op.stopCrit,'freeEnergy') 
            newFreeEnergy = freeEnergyCalc(prior,post,r,op,extra);
            fE2(itr2) = newFreeEnergy;
            freeEnergyDiff = (newFreeEnergy - oldFreeEnergy)/newFreeEnergy;
            if ((abs(freeEnergyDiff)<op.freethresh) && (itr2>20)) || (itr2>op.max_num_iter)
                whileCheck = 0;
            end 
            oldFreeEnergy = newFreeEnergy;
        elseif strcmp(op.stopCrit,'number')
            if (itr2 == op.noStop) || (itr2>op.max_num_iter)
                whileCheck = 0;
            end 
        end
    end
    disp(['no of VBGMM Iterations required: ' num2str(itr2)])
    [~,res.z{itr}] = max(r,[],2);
    res.Nk{itr} = extra.Nk;
%    res.fE{itr} = fE;
    res.post{itr} = post;
end


