clear
addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest

%addpath /home/sunli/Documents/gitlab/sparse-butterfly/oldtest
%addpath /home/sunli/Documents/Code/aux/MATLAB/MatEmb/src


% m = 10;
% blkSize = 3;
ratio = 0.9;

% Acell = fftmats(m);
% fprintf('Block Size = %4i\n',blkSize);

% fprintf('Block ratio = %4i\n',ratio);
k = 1;
for m = 6:12 
%     Aexp = fftsysmat(m);
    n1 = 2^m;
    r1 = 2^3;
    r2 = round(r1*ratio);
    n2 = r2*n1/r1;
    ndiagblks = n1/r1;
    fprintf('Block ratio = %4i\n',n2/n1);


    Acell = fftmats(m);   
    rowInd = [1:m+2, 1:m+1];
    colInd = [1:m+2, 2:m+2];
    diagBlks = genSpMats( 'ones', r1, r2, ndiagblks );
    diagMats = matEmbed(1:ndiagblks, 1:ndiagblks, diagBlks);
    mats = [{diagMats}, Acell, {diagMats'}];
    for kk = 1:m+1
        mats = [mats, {speye(n1)}];
    end

    Aexp = matEmbed(rowInd,colInd,mats);

    nnz1(k) = nnz(Aexp);
    
%     [l,u,P,Q] = lu(Aexp);
%     luAexp = l+u;

    luAexp = lu(Aexp);
    
    nnz2(k) = nnz(luAexp);
    rat(k) = nnz2(k)/nnz1(k);
    n(k) = 2^m;
    fprintf('n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', 2^m,nnz1(k),...
        nnz2(k), rat(k) )
     save('recblks', 'n', 'nnz1', 'nnz2', 'rat');
     k = k+1;
%      figure
%     subplot(1,2,1); spy(Aexp);title('A_{exp}');
%     subplot(1,2,2); spy(luAexp);title('L+U');

end
