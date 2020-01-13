fnames=struct2table( rdir('**/*.m'));
[fList, pList] = matlab.codetools.requiredFilesAndProducts(fnames.name);

[PATHSTR,NAME,EXT]=cellfun(@fileparts,fList,'UniformOutput',false);
auxFiles=cellfun(@(x)contains(x,'auxiliaryMethods'),fList);
files2CopySource=fList(auxFiles);
% Correct dir and file names
strRep=@(fname) strrep(fname,'/home/alik/code/alik/auxiliaryMethods/',...
    '/home/alik/code/alik/L1paper/');
dir2Make=cellfun(strRep,PATHSTR(auxFiles),'UniformOutput',false);
files2CopyDest=cellfun(strRep,fList(auxFiles),'UniformOutput',false);
cellfun(@util.mkdir,dir2Make,'UniformOutput',false);
cellfun(@(s,d)copyfile(s,d),files2CopySource,files2CopyDest)