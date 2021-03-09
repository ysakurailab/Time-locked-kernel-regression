function [R2, DE, J, F] = encVariable(D, par,varargin)
%%
% Preparing the design matrix and fitting the empirical data
% 
% INPUT:
%     D     : Single neuron information, [struct]
%                    including time (s), spsth (smoothed firing rate), TE (trial information) 
%     par   : parameter information [struct]
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


%% default setting and input setting setting
d = struct;
d.dt = 0.01;
d.window = [0 0.4];
d.nFold = 10;

if length(varargin) > 1
    for i = 1:length(varargin)/2
        d.(varargin{2*i-1}) = varargin{2*i};
    end
end

%% store the variable information
P = [];
for i = 1:length(par)
    P{i} = setP(par(i).name,par(i).window,d);
end


%% main analysis
tic
%dividing the data for cross validation
data = divideTrials(D.TE,d.nFold);

%make design matrix 
[D] = makeDesignMatrix(D,P,data);

%fit the model to empirical data 
[R2, DE, J, F] = encodingModelFit(D);
toc


end