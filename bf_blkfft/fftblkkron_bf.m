clear

% opt.env = 'borg';
opt.env = 'sunliMac';

opt.ifcolamd = 1;
opt.ifspyplot = 0;
opt.ifsaveData = 0;

if strcmp(opt.env, 'sunliMac')
    addpath /Users/sunlitang/Documents/github/tsl665/aux/MATLAB/MatEmb/src/
    addpath /Users/sunlitang/Documents/github/tsl665/experiment/bfemb/
    addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest
elseif ctrcmp (opt.env, 'borg')
    addpath /home/sunli/Documents/gitlab/sparse-butterfly/oldtest
    addpath /home/sunli/Documents/Code/experiment/bfemb
    addpath /home/sunli/Documents/Code/aux/MATLAB/MatEmb/src
end
    
end
bfopt.rfin = 75;
bfopt.funName = 'dftm';
bfopt.tol = 1e-12;
bfopt.trueP = 0;

nSet = 1024*[1,2,4,8,16];
% nSet = 1024;

for k = 1:length(nSet)
    n = nSet(k);
    [ B,r, finestSize ] = OBFMimic2( n, bfopt );
    blkSize = r;
    [innerSize,~] = size(B{2});
    nBlks = round(innerSize/r);

    kmax = log2(nBlks);

    for k = kmax-1:-1:1
        blkPermVector = genBitrevorder( 0:(nBlks-1), k, kmax );
        p{kmax-k} = blkPerm( blkPermVector+1, r );
    end

    blkPermVector = genBitrevorder( 0:(nBlks-1), 0, kmax );
    p{kmax} = blkPerm( blkPermVector+1, finestSize );

    for k = 2:length(B)-1
        B{k} = B{k}(p{k-1},:);
        B{k+1} = B{k+1}(:,p{k-1});
    end
    B{length(B)} = B{length(B)}(p{kmax},:);
    
%     %% Make B{1}, B{last} square
%     B{1} = B{2};
%     B{length(B)} = B{2};
    
    %% Get rid of B{1} and B{last}
    B = B(2:length(B)-1);
    
    %% Construct A to compare
    
    m = round(log2(n/blkSize));
    
    Acell = fftmats(m);
    
    for j = 1:length(Acell)
        [I,J,val] = find(Acell{j});
        [ mats ] = genSpMats( 'rand', blkSize, blkSize, length(I) );
        blkAcell{j} = matEmbed(I,J,mats);
    end
    
    clear Acell
    %% test fill-in of FFT Kron Embedding matrix A    
    [ E ] = OBFemb( blkAcell );
    nnzA1 = nnz(E);
    %luE = lu(E);
    % nnz2 = nnz(luE);
    if opt.ifcolamd
        [L,U,~,~] = lu(E);
    else
        [L,U] = lu(E);
    end
    nnzA2 = nnz(L)+nnz(U)-length(E);
    ratA = nnzA2/nnzA1;

    fprintf('FFT Kron Embedding: n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', n,nnzA1,...
        nnzA2,  ratA);
    
%     figure('vis', 'off')
    if opt.ifspyplot
        figure
        set(gcf, 'Position', [200,200,600,600])
        subplot(2,2,1); spy(E); title('E'); subplot(2,2,3); spy(L+U); title('L+U');
    end



    %% test fill-in of permuted matrix B
    [ E ] = OBFemb( B );
    nnzB1 = nnz(E);
    % luE = lu(E);
    % nnz2 = nnz(luE);
    if opt.ifcolamd
        [L,U,~,~] = lu(E);
    else
        [L,U] = lu(E);
    end
    nnzB2 = nnz(L)+nnz(U)-length(E);
    ratB = nnzB2/nnzB1;
    nn(k) = n;

    fprintf('BF after pivotting: n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', n,nnzB1,...
        nnzB2,  ratB);
    if opt.ifspyplot   
        subplot(2,2,2); spy(E); title('E');subplot(2,2,4); spy(L+U);title('L+U');
    end

end

% print -painters -dpdf -r600 bfemb_sq.pdf