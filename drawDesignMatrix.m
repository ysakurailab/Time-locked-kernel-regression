function drawDesignMatrix(D)
%%
showNTrials = 4;
r = randperm(D.TE.nTrials);
pl = [0 cumsum(D.paramLength)];
tl = cumsum(repmat(size(D.dm_trial{1},2),1,showNTrials));

dm = [];
for i = 1:showNTrials
    dm = [dm D.dm_trial{r(i)}];
end

figure();
hold on;
imagesc(dm);
colormap();
caxis([-1 1]);
ax = figModulation;
ax.YDir = 'reverse';
ax.XTickLabel = [];
ax.YTickLabel = [];
ax.TickLength = [0 0];
xlim([0 size(dm,2)]);
ylim([0 size(dm,1)]);

for i = 1:length(pl)-1
    plot(ax.XLim,[pl(i+1)+0.5 pl(i+1)+0.5],'Color','k','LineWidth',0.5);
end
for i = 1:length(tl)
    plot([tl(i)+0.5 tl(i)+0.5],[ax.YLim],'Color','k','LineWidth',0.5);
end
set(gcf, 'position',[ 200  200  370 280]);




end