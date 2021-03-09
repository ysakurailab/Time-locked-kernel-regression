function [R2, DE, J, F] = encodingModelFit(D)
%%
% Preparing the design matrix and fitting the empirical data
% 
% INPUT:
%     D     : Single neuron information, [struct]
%                    including time (s), spsth (smoothed firing rate), TE (trial information) 
%                    and design matrix information
% 
% OUTPUT:
%     R2    : R-square [struct]
%     DE    : Deviance explined [struct]
%     J     : selectivity matrix for each task variable [boolian (0 or 1)]
%     F     : F-statics [struct]
% 
% In this data, 11 task variables used so that R2, DE, and F contains 
% 10-fold cross validated value in each 11 fields.
% J contains the 11 boolian values (1 is significantly selective), which
% corresponds to the R2 field order.
%
% In this demo code, we used 99% ridge, 1% lasso regularization (elastic-net)
% If you want to change the ratio, change the option.alpha = ####; % lasso L1

% If you don't need check the reconstructed firing rate, you types fig = 0;
fig = 1;

%% Fit the model

window = D.time;
time_idx = find(D.time >= window(1) & D.time <= window(end));

nFold = D.nFold;
paramPos = [0 cumsum(D.paramLength)];

% initialize and set the elastic net option
option = [];
option.alpha = 0.01; % lasso L1
option.maxit = 1000;
option.nlambda = 40;
option = glmnetSet(option);
% option.lambda = 0.5;


% fitting 
R2 = [];
DE = [];
F = [];
for cv_i = 1:nFold
    % fit the full model
    
    TL = length(D.data.test{cv_i}); 
    
    % fit the data with 3-cross-validated glmnet 
    fit = cvglmnet(D.dm.trn{cv_i}',D.y.trn{cv_i}','gaussian',option,'mse',3,[],'true');
    a = cvglmnetCoef(fit,'lambda_min');
    yhat = cvglmnetPredict(fit,D.dm.test{cv_i}','lambda_min');
 
    beta(:,cv_i) = a;
    
    B.pred = reshape(yhat,[length(yhat)/TL,TL]);
    B.real = reshape(D.y.test{cv_i}',[length(yhat)/TL,TL]);
    
    B.pred = B.pred(time_idx,:);
    B.real = B.real(time_idx,:);
    
    b0 = mean(D.y.trn{cv_i}(:));

    null_dev = calcSSR(ones(size(B.real(:))) * b0,B.real(:));
    dev = calcSSR(B.pred(:),B.real(:));
    DE.real(cv_i) = (null_dev - dev)/null_dev;
        
    R2.real(cv_i) = corr(B.pred(:),B.real(:)).^2;
    [F.real(cv_i)] = calcFstats_enc(B.pred(:),B.real(:),length(a));
    
    fit = [];
    for param_i = 1:length(D.paramName)
        % fit the partial model which target kernel (variable) set to zero
        
        idx = paramPos(param_i)+1:paramPos(param_i+1);
        temp = D.dm.trn{cv_i};
        temp(idx,:) = 0;
        
        temp_test = D.dm.test{cv_i};
        temp_test(idx,:) = 0;

        fit = cvglmnet(temp',D.y.trn{cv_i}','gaussian',option,'mse',3,[],'true');
        a = cvglmnetCoef(fit,'lambda_min');
        yhat = cvglmnetPredict(fit,temp_test','lambda_min');
        
        B.pred = reshape(yhat,[length(yhat)/TL,TL]);
        B.real = reshape(D.y.test{cv_i}',[length(yhat)/TL,TL]);
        
        b0 = mean(D.y.trn{cv_i}(:));
        
        [F.(D.paramName{param_i})(cv_i)] = calcFstats_enc(B.pred(:),B.real(:),length(a));
        null_dev = calcSSR(ones(size(B.real(:))) * b0,B.real(:));

        dev = calcSSR(B.pred(:),B.real(:));

        DE.(D.paramName{param_i})(cv_i) = 1 - dev/null_dev;
        R2.(D.paramName{param_i})(cv_i) = corr(B.pred(:),B.real(:)).^2;
    end
    
%     [LASTMSG, LASTID] = lastwarn;
%     warning('off', LASTID);

    
    X = [num2str(cv_i),'/',num2str(nFold),' folds'];
    disp(X);
end
    
if fig
    % plot the empirical and predicted firing rates
    drawPrediction(beta,D,D.time,[-0.1 0.4]);
end

% calculate p-value for each task variable
J = [];
for param_i = 1:length(D.paramName)
    [J(param_i) p(param_i)] = ttest(R2.real,R2.(D.paramName{param_i}));
end
% Holm-bonferroni correction 
[J] = HBcorrection(p);

% draw performance of the full and partial model 
if fig
    drawResults(R2);
%     drawResults(F);
%     drawResults(DE);
end

end

function [SSR] = calcSSR(pred,y)
s = (pred - y).^2;
SSR = sum(s);
end

function [F] = calcFstats_enc(pred,y,p)
%%
SSe = sum((pred - y).^2);

SSy_h = sum((pred - mean(pred)).^2);

F = (SSy_h / p) / (SSe / (length(y) - p - 1));
end

function [y] = sem(x)
y = std(x)/sqrt(length(x));
end

function drawResults(X)
f = fieldnames(X);

figure();
hold on;
for i = 1:length(f)
    if strcmp(f{i},'real')
        errorbar(i,mean(X.(f{i})),sem(X.(f{i})),'LineWidth',2,'Marker','.','MarkerSize',20,...
            'Color','r','CapSize',0);
    else
        errorbar(i,mean(X.(f{i})),sem(X.(f{i})),'LineWidth',2,'Marker','.','MarkerSize',20,...
            'Color',[.2 .2 .2],'CapSize',0);
    end
end
ax = figModulation;
xticks(1:length(f));
xticklabels(f);
xtickangle(90);
xlim([0.5 length(f)+0.5]);
ylabel('R sq');
set(gcf, 'position',[600 400 380 300]);
end