function [par] = setParam(par,name,window)
% store the parameter information for generalized linear model.
% 
% INPUT:
%     par    : parameter data, [struct]
%     name   : parameter name (e.g. stimulus_L) [str]
%     window : covered window (e.g [0 0.3]) [2 x 1 double]
% 
% OUTPUT:
%     par    : parameter data which stored input information
%


l = length(par);
par(l+1).name = name;par(l+1).window = window;

end