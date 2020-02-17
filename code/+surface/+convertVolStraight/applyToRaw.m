function [ raw, newBbox] = applyToRaw( raw, magShift, bbox )
%APPLYTORAW Applies the shifting to the planes starting at chunckStart
% Author: Florian Drawitsch <florian.drawitsh@brain.mpg.de>
funForPadding=@(x) max(abs(x(bbox(3,1):bbox(3,2))));
padSize=structfun(funForPadding,magShift)+1;
raw=padarray(raw,fliplr(padSize'));
% Correct by slice
for zi = 1:size(raw,3)
    disp(['shifting planes ... (',num2str(bbox(3,1)-1+zi),' of ',...
        num2str(bbox(3,1)-1+size(raw,3)),')']);
    shiftX = magShift.x(bbox(3,1)-1+zi);
    shiftY = magShift.y(bbox(3,1)-1+zi);
    
    img = raw(:,:,zi);
    imgs = surface.convertVolStraight.shiftImg( img, -shiftX, -shiftY );
    raw(:,:,zi) = imgs;
end
% Correct bbox
newBbox=bbox;
newBbox(1:2,:)=bbox(1:2,:)+[-flipud(padSize),flipud(padSize)];
end



