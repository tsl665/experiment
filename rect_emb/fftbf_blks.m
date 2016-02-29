clear
addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest

% m = 10;
blkSize = 3;

% n1 = 2^m;
% n2 = round(2^m * 1.1);

% Acell = fftmats(m);
fprintf('Block Size = %4i\n',blkSize);
for m = 4:12 
    Aexp = fftsysmat(m);

    [I,J,val] = find(Aexp);
    [ mats ] = genSpMats( 'rand', blkSize, blkSize, length(I) );
    blkAexp = matEmbed(I,J,mats);

    nnz1 = nnz(blkAexp);
    nnz2 = nnz(lu(blkAexp));
    rat = nnz2/nnz1;
    fprintf('n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', 2^m,nnz1,...
        nnz2, rat )
end
