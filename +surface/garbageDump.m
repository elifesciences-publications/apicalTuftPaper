%Create tracing script did not work for the large bbox

bbox=[3260,951,2472,1664,1664,668];
matlabBBox=Util.convertWebknossosToMatlabBbox(bbox);

script=WK.downloadVolumeTracingScript(matlabBBox)