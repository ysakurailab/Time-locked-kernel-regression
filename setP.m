function [P] = setP(name,window,d)

P = struct;
P.name = name;

if length(window) > 1
    P.window = window;
    P.timeBins = round([window(1):d.dt:window(2)],2);
end

switch name
    case 'Stimulus_L'
        P.var = {'Present','Absent'};
        
    case 'pre_move'
        P.var = {'Present','Absent'};
        
    case 'Choice'
        P.var = {'Left', 'Right'};

    case 'Movement'
        P.var = {'Left', 'Right'};
        
    case 'prevRew'
        P.var = {'Present','Absent'};

    case 'prevRew_L'
        P.var = {'Present','Absent'};
        
    case 'prevRew_R'
        P.var = {'Present','Absent'};
        
    case 'prevRew_C'
        P.var = {'Present','Absent'};
        
    case 'prevFail_C'
        P.var = {'Present','Absent'};
        
    case 'motor'
        P.var = {'Present','Absent'};
        
    case 'prevRew_Side'
        P.var = {'Present','Absent'};
        
    case 'RT'
        P.var = {'Present','Absent'};
        
    case 'MT'
        P.var = {'Present','Absent'};
        
end

end