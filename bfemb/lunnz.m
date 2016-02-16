clear
% addpath ../../aux/MATLAB/MatEmb/src/
% addpath ~/Documents/MATLAB/package/BF/1D/src

dataFileName1 = 'bfMimicLu.mat';
bfopt.rfin = 75;
bfopt.tol = 1e-10;
bfopt.funName = 'dftm';
bfopt.ifMiddleEye = 0;
embopt.ifEliminateSigmaM = 0;
embopt.ifEliminateSigmaM = ~bfopt.ifMiddleEye && embopt.ifEliminateSigmaM;
nSetAll = 1e3*(1:2);
for j = 1:length(nSetAll)
    n = nSetAll(j)
    %% Generate Mimic BF factorization
    [ Factor,r ] = bf_mimic( n, bfopt);
    %% Embed the factorization
    [ E ] = bfemb( Factor , embopt);
    
    %% LU decomposition
    nSet(j) = n;
    [L,U] = lu(E);
    nnzl(j) = nnz(L);
    nnzu(j) = nnz(U);
    nnzTotal(j) = nnzl(j) + nnzu(j);
    nnzRatio(j) = nnzTotal(j)/n^2;
end
figure
spy(E);
