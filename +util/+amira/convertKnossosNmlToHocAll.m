function y=convertKnossosNmlToHocAll(skel,filename,overWriteEdges,...
    overWriteThickness,emphasizeNodes,useSplines,resolution)
%   Kevin M. Boergens 2013-2015
%   Author: kevin.boergens@brain.mpg.de
%   Author: ali.karimi@brain.mpg.de
% Convert to the old school output of parsenml from skeleton class
if ~exist('resolution', 'var') || isempty(resolution)
    resolution=skel.scale;
end
if ~exist('overWriteEdges', 'var') || isempty(overWriteEdges)
    overWriteEdges=false;
end
if ~exist('overWriteThickness', 'var') || isempty(overWriteThickness)
    overWriteThickness=true;
end
if ~exist('emphasizeNodes', 'var') || isempty(emphasizeNodes)
    emphasizeNodes=false;
end
if ~exist('useSplines', 'var') || isempty(useSplines)
    useSplines=true;
end
skelStruct=convertSkel2SkelStruct(skel);
iirunning=0;
fid=fopen([filename,'.hoc'],'w+');
fprintf(fid,'/* created with nml2hocm */\n');
for iii=1:length(skelStruct)
    a{1}=skelStruct{iii};
    if ~isfield(a{1},'nodes') || (size(a{1}.nodes,1)<2 && ~overWriteEdges)
        continue;
    end
    a_sorted=sortrows([a{1,1}.nodes (1:size(a{1,1}.nodes,1))'],3);
    cast(a_sorted(end,:),'uint16');
    a{1,1}.nodes(a_sorted(end,5),4)=1000;
    listS=makeSegmentList...
        (a{1,1},overWriteEdges,emphasizeNodes);
    
    for ii=1:size(listS,1)
        iirunning=iirunning+1;
        y=listS{ii,1}(:,5);
        x=1:size(y,1);
        xx=find(y-1.5);
        yy=y(y~=1.5);
        if size(xx,1)<1
            xx=[1 2];
            yy=[27 27];
            
        else
            if size(xx,1)<2
                if xx(1)==x(1)
                    xx=[xx x(end)];
                    yy=[yy 27];
                else
                    xx=[x(1) xx];
                    yy=[27 yy];
                end
            end
        end
        y=interp1(xx,yy,x);
        if useSplines
            listS{ii,1}(:,5)=y;
        end
        if overWriteThickness
            listS{ii,1}(:,5)=100;
        end
        
        fprintf(fid,'\n{create adhoc%i}\n',iirunning);
        fprintf(fid,'{access adhoc%i}\n',iirunning);
        for jj=1:ii-1
            if listS{jj,1}(1,1)==listS{ii,1}(1,1)
                fprintf(fid,'{connect adhoc%i(0), adhoc%i(0)}\n',iirunning,jj+iirunning-ii);
                break;
            end
            if listS{jj,1}(end,1)==listS{ii,1}(1,1)
                fprintf(fid,'{connect adhoc%i(1), adhoc%i(0)}\n',iirunning,jj+iirunning-ii);
                break;
                
            end
            
        end
        fprintf(fid,'{nseg = 1}\n');
        fprintf(fid,'{strdef color color = "White"}\n');
        fprintf(fid,'{pt3dclear()}\n');
        for jj=listS{ii,1}'
            fprintf(fid,'{pt3dadd(%f,%f,%f,%f)}\n',jj(2)*resolution(1),jj(3)*resolution(2),jj(4)*resolution(3),jj(5)*mean(resolution));
        end
    end
end
fclose(fid);
y=0;
end

function skelStruct=convertSkel2SkelStruct(skel)
% Convert from skel.nodes{i} to skel{i}.nodes
% skelStruct is the cell array
skelStruct=cell(length(skel.nodes),1);
for i=1:length(skel.nodes)
    curStruct.nodes=skel.nodes{i};
    curStruct.edges=skel.edges{i};
    skelStruct{i}=curStruct;
end
end


%   Kevin M. Boergens 2013-2015
%   kevin.boergens@brain.mpg.de

function listS=makeSegmentList(nml,overWriteEdges,emphasizeNodes)
    function y=n2hR(aa,conM,oldNode,newNode)
        y=cell(1);
        y{1}=[oldNode,aa.nodes(oldNode,:)];
        while(true)
            y{1}=[y{1};[newNode,aa.nodes(newNode,:)]];
            switch sum(conM(:,newNode))
                case 1 %terminate segment
                    break;
                case 2 %continue segment
                    listN=find(conM(:,newNode));
                    if listN(1)==oldNode
                        oldNode=newNode;
                        newNode=listN(2);
                    else
                        oldNode=newNode;
                        newNode=listN(1);
                    end
                otherwise %make child segments
                    listN=find(conM(:,newNode))';
                    for nodeIt=listN
                        if nodeIt~=oldNode
                            y=[y; n2hR(aa,conM,newNode,nodeIt)];
                        end
                    end
                    break;
            end
        end
    end
a=cell(1);
a{1,1}=nml;
if overWriteEdges
    a{1,1}.edges=zeros(size(a{1,1}.nodes,1)-1,2);
    for i=1:size(a{1,1}.edges,1)
        if emphasizeNodes
            a{1,1}.edges(i,:)=[1,i+1];
        else
            a{1,1}.edges(i,:)=[i,i+1];
        end
    end
end

conM=zeros(size(a{1,1}.nodes,1));
for ii=a{1,1}.edges'
    conM(ii(1),ii(2))=1;
end
conM=conM+conM';
sconM=sum(conM);
sconM(sconM>1)=0;
startP= find(sconM);
directionP=find(conM(:,startP(1)));
listS=n2hR(a{1,1},conM,startP(1),directionP);
end