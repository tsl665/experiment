clear
addpath ../../aux/MATLAB/MatEmb/src/

dataFileName = 'obf_fillin.mat';

bfopt.rfin = 75;
bfopt.funName = 'dftm';
bfopt.tol = 1e-12;
bfopt.trueP = 0;

n = 2000;
nSetAll = 1e3*(1:20);
nnzL = []; nnzU = []; nnzTotal = []; nnzRate = []; nSet = [];
for j = 1:length(nSetAll)
    n = nSetAll(j);
    fprintf(['obf_fillin test: n = ',num2str(n),'\n']);

    A = OBFMimic( n, bfopt );
    E = OBFemb( A );

    [L, U, P, Q, R] = lu(E);
    nnzL(j) = nnz(L);
    nnzU(j) = nnz(U);
    nnzTotal(j) = nnzL(j) + nnzU(j);
    nnzRate(j) = nnzTotal(j)/n^2;
    nSet(j) = n;
    
    save(dataFileName, 'nSet', 'nnzL', 'nnzU', 'nnzTotal','nnzRate');
end

% figure
% subplot(3,2,1); spy(L1);subplot(3,2,2);spy(U1);
% subplot(3,2,3);spy(L2);subplot(3,2,4);spy(U2);
% subplot(3,2,5);spy(L3);subplot(3,2,6);spy(U3);
% 
% r1 = (nnz(L1)+nnz(U1))/n^2
% r2 = (nnz(L2)+nnz(U2))/n^2
% r3 = (nnz(L3)+nnz(U3))/n^2
