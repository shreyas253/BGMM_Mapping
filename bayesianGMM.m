function [ xPred,vbClustRes, postPred ] = bayesianGMM( x,X,K )
%BAYESIANGMM - function that returns conditional posterior predictive for a VB-GMM
% INPUTS
% x = [nGiven x dimGiven] data with missinkg features
% X = [nOrig x dimOrig] original data with full features to cluster
% K = number of clusters (note in Bayesian clustering the number of clusters found can be lower than this)
% OUTPUTS
% xPred     = mean estimate of conditional posterior predictive of the missing features in x, p(xPred|x,X,K)
% vbClustRes= the Bayesian GMM 
% postPred  = the posterior proedictive model p(x|VB-GMM)
% By: Shreyas Seshadri, Ulpu Remes and Okko R?a?nen. Last update - 10.10.2016

currPath = pwd;
[nOrig,dimOrig] = size(X);

%% Clustering - VB-DDGMM
if nargin<3
    K=10;
end
addpath([currPath '/VB-GMM/']);

%PRIORS 
prior.alpha = 1; % alpha for the piror weight distr
op.Pi_Type = 'DD'; % prior on weight distr
op.cov_Type = 'Full'; % type of covatriance
prior.m0 = mean(X,1); % paramater of prior NIW distr
prior.beta0 = 1; % paramater of prior NIW distr
prior.W0 = diag(diag(inv(cov(X,1)))); % paramater of prior NIW distr
prior.v0 = dimOrig+2; % paramater of prior NIW distr
op.init_Type = 'random'; % inititialisation
op.K = K; % Max no of clusters
%     op.stopCrit = 'number' %'number' of runs or 'freeEnergy'
%     op.noStop = 250;%
op.stopCrit = 'freeEnergy'; %'number' of runs or 'freeEnergy'
op.freethresh = 1e-6;
op.max_num_iter = 600;
op.reorder = 0;
op.repeats = 1;

%CLUSTERING
vbClustRes = VB_gmms(X,prior,op); % contains z = found cluster indices
%                                            Nk = sum of posterior responsibilities
%                                            post = posterior model parameters 

rmpath([currPath '/VB-GMM/']);


%% Conditional Posterior Predictive
if strcmp(op.cov_Type,'Full')
%   poterior predictive of VB-GMM with conjugate NIW prior is multivariate-T mixture
    postPred.mu = vbClustRes.post{1}.m;
    postPred.nu = vbClustRes.post{1}.v-+1;    
    temp1 = repmat(((vbClustRes.post{1}.beta+1)./(vbClustRes.post{1}.beta .* postPred.nu))',1,dimOrig,dimOrig);
    temp1 = permute(temp1,[3 2 1]);
    temp2 = zeros(size(vbClustRes.post{1}.W));
    for i=1:op.K
        temp2(:,:,i) = inv(vbClustRes.post{1}.W(:,:,i));
    end
    postPred.sigma = temp1 .* temp2;
    postPred.weight = vbClustRes.Nk{1}./sum(vbClustRes.Nk{1});
    
    [xPred,pos_wei1] = multTmm_prediction(x,postPred); % function very similr to gmm_prediction.m except with mult-T distinution
end

end

