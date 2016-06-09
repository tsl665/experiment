clear
addpath ../../aux/MATLAB/MatEmb/src/

dataFileName = 'obf_fillin.mat';

bfopt.rfin = 75;
bfopt.funName = 'dftm';
bfopt.tol = 1e-12;
bfopt.trueP = 0;

% nSetAll = 1e3*([1]);
nSetAll = 2.^[9:9];
nnzL = []; nnzU = []; nnzTotal = []; nnzRate = []; nSet = [];
for j = 1:length(nSetAll)
    n = nSetAll(j);
    fprintf(['======================================\n']);
    fprintf(['obf_fillin test: n = ',num2str(n),'\n']);
    fprintf(['BF factorization generating...\n']);
%     A = OBFMimic( n, bfopt );
    A = OBFMimic2( n, bfopt );
    infoA = whos('A');
    fprintf(['Complete factorization.\n', ...
        'Original Matrices is factorized into a product of ' ... 
        ,num2str(infoA.size(2)),' matrices. Require ' ...
        ,num2str(infoA.bytes/2^30),' G to store the factorization. \n' ...
        'Outer matrices have size [',num2str(size(A{1})),'].\n']);
    fprintf(['Sparse embedding...\n\n']);
    E = OBFemb( A );
    infoE = whos('E');
    fprintf(['Complete embedding. E has size [', num2str(infoE.size(1)), ... 
        ', ',num2str(infoE.size(2)),']. Require ' ...
        ,num2str(infoE.bytes/2^30),' G to store the sparse embedding. \n\n']);
    
    fprintf(['umfpack LU factorizing...\n']);
%     [L, U, P, Q, R] = lu(E);
    [L,U,P] = lu(E);
    nnzL(j) = nnz(L);
    nnzU(j) = nnz(U);
    nnzTotal(j) = nnzL(j) + nnzU(j);
    nnzRate(j) = nnzTotal(j)/n^2;
    nSet(j) = n;
    nnzE(j) = nnz(E);


%     save(dataFileName, 'nSet', 'nnzL', 'nnzU', 'nnzTotal','nnzRate', 'nnzE');
end
for j = 1:length(nSetAll)
    fprintf('n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', nSet(j),nnzE(j),...
	nnzTotal(j),  nnzTotal(j)/nnzE(j));
end
figure
subplot(2,2,1);spy(E);subplot(2,2,2);spy(L+U);
subplot(2,2,3);spy(L);subplot(2,2,4);spy(U);

% subplot(3,2,1); spy(L1);subplot(3,2,2);spy(U1);
% subplot(3,2,3);spy(L2);subplot(3,2,4);spy(U2);
% subplot(3,2,5);spy(L3);subplot(3,2,6);spy(U3);
% 
% r1 = (nnz(L1)+nnz(U1))/n^2
% r2 = (nnz(L2)+nnz(U2))/n^2
% r3 = (nnz(L3)+nnz(U3))/n^2
