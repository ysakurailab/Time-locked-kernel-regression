function [data] = divideTrials(TE,nFold)
%%
% divide trials into training and testing datasets
% 
% INPUT:
%     TE    : Trial information, [struct]
%     nFold : number of fold (e.g. 10) [double]
% 
% OUTPUT:
%     data  : data which is diveided into n fold dataset
% 
% In our data, stimulus was emitted from left, right, or omitted in equal proportion (1/3)
% To avoid bias in favor of one condition over the others,
% we matched the number of left-, right-, or no-stimulus trials used for model training.

%% 

idx = [];
idx.stimL = find(TE.StimulusIntensity_Left > 0);
idx.stimR = find(TE.StimulusIntensity_Left < 0);
idx.others = find(TE.StimulusIntensity_Left == 0);
idx.all = 1:TE.nTrials;

c = [];
c.stimL = cvpartition(ones(size(idx.stimL)),'KFold',nFold,'Stratify',true);
c.stimR = cvpartition(ones(size(idx.stimR)),'KFold',nFold,'Stratify',true);
c.others = cvpartition(ones(size(idx.others)),'KFold',nFold,'Stratify',true);

c.all = cvpartition(ones(1,TE.nTrials),'KFold',nFold,'Stratify',true);

data = [];
for i = 1:c.stimL.NumTestSets
    data.train{i} = sort([idx.stimL(c.stimL.training(i)); idx.stimR(c.stimR.training(i)) ; idx.others(c.others.training(i))]);
    data.test{i} = sort([idx.stimL(c.stimL.test(i)) ; idx.stimR(c.stimR.test(i)) ; idx.others(c.others.test(i))]);
end

end