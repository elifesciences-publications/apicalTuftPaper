% Get the histogram of path density of axons 
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
util.clearAll;
outputDir=fullfile(util.dir.getFig(2),'B');
util.mkdir(outputDir)
debug=false;

%% Get the axonal objects and set the coordinate to distance from pia
apTuft=apicalTuft.getObjects('inhibitoryAxon');
apTuftTrimmed=apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getBackBone',false,false);
apTuftTrimmed=apicalTuft.applyMethod2ObjectArray(apTuftTrimmed,...
    'convert2PiaCoord',false,false);
if debug
apicalTuft.applyMethod2ObjectArray...
(apTuftTrimmed,'plot',false,false); %#ok<UNRCH>
end
% Get the bboxes and set the limits of the slices we create to 1 and
% max+100 along the pia WM direction
fullbboxes=cellfun(@(x) x.getBbox([],true), table2cell(apTuftTrimmed),...
    'UniformOutput',false);
maxLim=max(cat(2,fullbboxes{:}),[],2);
bboxLimAlongPiaWM=[1,maxLim(2)+100];

%% Initialize
bboxes=cell(1,4);
axonFraction=bboxes;
axonDensity=bboxes;
sliceThickness=20000;
for dataset=1:4
    tic;
    dimPiaWM=apTuftTrimmed{1,dataset}.datasetProperties.dimPiaWM;
    % Adjust Bbox
    curBbox=fullbboxes{dataset};
    curBbox(dimPiaWM,:)=bboxLimAlongPiaWM;
    % Get pathlength in slices
    bboxes{dataset}=util.bbox.divideDatasetIntoSlices...
        (curBbox,sliceThickness,dimPiaWM);
    axonDensity{dataset}=axon.pathDensity.getPathLengthInSlices...
        (apTuftTrimmed{1,dataset}, bboxes{dataset});
    totalPath=sum(axonDensity{dataset},1);
    % Get fraction of pathlength in slices
    axonFraction{dataset}=axonDensity{dataset}./totalPath;
    % Ignore zeros where dataset does not exist
    axonFraction{dataset}(axonFraction{dataset}==0)=nan;
    disp(['Dataset done: ',apTuftTrimmed{1,dataset}.dataset]);
    toc;
end
save(util.addDateToFileName...
    (fullfile(util.dir.getFig(2),'B','axonDensity')),...
    'axonDensity','axonFraction');
%% Plotting along the Pia-WM axis\
outputDir=fullfile(util.dir.getFig(2),'B');
x_width=6;
y_width=4;
axonFractionArray=cat(2,axonFraction{:});
fractionAlongPiaWM.layer2=axonFractionArray(:,1:2:end);
fractionAlongPiaWM.deep=axonFractionArray(:,2:2:end);

fh=figure;ax=gca;
% Get the mean and the sem of the fractions ignoring the nans
means=structfun(@(x)nanmean(x,2),fractionAlongPiaWM,'UniformOutput',false);
sems=structfun(@(x) util.stat.sem(x,[],2),...
    fractionAlongPiaWM,'UniformOutput',false);
sliceThickness=20000;
sliceThicknessInMicron=sliceThickness/1000;
xLabels=10:sliceThicknessInMicron:sliceThicknessInMicron*16;
xLabels=xLabels(6:16);
hold on
errorbar(means.layer2,sems.layer2,'Color',l2color)
errorbar(means.deep,sems.deep,'Color',dlcolor)
hold off
xticks(6:16)
xticklabels(xLabels)
ylim([0,0.4])
xlim([5.5,16.5])
xtickangle(-45)
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,...
    'pathDensityFraction.svg');

%% Fraction of pathLength at each location: Text
pathPerTree = apicalTuft.applyMethod2ObjectArray...
    (apTuftTrimmed,'pathLength',true,false);
totalPatLength=(sum(cellfun(@(x)sum(x.pathLengthInMicron,1), table2cell(pathPerTree)),2))./1e3;
disp('layer 2 vs. deep total pathlength (mm): ')
disp(totalPatLength)








