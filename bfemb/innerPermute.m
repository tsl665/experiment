clear

addpath /Users/sunlitang/Documents/github/tsl665/aux/MATLAB/MatEmb/src/

bfopt.rfin = 75;
bfopt.funName = 'dftm';
bfopt.tol = 1e-12;
bfopt.trueP = 0;

nSet = 1024*[1,2,4,8,16];

for k = 1:length(nSet)
    n = nSet(k);
    [ A,r, finestSize ] = OBFMimic2( n, bfopt );
    [innerSize,~] = size(A{2});
    nBlks = round(innerSize/r);

    kmax = log2(nBlks);

    for k = kmax-1:-1:1
        blkPermVector = genBitrevorder( 0:(nBlks-1), k, kmax );
        p{kmax-k} = blkPerm( blkPermVector+1, r );
    end

    blkPermVector = genBitrevorder( 0:(nBlks-1), 0, kmax );
    p{kmax} = blkPerm( blkPermVector+1, finestSize );

    B = A;
    for k = 2:length(B)-1
        B{k} = B{k}(p{k-1},:);
        B{k+1} = B{k+1}(:,p{k-1});
    end
    B{length(B)} = B{length(B)}(p{kmax},:);
    
%     %% Make A{1}, A{last} and B{1}, B{last} square
%     A{1} = B{2};
%     A{length(A)} = B{2};
%     B{1} = B{2};
%     B{length(B)} = B{2};
    
    %% Get rid of A{1} , A{last}; B{1} and B{last}
    A = A(2:length(A)-1);
    B = B(2:length(B)-1);

    %% test fill-in of original matrix A
    [ E ] = OBFemb( A );
    nnzA1 = nnz(E);
    %luE = lu(E);
    % nnz2 = nnz(luE);
    [L,U,~,~] = lu(E);
    nnzA2 = nnz(L)+nnz(U)-length(E);
    ratA = nnzA2/nnzA1;

    fprintf('Before permute: n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', n,nnzA1,...
        nnzA2,  ratA);
    figure('vis', 'off')
    set(gcf, 'Position', [200,200,600,600])
    subplot(2,2,1); spy(E); title('E'); subplot(2,2,3); spy(L+U); title('L+U');

    %% test fill-in of permuted matrix B
    [ E ] = OBFemb( B );
    nnzB1 = nnz(E);
    % luE = lu(E);
    % nnz2 = nnz(luE);
    [L,U,~,~] = lu(E);
    nnzB2 = nnz(L)+nnz(U)-length(E);
    ratB = nnzB2/nnzB1;
    nn(k) = n;

    fprintf('After permute: n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', n,nnzB1,...
        nnzB2,  ratB);
    subplot(2,2,2); spy(E); title('E');subplot(2,2,4); spy(L+U);title('L+U');

%     save('OBF_permutevsorig_lupq.mat', 'nn', 'nnzA1', 'nnzA2', 'ratA','nnzB1', 'nnzB2', 'ratB');

end

% print -painters -dpdf -r600 bfemb_sq.pdf