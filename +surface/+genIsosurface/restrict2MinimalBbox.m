function [vol,newBboxGlobal] = restrict2MinimalBbox(vol,curBbox)
%RESTRICT2MINIMALBBOX Summary of this function goes here
%   Detailed explanation goes here
% Get Local bbox of area contianing the CC of the volume annoations
cc=bwconncomp(vol);
ccBbox=regionprops(cc,'BoundingBox');
newBboxLocal=util.bbox.bboxUnion(ccBbox);
% MATLAB indexing fix
newBboxLocal=newBboxLocal([2,1,3],:);
% Get the global bbox for the annotations
newBboxGlobal=curBbox;
newBboxGlobal(:,1)=curBbox(:,1)+newBboxLocal(:,1)-1;
newBboxGlobal(:,2)=newBboxGlobal(:,1)+diff(newBboxLocal,[],2);
% Crop volume
vol=util.bbox.crop3D(vol,newBboxLocal);
end

