function tempDir = getTempDir()
    % tempDir = getTempDir()
    %   Gets the path to the directory of temporary files.
    %   On GABA, it uses the scratch directory.
    %
    % Written by
    %   Alessandro Motta <alessandro.motta@brain.mpg.de>
    
    % default
    tempDir = tempdir();
    
    % use default if not UNIX
    if ~isunix; return; end
    
    % check for GABA
    [code, host] = runShell('hostname');
    
    if ~code && strncmpi(host, 'gaba', 4)
        tempDir = ['/tmpscratch/', getenv('USER'), '/'];
    end
end
