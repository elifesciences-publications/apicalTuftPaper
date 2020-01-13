function imgs = shiftImg( img, shiftX, shiftY )
%SHIFTIMG Summary of this function goes here
%   Detailed explanation goes here

A = [1, 0, shiftX; 0, 1, shiftY; 0, 0, 1];
tform = affine2d(A');
cbRef = imref2d(size(img));
imgs = imwarp(img,tform,'OutputView',cbRef);


