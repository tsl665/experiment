% clear
addpath ../../aux/MATLAB/MatEmb/src/
addpath ~/Documents/MATLAB/package/BF/1D/src

dataFileName1 = 'bfMimicEmbed_permutation.mat';
dataFileName2 = 'bfMimicEmbed_eye.mat';
bfopt.rfin = 75;
bfopt.tol = 1e-10;
bfopt.funName = 'dftm';
bfopt.ifMiddleEye = 1;
embopt.ifEliminateSigmaM = 0;
embopt.ifEliminateSigmaM = ~bfopt.ifMiddleEye && embopt.ifEliminateSigmaM;
nSetAll = 1e3*(2:2);
for j = 1:length(nSetAll)
    n = nSetAll(j)
    
    %% Generate Mimic BF factorization -- SigmaM is Permutation
    tic
    [ Factor,r ] = bf_mimic( n, bfopt);
    tGenerate = toc
    %% Embed the factorization -- SigmaM is Permutation
    tic
    [ E ] = bfemb( Factor , embopt);
    tEmbed = toc
    [L,U,P,Q] = lu(E);
%     p = colamd(E);
    [L2, U2, P] = lu(E);
    
%     %% Timing and Check Error -- SigmaM is Permutation
%     nSet(j) = n;
%     lvls(j) = length(Factor.ATol);
%     [InnerMatSize(j), ~] = size(Factor.SigmaM);
%     FactorRatio(j) = InnerMatSize(j)/n;
%     [nE(j),~]=size(E);
%     b = ones(n,1);
%     bS = [zeros(nE-n,1);b];
%     tic
%     xS = E\bS;
%     tSparseSolve(j) = toc;
%     x = xS(1:n);
% 
%     tic
%     b_solve = apply_bf(Factor, x);
%     tApply(j) = toc;
% 
%     relerr(j) = norm(b - b_solve)/norm(b);    
end
figure
subplot(2,2,1); spy(L);subplot(2,2,2);spy(U);
subplot(2,2,3);spy(L2);subplot(2,2,4);spy(U2);
r1 = (nnz(L)+nnz(U))/n^2
r2 = (nnz(L2)+nnz(U2))/n^2
% subplot(1,2,1); spy(LU); subplot(1,2,2); spy(LU_p)
% (nnz(LU) - nnz(LU_p))/n^2
% save(dataFileName1, 'nSet', 'relerr', 'tSparseSolve', 'tApply','lvls','FactorRatio');

% bfopt.ifMiddleEye = 1;
% for j = 1:length(nSetAll)
%     n = nSetAll(j)
%     %% Generate Mimic BF factorization -- SigmaM is Identity
%     [ Factor,r ] = bf_mimic( n, bfopt);
%     %% Embed the factorization -- SigmaM is Identity
%     [ E ] = bfemb( Factor ,embopt);
%     
%     %% Timing and Check Error -- SigmaM is Identity
%     nSet(j) = n;
%     lvls(j) = length(Factor.ATol);
%     [InnerMatSize(j), ~] = size(Factor.SigmaM);
%     FactorRatio(j) = InnerMatSize(j)/n;
%     [nE(j),~]=size(E);
%     b = ones(n,1);
%     bS = [zeros(nE-n,1);b];
%     tic
%     xS = E\bS;
%     tSparseSolve(j) = toc;
%     x = xS(1:n);
% 
%     tic
%     b_solve = apply_bf(Factor, x);
%     tApply(j) = toc;
% 
%     relerr(j) = norm(b - b_solve)/norm(b);    
% end
% figure
% spy(E)
% 

% save(dataFileName2, 'nSet', 'relerr', 'tSparseSolve', 'tApply','lvls','FactorRatio');