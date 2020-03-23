% Get the histogram of path density of axons

% Author: Ali Karimi<ali.karimi@brain.mpg.de>
util.clearAll;
outputDir = fullfile(util.dir.getFig(3),'C');
util.mkdir(outputDir)
debug = false;
c = util.plot.getColors();

%% Get the axonal objects and set the coordinate to distance from pia
apTuft = apicalTuft.getObjects('inhibitoryAxon');
apTuftTrimmed_originalCoord = apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getBackBone',false,false);
apTuftTrimmed = apicalTuft.applyMethod2ObjectArray...
    (apTuftTrimmed_originalCoord,...
    'convert2PiaCoord',false,false);
if debug
    apicalTuft.applyMethod2ObjectArray...
        (apTuftTrimmed,'plot',false,false); %#ok<UNRCH>
end

% Note: Get the bounding bbox (in NM, Y-axis corresponding to pia-WM distance) 
% We then get the maximum depth of annotations from S1, V2, PPC and ACC.
fullbboxes = cellfun(@(x) x.getBbox([],true), table2cell(apTuftTrimmed),...
    'UniformOutput',false);
maxLim = max(cat(2,fullbboxes{:}),[],2);
maxCorticalDepth = [1,maxLim(2)+100];% 100 nm as safety

%% Getting the path density fraction in cortical depth slices.
% These slices are 20 microns thick.
% Initialize
bboxes = cell(1,4);
pathFraction = cell(1,4);
curPathBbox = cell(1,4);
depthSliceThickness = 20000;

% Loop over datasets
for dataset = 1:4
    dimPiaWM = apTuftTrimmed{1,dataset}.datasetProperties.dimPiaWM;
    assert(dimPiaWM == 2, 'All annotations have Y-axis as Pia-WM');
    % Adjust Bbox to the common cortical depths (1, 313 um, respectively)
    % Therefore depth slices are unchanged between datasets, only the XY
    % bounds remain
    curBbox = fullbboxes{dataset};
    curBbox(dimPiaWM,:) = maxCorticalDepth;
    % Get the bounding boxes
    bboxes{dataset} = util.bbox.divideDatasetIntoSlices...
        (curBbox, depthSliceThickness, dimPiaWM);
    % Get the path length in each slice and the total path combined
    curPathBbox = axon.pathDensity.getPathLengthInSlices...
        (apTuftTrimmed{1, dataset}, bboxes{dataset});
    totalPath = sum(curPathBbox,1);
    % Check: compare to total path length before sectioning the data 
    % (threshold = 1 um)
    tP_before = apTuftTrimmed{1,dataset}.getTotalPathLength;
    disp (['Total path diff: ',num2str(tP_before-sum(totalPath))]);
    assert(tP_before-sum(totalPath) < 1, 'Path length check failed')
    % Get fraction of pathlength in each slice
    curFraction = curPathBbox./totalPath;
    assert(all(sum(curFraction,1)-1 < 1e-5), ...
        'Fraction did not sum to 1');
    % Ignore zeros where dataset does not exist
    curFraction(curFraction == 0) = nan;
    % save into structures
    fractionAlongPiaWM.layer2(:,dataset) = curFraction(:,1);
    fractionAlongPiaWM.deep(:,dataset) = curFraction(:,2);
    lengthInMM.layer2(:,dataset) = curPathBbox(:,1)./1e3;
    lengthInMM.deep(:,dataset) = curPathBbox(:,2)./1e3;
    disp(['Dataset done: ',apTuftTrimmed{1, dataset}.dataset]);
end
%% Plot Fig. 3C panel: depth distribution of axonal density along Pia-WM 
% Fig init
fh = figure;ax = gca;
x_width = 1.98729;
y_width = 2.89051;
% Get the mean and the sem of the fractions ignoring depth ranges outside
% each dataset's bound. These are represented by not a number (nan) entries
% in the matrix
means = structfun(@(x)nanmean(x,2),...
    fractionAlongPiaWM,'UniformOutput',false);
sems = structfun(@(x) util.stat.sem(x,[],2),...
    fractionAlongPiaWM,'UniformOutput',false);
dST_InMicron = depthSliceThickness/1000;
yLabels = 10:dST_InMicron:dST_InMicron*16;
hold on
errorbar(means.layer2, yLabels, sems.layer2,...
    'horizontal', 'Color', c.l2color)
errorbar(means.deep, yLabels, sems.deep,...
    'horizontal', 'Color', c.dlcolor)
hold off
set(gca, 'YDir','reverse','XAxisLocation','top',...
    'YTick',yLabels);
% Set proper axis limits (hand-coded)
xlim([0,0.4]); ylim([105,315]);
% Save
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,...
    'pathDensityFraction.svg','on','off');

%% Save excel sheets with fraction along pia-WM
rowNames = arrayfun(@(x) [num2str(x),' um'],...
    10:20:310,'UniformOutput',false);
varNames = {'S1','V2','PPC','ACC'};
tableConstructor = @(array)array2table(array,'VariableNames',...
    {'S1','V2','PPC','ACC'},'RowNames',rowNames);
fractionT = structfun(tableConstructor,fractionAlongPiaWM,'uni',false);
excelFileName = fullfile(util.dir.getExcelDir(3),...
    'Fig3C_fractionPerDepth.xlsx');
util.table.write(struct2table(fractionT,...
    'RowNames',{'pathFraction'},'AsArray',true),...
    excelFileName);
% Decided not to write the raw path distance to excel sheet.
pathT = structfun(tableConstructor,lengthInMM,'uni',false);

%% Fraction of pathLength at each location: Text
pathPerTree = apicalTuft.applyMethod2ObjectArray...
    (apTuftTrimmed_originalCoord,'pathLength',true,false);
totalPatLength = (sum(cellfun(@(x)sum(x.pathLengthInMicron,1), ...
    table2cell(pathPerTree)),2))./1e3;
disp('layer 2 vs. deep total pathlength (mm): ');
disp(totalPatLength);

%% Write the axonal path length and  to excel sheet
excelFileName = fullfile(util.dir.getExcelDir(3),...
    'Fig3C_pathLengthIndividualAxons.xlsx');
util.table.write(pathPerTree, excelFileName);