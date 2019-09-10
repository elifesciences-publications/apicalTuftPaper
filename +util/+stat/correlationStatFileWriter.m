function [out] = correlationStatFileWriter(X,Y,...
    fname,model)
%CORRELATIONSTATFILEWRITER Writes the correlation coefficient and R squared
%for the X and Y
if ~exist('model','var') || isempty(model)
    model=@(x) x;
end
if ~exist('fname','var') || isempty(fname)
    write2file=false;
else
    write2file=true;
end
[out.Rho,out.pval] = corr(X,Y);
out.Rsquared = util.stat.coeffDetermination(model, [X,Y]);
if write2file
    fid = fopen(fname,'w+');
    fprintf(fid, ['Correlation Coefficient is: ',num2str(out.Rho),'\n',...
        'The p-value is: ',num2str(out.pval),'\n']);
    fprintf(fid, ['Maximum X is: ',num2str(max(X)),'\n',...
        'The Maximum Y is: ',num2str(max(Y)),'\n']);
    fprintf(fid, ['R squared is: ',num2str(out.Rsquared),'\n']);
    fclose(fid);
end
end

