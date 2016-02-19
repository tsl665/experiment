clear
addpath ../../aux/MATLAB/MatEmb/src/
addpath ~/Documents/MATLAB/package/BF/1D/src

dataFileName1 = 'bfEmbed_sym_permutation.mat';
% dataFileName2 = 'bfMimicEmbed_eye.mat';
bfopt.rfin = 75;
bfopt.tol = 1e-10;
bfopt.funName = 'dftm';
bfopt.ifMiddleEye = 0;
embopt.ifEliminateSigmaM = 0;
embopt.ifEliminateSigmaM = ~bfopt.ifMiddleEye && embopt.ifEliminateSigmaM;
nSetAll = 1e3*([1,2,4,8,16,32,64,128]);
for j = 1:length(nSetAll)
    n = nSetAll(j);
    
    %% Generate Mimic BF factorization -- SigmaM is Permutation
    fprintf(['======================================\n']);
    fprintf(['obf_fillin test: n = ',num2str(n),'\n']);
    fprintf(['BF factorization generating...\n']);

    tic
    [ Factor,r ] = bf_mimic( n, bfopt);
    tGenerate = toc;
    infoFactor = whos('Factor');
    sizeU = size(Factor.U);

    fprintf(['Complete factorization! tGenerate = ',num2str(tGenerate),'s.\n', ...
        'Original Matrices is factorized into a product of ' ... 
        ,num2str(length(Factor.ATol)*2+3),' matrices. Require ' ...
        ,num2str(infoFactor.bytes/2^30),' G to store the factorization. \n' ...
        'Outer matrices have size [',num2str(sizeU(2)),'].\n']);
    fprintf(['Sparse embedding...\n\n']);

    %% Embed the factorization -- SigmaM is Permutation
%     tic
%     [ E1 ] = bfemb( Factor , embopt);
%     tEmbed = toc
%     [L1,U1,~,~] = lu(E1);
    [ E ] = bfemb_sym( Factor , embopt);
    infoE = whos('E');
    fprintf(['Complete embedding. E has size [', num2str(infoE.size(1)), ... 
        ', ',num2str(infoE.size(2)),']. Require ' ...
        ,num2str(infoE.bytes/2^30),' G to store the sparse embedding. \n\n']);
    
    fprintf(['umfpack LU factorizing...\n']);
    [L,U,~,~] = lu(E);
    nnzL(j) = nnz(L);
    nnzU(j) = nnz(U);
    nnzTotal(j) = nnzL(j) + nnzU(j);
    nnzRate(j) = nnzTotal(j)/n^2;
    nSet(j) = n;
    nnzE(j) = nnz(E);

%     %% Timing and Check Error -- SigmaM is Permutation
%     nSet(j) = n;
%     lvls(j) = length(Factor.ATol);
%     [InnerMatSize(j), ~] = size(Factor.SigmaM);
%     FactorRatio(j) = InnerMatSize(j)/n;
%     [nE(j),~]=size(E);
%     b = ones(n,1);
% %     bS = [zeros(nE(j)-n,1);b];
%     bS = [b;zeros(nE(j)-n,1)];
%     tic
%     xS = E\bS;
%     tSparseSolve(j) = toc;
%     x = xS(1:n);
% 
%     tic
%     b_solve = apply_bf(Factor, x);
%     tApply(j) = toc;
% 
%     relerr(j) = norm(b - b_solve)/norm(b) 
    save(dataFileName1, 'nSet', 'nnzL', 'nnzU', 'nnzTotal','nnzRate', 'nnzE');

end
% figure
% subplot(2,3,1); spy(E1);subplot(2,3,2); spy(L1);subplot(2,3,3);spy(U1);
% subplot(2,3,4); spy(E2);subplot(2,3,5);spy(L2);subplot(2,3,6);spy(U2);
% r1 = (nnz(L1)+nnz(U1))/n^2
% r2 = (nnz(L2)+nnz(U2))/n^2


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