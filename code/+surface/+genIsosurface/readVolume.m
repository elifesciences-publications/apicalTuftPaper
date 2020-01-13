function vol=readVolume(dir,filename,bbox,processData)
% unzip the raw data
if isempty(processData) || ~exist('processData','var')
    processData.flag=false;
end
outdir=fullfile(dir,[filename,'Raw']);
if ~exist(outdir,'dir')
    util.mkdir(outdir)
    unzip(fullfile(dir,[filename,'.zip']),outdir);
    unzip(fullfile(outdir,'data'),outdir)
end
% WKW path
source_path=fullfile(outdir,'1');

vol = wkwLoadRoi(source_path, bbox);
assert(any(vol(:)), 'The bouding box is empty');
vol = (vol==processData.cellID);

if processData.flag
    assert(~isempty(vol(:)>0));
    vol = padarray(vol,[10,10,10]);
    vol = smooth3(vol,'gaussian',9,8);
    vol = vol(11:end-10,11:end-10,11:end-10);
else
    vol=uint32(vol);
    % Give new cell ID in case feild newCellID is defined for the processData
    % structure
    if isfield(processData,'newCellID')
        vol(vol>0)=uint32(processData.newCellID);
    else
        vol(vol>0)=uint32(processData.cellID);
    end
end

end










