close all; clear;

%% LOAD DATA
load d2_c0.5_N2500_k10.mat % randomly created data
currPath = pwd;
addpath([currPath '/VB-GMM/']);

X = data(1:2000,:); % change this
x = data(2001:end,1); % change this
xCorr = data(2001:end,2); % change this

%% CLUSTERING
K = 10; %set no of clusters
[ output_data2, pos_wei2 ] = bayesianGMM( x,X,K );

%% ERROR & PLOT
VBGMM_RMS_error = mean(sqrt(sum((output_data2-xCorr).^2,2)))
figure;
subplot(1,2,1);
plot(X(:,1),X(:,2),'r*');
title('Training Data');
subplot(1,2,2);
plot(x,xCorr,'ro');
hold on; plot(x,output_data2,'b*');hold off;
xlim([min(data(:,1)) max(data(:,1))])
ylim([min(data(:,2)) max(data(:,2))])
legend('Original','Estimated','Location','southwest');
xlabel('Given')
ylabel('Found')
title('Testing')


