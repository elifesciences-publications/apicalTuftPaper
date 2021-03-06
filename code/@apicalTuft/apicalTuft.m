classdef apicalTuft < skeleton
    % apicalTuft a sub-class of the "skeleton" class 
    % (see auxiliaryMethods/@skeleton) for extracting the
    % synaptic and morphological properties of skeleton reconstructions 
    % from their comment strings and node coordinates/edgeLists.
    % This class is designed for use with annotations of apical tufts and 
    % their associated axons
    
    % Author: Ali Karimi <ali.karimi@brain.mpg.de>
    
    properties
        % L2 vs. DL grouping which was then replaced by L2, L3, subtypes of
        % L5 in the larger datasets
        legacyGrouping = true;
        l2Idx = [];
        dlIdx = [];
        % New table variable containg L2, L3 and subtypes of
        % L5 in the larger datasets
        groupingVariable = table();
        % Name of dataset and the type of tracing extracted from NML file
        % name. format: dataset_tracingType.nml
        dataset = '';
        tracingType = '';
        % outputDirectory: used for writing the skeleton. It is the
        % directory containing the annotation
        outputDir = '';
        % Types of apical dendrites in the annotation. This is based on the
        % treeName used for distinguishing each type
        apicalType = {};
        % Comment strings to get the synapse nodes
        syn = {};
        % Comment string to exclude the synapse. This is used to exclude
        % synapses which are not clear (unsure decision by the annotator)
        synExclusion = [];
        % Grouping tree name groups into one common group
        synGroups = {};
        % remove synapses from a mother tree group (see getSynIdx method)
        synGroups2remove = {};
        % The label of groups, the size should match the final number of
        % syn groups
        synLabel = {};
        synCenterTPA = false;
        % The seed string
        seed = [];
        % comment strings for bifurcation, soma and the start of the
        % bifurcation annotation
        bifurcation = 'bifurcation';
        soma = 'soma';
        start = 'start';
        % See setDatasetProperties: used for the Suppl. Fig. 7
        datasetProperties = struct( 'dimPiaWM', [],...
            'correction', [],'highResBorder',[],'L1BorderInPixel',...
            [],'bbox',[]);
        fixedEnding = [];
        % This property is to hold the correspondence synaptic information 
        % before and after splitting skeletons (e.g. Fig. 7, Fig. Suppl. 1) 
        connectedComp = struct('treeIdx',[],'nodeID',[],...
            'synIDPre',table(),'synIDPost',table(),...
            'splitDone',false,'emptyTracing',false);
        % Same as previous for splitting skeletons relative to distance to
        % soma Fig. 7c
        distSoma = struct('synBinCount',[],'inhRatioRelSoma',[],...
            'acceptableInhRatios',[],'synDistance2Soma',[]);
    end
    
    methods
        % Constructor
        function obj = apicalTuft(nmlName,configName)
            % APICALTUFT Construct an instance of the apical tuft class
            annotationDir = util.dir.getAnnotation;
            % Give a warning if the name of nml does not follow
            % datasetName_tracingType
            nameSplit = strsplit(nmlName,'_');
            if(length(nameSplit) ~= 2)
                warning('nmlName does not follow datasetName_tracingType');
            end
            nmlNameData = struct('datasetName',nameSplit{1},...
                'tracingType',nameSplit{2});
            % Set the configuration name to tracingType if not explicitly
            % given
            if ~exist('configName','var') || isempty(configName)
                configName = nmlNameData.tracingType;
            end
            % Try getting the configuration from +config package
            try
                properties = config.(configName);
            catch
                properties = [];
                disp ...
                    ('The annotation does not have the configuration file check +config')
            end
            % Construct the skeleton object
            annotationDir = fullfile(annotationDir,nameSplit{2});
            nmlName = fullfile(annotationDir,nmlName);
            % Skeleton object construction
            obj@skeleton(nmlName);
            
            obj.dataset = nmlNameData.datasetName;
            obj.tracingType = nmlNameData.tracingType;
            obj = obj.readProperties(properties);
            
            % update the tree groupings
            obj = obj.updateGrouping;
            % Set dataset properties if available
            obj = obj.setDatasetProperties;
            % Sort trees by name
            obj = obj.sortTreesByName;
        end
        
        % Set the properties of the apicalTuft object from structure output
        % of +config
        function obj = readProperties(obj,properties)
            if ~isempty(properties)
                for fn = fieldnames(properties)'
                    if ~iscell(properties.(fn{1}))
                        obj.(fn{1}) = properties.(fn{1});
                    else
                        obj.(fn{1}) = properties.(fn{1})';
                    end
                end
            end
        end
        % Method definitions for methods in separate files
        obj = appendString2Syn(obj,treeIndices,strings)
        [skel] = reformatApicalTreeNames(skel, treeIndices,newNameStrings,method)
        obj = setDatasetProperties(obj);
        [] = checkSeedUniqueness(obj,treeIndices);
        [skel] = reformatCommentsWithIdx...
            (skel,treeIndices,nodeIdx,comment, rep,repMode);
        [seedComments] = getSeedIdx(obj,treeIndices);
        [unsureIdx] = getUnsureIdx(obj,treeIndices);
        [skel] = appendCommentWithIdx...
            (skel,treeIndices,nodeIdx,commentReplacement);
        [skel] = replaceCommentWithIdx...
            (skel,treeIndices,nodeIdx,rep, comment, repMode)
        [ branchNodes ] = getBranchNodesToDel( skel,tr,realTreeEndings);
        [bifurcationCoord] = getBifurcationCoord(obj,treeIndices,...
            toNm, returnTable)
        [bifurcationComments] = getBifurcationIdx(obj,treeIndices);
        [obj] = convert2PiaCoord(obj,treeIndices);
        [objCommentsAdded,randomIdx] = synRandomSample...
            (obj,synType,numberOfTrees,numberOfSamplesPerTree);
        [obj] = updateL2DLIdx(obj);
        obj = deleteTrees(obj, treeIndices,complement);
        [pathLengthInMicron] = getBackBonePathLength(obj,treeIndices);
        [ dist2soma ] = getSomaDistance( skel,treeIndices,fromString );
        [obj] = removeAllGrouping(obj);
        [obj] = updateGrouping(obj);
        [skel,toKeepNodes] = restrictToBBoxWithInterpolation...
            (skel, bbox, treeIndices, interpolateEdgesFlag);
        [obj, addedEdges]  = addNode(obj, tree_index, coords, ...
            connect_to_ID, varargin);
        [IdxOfSkel2NodesInSkel1] = ...
            nodeIdxToIdxAnotherSkel(skel,skel2,treeIndices);
        [synIdxBackbone] = associateSynWithBackBone...
            (skel,treeIndices,debugPlot);
        [allPaths] = getShortestPaths(skel, treeIndices);
        [nonUniqueCoords] = getNonUniqueNodeCoord(obj,treeIndices);
        [obj] = ...
            deleteNonUniqueNodeCoord(obj,treeIndices);
        skel = sortTreesByName( skel );
        [objCropped] = cropoutLowRes...
            (obj,treeIndices,dimLowresBorder,edgeLowRes)
        [objNew] =  splitCC(obj,treeIndices, doVanillaSplit)
        [identifier] = getTreeIdentifier(obj,treeIndices);
        [pL] = pathLength(obj,treeIndices);
        [allInfo] = getFullInfoTableCC(obj,treeIndices);
        [emptyTable] = createEmptyTable(obj,treeIndices,...
            VariableNames,dataType);
        [ synapseObject] = plotSynapses( skel,treeIndices,...
            synCoords,varargin);
        [obj] = matchTreeOrders(obj,objRef);
        [skel] = relSomaDistance(skel,treeIndices,toString,auxSkel)
        [skel] = relSomaBinCountInhRatio(skel,...
            treeIndices,range);
        [skel] = correctionLowresLPtA(skel);
        [totalPathLengthInMicron] = getTotalBackonePath...
            (obj,treeIndices);
        [ apicalDiameter,idx2keep ] = getApicalDiameter(skel,treeIndices);
        [ dist2soma ] = getDistanceBWPoints( skel,treeIndices,pointNames );
        [totalPathLengthInMicron] = getTotalPathLength(obj, treeIndices);
        [NrOfObliques, ListOfCoords] = ...
            getNumberOfObliques(skel,treeIndices);
        strings = treeUniqueString(obj,treeIndices);
    end
    
    methods (Static)
        [ ] = compareTwoTables( table1,table2 )
        [out] = nmlName();
        [ ] = pairwiseIntersection(synapses);
        [skel] = getObjects(type,configName,returnTable)
        [outputOfMethod] = applyMethod2ObjectArray...
            (apTuftArray,method, separategroups,...
            createAggregate, annotationType,varargin);
        outputOfMethod = applyLegacyGrouping...
            (apTuftArray,method, separategroups, ...
            createAggregate,varargin);
        outputOfMethod = applyNewGrouping...
            (apTuftArray,method, separategroups, ...
            createAggregate, annotationType,varargin)
        [apTuftObj] = removeGroupingBifurcation(apTuftObj);
        [apTuftObj] = groupInhibitorySpines(apTuftObj)
        [skels] = deleteDuplicateBifurcations(skels);
        [apTuft] = skeletonConverter(apTuft,skel);
        [scaledCoords] = setScale(coords,scale);
    end
end
