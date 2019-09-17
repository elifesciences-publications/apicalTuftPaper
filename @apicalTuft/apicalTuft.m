classdef apicalTuft < skeleton
    %APICALTUFT This is a class for manipulating and extracting information
    % from annotation of apical tufts and their associated axons
    
    % Author: Ali Karimi <ali.karimi@brain.mpg.de>
    
    properties
        legacyGrouping=true;
        l2Idx=[];
        dlIdx=[];
        groupingVariable=table();
        dataset='';
        tracingType='';
        outputDir='';
        apicalType={};
        syn={};
        synExclusion=[];
        synGroups={};
        synGroups2remove={};
        synLabel={};
        synCenterTPA=false;
        seed=[];
        bifurcation='bifurcation';
        soma='soma';
        start='start';
        datasetProperties = struct( 'dimPiaWM', [],...
            'correction', [],'highResBorder',[],'L1BorderInPixel',...
            [],'bbox',[]);
        fixedEnding=[];
        % This property is to hold the correspondence information between
        % after and before application of splitCC 
        connectedComp=struct('treeIdx',[],'nodeID',[],...
            'synIDPre',table(),'synIDPost',table(),...
            'splitDone',false,'emptyTracing',false);
        % This is for distnace to soma analysis
        distSoma=struct('synBinCount',[],'inhRatioRelSoma',[],...
            'acceptableInhRatios',[],'synDistance2Soma',[]);
    end
    
    methods
        function obj = apicalTuft(nmlName,configName)
            % APICALTUFT Construct an instance of the apical tuft class
            annotationDir=util.dir.getAnnotation;
            % Give a warning if the name of nml does not follow
            % datasetName_tracingType
            nameSplit=strsplit(nmlName,'_');
            if(length(nameSplit)~=2)
                warning('nmlName does not follow datasetName_tracingType');
            end
            nmlNameData=struct('datasetName',nameSplit{1},...
                'tracingType',nameSplit{2});
            % Set the configuration name to tracingType if not explicitly
            % given
            if ~exist('configName','var') || isempty(configName)
                configName=nmlNameData.tracingType;
            end
            % Try reading json file if it is present, compatible with
            % skeleton tracings without a json file
            try
                properties=config.(configName);
            catch
                properties=[];
                disp ...
                    ('The annotation does not have the configuration file check +config')
            end
            % Construct the skeleton object
            annotationDir=fullfile(annotationDir,nameSplit{2});
            nmlName=fullfile(annotationDir,nmlName);
            obj@skeleton(nmlName);
            
            obj.dataset=nmlNameData.datasetName;
            obj.tracingType=nmlNameData.tracingType;
            obj=obj.readProperties(properties);
            
            % Get tree indices of the layer 2 and deep layer apical dendrites
            obj=obj.updateGrouping;
            % Set dataset properties if available
            obj=obj.setDatasetProperties;
            % Sort trees by name
            obj=obj.sortTreesByName;
        end
        % Set the properties from the configuration file
        function obj=readProperties(obj,properties)
            if ~isempty(properties)
                for fn = fieldnames(properties)'
                    if~iscell(properties.(fn{1}))
                        obj.(fn{1}) = properties.(fn{1});
                    else
                        obj.(fn{1}) = properties.(fn{1})';
                    end
                end
            end
        end
        
        % Returns the uniqueTableID
        function strings=treeUniqueString(obj,treeIndices)
            if ~exist('treeIndices','var') || isempty(treeIndices)
                treeIndices = 1:obj.numTrees;
            end
            
            strings=cell(length(treeIndices),1);
            cc=1;
            for tr=treeIndices(:)'
                strings{cc}=[obj.filename,'_',obj.names{tr},'_',num2str(tr,'%0.3u')];
                cc=cc+1;
            end
        end
        % Method definitions for methods in separate files
        obj=appendString2Syn(obj,treeIndices,strings)
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
        [bifurcationCoord] = getBifurcationCoord(obj,treeIndices,toNM);
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
    end
    
    methods (Static)
        % Compares tables based on their first variable (treeIndex)
        [ ] = compareTwoTables( table1,table2 )
        % returns the names of the nml files from different tracing types
        [out]= nmlName();
        [ ]=pairwiseIntersection(synapses);
        [skel] = getObjects(type,configName,returnTable)
        [outputOfMethod] = applyMethod2ObjectArray...
            (apTuftArray,method, separategroups,...
            createAggregate, annotationType,varargin);
        outputOfMethod=applyLegacyGrouping...
            (apTuftArray,method, separategroups, ...
            createAggregate,varargin);
        outputOfMethod=applyNewGrouping...
            (apTuftArray,method, separategroups, ...
            createAggregate, annotationType,varargin)
        [apTuftObj] = removeGroupingBifurcation(apTuftObj);
        [apTuftObj] = groupInhibitorySpines(apTuftObj)
        [skels] = deleteDuplicateBifurcations(skels);
        [apTuft] = skeletonConverter(apTuft,skel);
        [scaledCoords]=setScale(coords,scale);
    end
end
