function write(obj, filename,outputDir, varargin)
% WRITE this overridden method just adds the directory to filename and then
% passes the operation to the write function from skeleton class
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('outputDir','var') || isempty(outputDir)
    outputDir = obj.outputDir;
end
if ~exist('filename','var') || isempty(filename)
    filename = obj.filename;
end
filename = fullfile(outputDir,filename);
write@skeleton(obj,filename, varargin{:});
end