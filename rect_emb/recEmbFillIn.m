clear

addpath ../../aux/MATLAB/MatEmb/src/

% n1 = 2^m;
% r1 = 2^3;
% r2 = round(r1*ratio);
% n2 = r2*n1/r1;
% ndiagblks = n1/r1;

wbratio = 0.5;
pwrSet = 1:5;
nSet = 100*2.^pwrSet;
nInnerBlks = 10;
for k = 1:length(pwrSet)
    n1 = nSet(k);
    r1 = 10;
    r2 = round(r1*wbratio);
    n2 = r2*n1/r1;
    ndiagblks = n1/r1;
    
    rowInd = [1:nInnerBlks+2, 1:nInnerBlks+1];
    colInd = [1:nInnerBlks+2, 2:nInnerBlks+2];
    diagBlks = genSpMats( 'ones', r1, r2, ndiagblks );
    B = matEmbed(1:ndiagblks, 1:ndiagblks, diagBlks);

    mats{1} = B;
    mats{nInnerBlks+2} = B';
    l1 = 2;
    l2 = nInnerBlks+3;
    for l = 2:nInnerBlks+1
        mats{l1} = speye(n1);
        mats{l2} = speye(n1);
        l1 = l1+1;
        l2 = l2+1;
    end
    mats{l2} = speye(n1);
    
    Aexp = matEmbed(rowInd,colInd,mats);
    
    
        nnz1(k) = nnz(Aexp);
    
    [l,u,~,~,~] = lu(Aexp);
    
    nnz2(k) = nnz(l)+nnz(u);
    rat(k) = nnz2(k)/nnz1(k);
    n(k) = n1;
    fprintf('n = %4i,  nz before = %8i, nz lu =%10i, ratio= %3f\n', n(k),nnz1(k),...
        nnz2(k), rat(k) )
%      save('recblks', 'n', 'nnz1', 'nnz2', 'rat');

end
figure
subplot(1,2,1); spy(Aexp);title('A_{exp}');
subplot(1,2,2); spy(l+u);title('L+U');

    
