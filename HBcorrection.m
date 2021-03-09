function [J] = HBcorrection(p)
%%
alpha = 0.05;
n = length(p);
nCorr = n;


[B,idx] = sort(p);

for i = 1:length(B)
    if B(i) < alpha/nCorr
        J(idx(i)) = 1;
        nCorr = nCorr - 1;
    else
        J(idx(i)) = 0;
    end
end
        

end