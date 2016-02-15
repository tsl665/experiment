clear
addpath ../../aux/MATLAB/MatEmb/src/
addpath ~/Documents/MATLAB/package/BF/1D/src

dataFileName = 'bfMimicEmbed01.mat';
rfin = 75;
nSet = 2^10*(1:2);
for j = 1:length(nSet)
%     n = 1024;
    n = nSet(j)
    [ Factor,r ] = bf_mimic( n,rfin,1e-10,'dftm' );
    b = ones(n,1);
    [ E, x, relerr(j), tSparseSolve(j), tApply(j), lvls(j), FactRatio(j) ] = bfemb( Factor, b);
end

save(dataFileName, 'nSet', 'relerr', 'tSparseSolve', 'tApply','lvls','FactRatio');