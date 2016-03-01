clear

addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest
addpath ../../aux/MATLAB/MatEmb/src/

k = 1;
mSet = 8:14;
plotGap = length(mSet);
for m = mSet;
    n1 = 2^m;
    Bexp = fftsysmat(m);
    sp1 = speye(n1,length(Bexp));
    sp2 = rot90(speye(length(Bexp),n1),2);
    Aexp = matEmbed([1,2,3,1,2],[1,2,3,2,3],{speye(n1), Bexp, speye(n1),sp1,sp2});
    
    
    n(k) = 2^m;
    
    [lB,uB,~,~,~] = lu(Bexp);
    nnzB(k) = nnz(Bexp);
    nnzBlu(k) = nnz(lB)+nnz(uB);
    ratB(k) = nnzBlu(k)/nnzB(k);

    fprintf('n = %4i:\n    FFT: nz before = %8i, nz lu =%8i, ratio= %3f\n', 2^m,nnzB(k),...
        nnzBlu(k), ratB(k) );
    
    [lA,uA,~,~,~] = lu(Aexp);
    nnzA(k) = nnz(Aexp);
    nnzAlu(k) = nnz(lA)+nnz(uA);
    ratA(k) = nnzAlu(k)/nnzA(k);


    fprintf('I*FFT*I: nz before = %8i, nz lu =%8i, ratio= %3f\n\n',nnzA(k),...
        nnzAlu(k), ratA(k) )
    
%     subplot(plotGap,2,2*k-1); spy(lB+uB);title('L+U for FFT');
%     subplot(plotGap,2,2*k); spy(lA+uA);title('L+U for I*FFT*I');
    subplot(plotGap,2,2*k-1); spy(lu(Bexp));title('L+U for FFT');
    subplot(plotGap,2,2*k); spy(lu(Aexp));title('L+U for I*FFT*I');

    k = k+1;


end




