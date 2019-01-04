nmlName={'S1_Bifurcations','V2_Bifurcations',...
    'PPC_Bifurcations','ACC_Bifurcations'};

% Name are for matching with ratios later
bifurcationAngleL2=[];
bifurcationAnglesdl=[];
namesl2ForAngles={};
namesdlForAngles={};
for dataset=1:4
    skel=apicalTuft(nmlName{dataset});
    %Get densities
    skeltrimmed=skel.getBackBone;
    bifurcationNodes=skeltrimmed.getNodesWithComment('bifurcation');
    startNodes=skeltrimmed.getNodesWithComment('start');
    % Make sure the bifurcation and start (soma side) of each tracing is
    % unique
    assert(all(cellfun(@(x) length(x)==1,startNodes)));
    assert(all(cellfun(@(x) length(x)==1,bifurcationNodes)));
    
    for tree=(skeltrimmed.l2Idx)'
        [AnglesPerPath, Endpoints] = bifurcation.angle.FindAllAngles(skeltrimmed, tree,...
            bifurcationNodes{tree});
        assert(length(AnglesPerPath{Endpoints==startNodes{tree}})==1);
        bifurcationAngleL2=[bifurcationAngleL2;AnglesPerPath{Endpoints==startNodes{tree}}];
        namesl2ForAngles=[namesl2ForAngles;...
            {[skeltrimmed.filename,'_',skeltrimmed.names{tree},'_',num2str(tree,'%0.3u')]}];
    end
    for tree=(skeltrimmed.dlIdx)'
        [AnglesPerPath, Endpoints] = bifurcation.angle.FindAllAngles(skeltrimmed, tree,...
            bifurcationNodes{tree});
        assert(length(AnglesPerPath{Endpoints==startNodes{tree}})==1);
        bifurcationAnglesdl=[bifurcationAnglesdl;AnglesPerPath{Endpoints==startNodes{tree}}];
        namesdlForAngles=[namesdlForAngles;...
            {[skeltrimmed.filename,'_',skeltrimmed.names{tree},'_',num2str(tree,'%0.3u')]}];
    end
    clear bifurcationNodes startNodes
end




%% Plotting part
fh=figure;ax=gca;
colors=[{l2color};{dlcolor}];
horizontalLocation=num2cell([1.5:2:4]');
angles{1}=bifurcationAngleL2;
angles{2}=bifurcationAnglesdl;
util.plot.boxPlotRawOverlay(angles(:),horizontalLocation,'boxWidth',1.5,'color',colors);
ylim([0,180]);
x_width=12;
y_width=10;
ylabel('Branching angles (Degrees)')
xticklabels({'Layer 2', 'Deeper Layer'})
outputFolder='/mnt/mpibr/data/Data/karimia/presentationsWriting/Talks/progressReport06082018/';
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputFolder,'bifurcationAngle');

%% Matching with the inhibitory ratio
% For this you need the ratios from Figure1.C
l2RatiosInh=ratios{1,5};
dlRatiosInh=ratios{2,5};

% Make sure the order of trees in angle measurement and inhibitory ratio
% measurements match
assert(all(strcmp(l2RatiosInh.treeIndex,namesl2ForAngles)));
assert(all(strcmp(dlRatiosInh.treeIndex,namesdlForAngles)));
fh=figure;ax=gca;

util.plot.scatter([bifurcationAngleL2';l2RatiosInh.Shaft'],l2color)
hold on;util.plot.scatter([bifurcationAnglesdl';dlRatiosInh.Shaft'],dlcolor);

ylim([0 1]);
xlim([60,180]);
x_width=12;
y_width=10;
legend({'Layer 2', 'Deep layer'},'Location','NorthWest');
xlabel('Branching angles (Degrees)')
ylabel('Inhibitory synapse fraction')

util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputFolder,'bifurcationAngle');


%% Correlation coefficient

l2AngleInh=[bifurcationAngleL2';l2RatiosInh.Shaft']'
dlAngleInh=[bifurcationAnglesdl';dlRatiosInh.Shaft']';
l2correlation=corrcoef(l2AngleInh);
dlcorrelation=corrcoef(dlAngleInh);
alltogether=corrcoef([l2AngleInh;dlAngleInh]);

