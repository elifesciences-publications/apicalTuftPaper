% Load axon switching fraction
outputFolder=fullfile(util.dir.getFig(3),'correctionforAxonSwitching');

m=matfile(fullfile(util.dir.getAnnotation,'matfiles',...
    'axonSwitchFraction.mat'));
axonSwitchFraction=m.axonSwitchFraction;

%% Plot
util.setColors;
colors = {{l2color,l3color,l5color,l5Acolor},{l2color,dlcolor,l5Acolor}};
layers = {'L1','L2'};target = {'Shaft','Spine'};
xlocation = [1,3;2,4];

fname='Prediction Accuracy';
fh=figure('Name',fname);ax=gca;
hold on
for l = 1:length(layers)
    for t =  1:length(target)
        curSwitchFactor = axonSwitchFraction.(layers{l}).(target{t});
        for c=1:length(curSwitchFactor)
            curLoc = xlocation(l,t) ;
            curAccuracy = (1-curSwitchFactor(c))*100;
            scatter(curLoc,curAccuracy,20,colors{l}{c},'x')
        end
    end
end
xlim([0.5,4.5]); ylim([0,100])
xticks(1:4);xticklabels([]); yticks([0:50:100]);yticklabels([0:50:100]);
    util.plot.cosmeticsSave...
        (fh,ax,3.6,3.2,outputFolder,[fname,'.svg'],...
        'off','on');