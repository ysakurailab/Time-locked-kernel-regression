function encodingModel
% English
% Full pipeline for time-locked kernel regression for single neuron
% Analysis using 10-fold cross validation with 99% ridge and 1% lasso reguralization (elastic net)
% 
% You can get the R-square (R2), Deviance explained (DE), F-statistic (F),
% and selectivity matrix for task variables (J) after simply running 'encodingModel'
%
% If you want to change the covered window in each task variable, you simply change the input of
% setParam function. 
%      e.g) par = setParam(par,'Stimulus_L',[-0.1 0.2]);
%
% If you want to change the fitting window or number of fold you simply change the input of
% encVariable function. 
%      e.g) [R2, DE, J, F] = encVariable(D,par,'window',[-0.2 0.5],'nFold',5,'dt',0.01);


% 日本語
% これは単一細胞の神経活動をモデル化するtime-locked kernel regressionのコードです。
% 回帰は10-fold cross validationを使用しており、99%リッジ, 1%ラッソ正則化を使用しています(elastic net)
% 
% このencodingModelを実行すると、単一神経細胞の決定係数(R2), 逸脱度(DE),F統計量が計算でき、
% 各変数に対するselectivity ベクター(J)が得られます。


% initialize parameter struct
par = [];

% set the parameters with name and covered time window (s)
par = setParam(par,'Stimulus_L',[-0.0 0.3]);
par = setParam(par,'Stimulus_R',[-0.0 0.3]);
par = setParam(par,'pre_move',[-0.3 0]);
par = setParam(par,'Choice',[-0.3 0]);
par = setParam(par,'motor',[-0.0 0.3]);
% par = setParam_enc(par,'prevRew',[-0.1 0.1]);
par = setParam(par,'prevRew_L',[-0.1 0.1]);
par = setParam(par,'prevRew_R',[-0.1 0.1]);
par = setParam(par,'prevRew_C',[-0.1 0.1]);
par = setParam(par,'prevFail_C',[-0.1 0.1]);
par = setParam(par,'RT',nan);
par = setParam(par,'MT',nan);

% Loading data
load('example neuron.mat');

% get the results of 10-fold cross varidated regression
[R2, DE, J, F] = encVariable(D,par,'window',[-0.1 0.4],'nFold',10,'dt',0.01);

end