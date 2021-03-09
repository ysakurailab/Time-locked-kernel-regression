function drawPrediction(b,D,time,window)
%%

numShow = 3;
TL = D.TE.nTrials;
B.all = reshape(D.y.all',[length(D.y.all)/TL,TL]);

color{1} = [72, 107, 0]/255;
color{2} = [46, 70, 0]/255;

color{1} = [104, 162, 37]/255;
color{2} = [85, 109, 172]/255;

r = randperm(length(D.data.train));

figure();
tiledlayout(1,numShow,'Padding','compact','TileSpacing','compact');
beta = mean(b,2);
A = [];
for i = 1:numShow
    TL = length(D.data.test{r(i)});

    nexttile;
    hold on;
    yhat = glmval(beta,D.dm.test{r(i)}','identity');
    B.pred = reshape(yhat,[length(yhat)/TL,TL]);
    B.real = reshape(D.y.test{r(i)}',[length(D.y.test{r(i)})/TL,TL]);

    
    p = plot(time,mean(B.real,2),'LineWidth',5,'Color',color{1});
    p = plot(time,mean(B.pred,2),'LineWidth',3,'Color',color{2});
    
    ax{i} = figModulation;
    xlim(window);
    A = [A ax{i}];
end
linkaxes(A,'y');

set(gcf, 'position',[600 400 700 300]);

end

function [ax] = figModulation
ax = gca;
ax.FontName = 'Arial';
ax.FontSize = 15;
ax.LabelFontSizeMultiplier = 1.5;
ax.LineWidth = 1;
ax.TickDir = 'out';
box off;
end