function [D] = makeDesignMatrix(D,P,data)
%%
% make design matrix from variable information (P)
% 
% INPUT:
%     D     : Single neuron information, [struct]
%     P     : variable information [struct]
%     data  : Cross-validated trial information [struct]
% 
% OUTPUT:
%     D  : Single neuron information, inclusing the design matrix [struct]
% 
% Sorry for not clean code...
 
%% make design matrix of each variable in each trial

time = D.time;
TE = D.TE;
dt = D.time(2) - D.time(1);
D.dt = dt;

idx_rt = find(TE.ReactionTime' > 0 & TE.ReactionTime' < 0.5 & abs(TE.stimulus) > 0);
RTmax = max(TE.ReactionTime(idx_rt));

idx_mt = find(TE.MT > 0 & abs(TE.stimulus) > 0);
MTmax = max(TE.MT(idx_mt));

for trial_i = 1:TE.nTrials
    for param_i = 1:length(P)
        switch P{param_i}.name
            case 'Stimulus_L'
                if TE.StimulusIntensity_Left(trial_i) > 0
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'Stimulus_R'
                if TE.StimulusIntensity_Right(trial_i) > 0
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'pre_move'
                if TE.ReactionTime(trial_i) > 0
                    delta  = round(TE.ReactionTime(trial_i),2) + P{param_i}.window(1) : dt :...
                        round(TE.ReactionTime(trial_i),2) + P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'Choice'
                for i = 1:length(P)
                    if strcmp(P{i}.name,'pre_move')
                        idx = i;
                    end
                end
                switch TE.ChoiceDir(trial_i)
                    case 0
                        P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                    case 1
                        P{param_i}.D_pre{trial_i} = P{idx}.D_pre{trial_i};
                    case 2
                        P{param_i}.D_pre{trial_i} = P{idx}.D_pre{trial_i} * -1;
                end
                
            case 'prevRew'
                if TE.preRewarded(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'prevRew_L'
                if TE.preRewarded_left(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'prevRew_R'
                if TE.preRewarded_Right(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'prevRew_C'
                if TE.preRewarded_Center(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'prevFail_C'
                if TE.preFail_center(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'prevRew_Side'
                if TE.preRewarded_Side(trial_i) == 1
                    delta  = P{param_i}.window(1) : dt :P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            case 'RT'
                if ismember(trial_i,idx_rt)
                    relRT = TE.ReactionTime(trial_i) / RTmax;
                    P{param_i}.D_pre{trial_i} = ones(1,length(time))*relRT;
                else
                    P{param_i}.D_pre{trial_i} = zeros(1,length(time));
                end
                
            case 'MT'
                if ismember(trial_i,idx_mt)
                    relMT = TE.MT(trial_i) / MTmax;
                    P{param_i}.D_pre{trial_i} = ones(1,length(time))*relMT;
                else
                    P{param_i}.D_pre{trial_i} = zeros(1,length(time));
                end
                
            case 'motor'
                if TE.ReactionTime(trial_i) > 0
                    delta  = round(TE.ReactionTime(trial_i),2) + P{param_i}.window(1) : dt :...
                        round(TE.ReactionTime(trial_i),2) + P{param_i}.window(2) + dt;
                    delta = round(delta,2);
                    temp = zeros(length(P{param_i}.timeBins),length(time));
                    
                    [~, ia, ib] = intersect(delta,time);                    
                    for i = 1:length(ia)
                        temp(ia(i),ib(i)) = 1;
                    end
                    
                    P{param_i}.D_pre{trial_i} = temp;
                else
                    P{param_i}.D_pre{trial_i} = zeros(length(P{param_i}.timeBins),length(time));
                end
                
            otherwise
                disp('Error !');
                
        end
    end
end

for param_i = 1:length(P)
    if isfield(P{param_i},'timeBins')
        L(param_i) = length(P{param_i}.timeBins);
    else
        L(param_i) = 1;
    end
    D.paramName{param_i} = P{param_i}.name;
end
D.paramLength = L;


%% concatenate the design matrix of each variable

D.dm_trial = [];
D.dm.all = [];
D.y.all = [];
for i = 1:TE.nTrials
    temp = [];
    for param_i = 1:length(P)
        
        temp = [temp ; P{param_i}.D_pre{i}];
    end
    D.dm_trial{i} = temp;
    D.dm.all = [D.dm.all D.dm_trial{i}];
    D.y.all = [D.y.all D.spsth(i,:)];
end

D.nFold = length(data.test);
for cv_i = 1:length(data.test)
    idx = [];
    idx.train = data.train{cv_i};
    idx.test = data.test{cv_i};
    
    D.dm.trn{cv_i} = [];
    D.y.trn{cv_i} = [];
    for idx_i = 1:length(idx.train)
        D.dm.trn{cv_i} = [D.dm.trn{cv_i} D.dm_trial{idx.train(idx_i)}];
        D.y.trn{cv_i} = [D.y.trn{cv_i} D.spsth(idx.train(idx_i),:)];
    end
    
    D.dm.test{cv_i} = [];
     D.y.test{cv_i} = [];
    for idx_i = 1:length(idx.test)
        D.dm.test{cv_i} = [D.dm.test{cv_i} D.dm_trial{idx.test(idx_i)}];
        D.y.test{cv_i} = [D.y.test{cv_i} D.spsth(idx.test(idx_i),:)];
    end
end
    
D.data = data;

% confirm the design matrix
drawDesignMatrix(D)

end