clear

% opt.env = 'borg';
opt.env = 'sunliMac';

opt.ifcolamd = 0;
opt.ifspyplot = 0;
opt.ifsaveData = 0;
opt.dataName = 'fftKron_blkSize_conv.mat';

if strcmp(opt.env, 'sunliMac')
    addpath /Users/sunlitang/Documents/github/tsl665/aux/MATLAB/MatEmb/src/
    addpath /Users/sunlitang/Documents/github/tsl665/experiment/bfemb/
    addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest
elseif strcmp (opt.env, 'borg')
    addpath /home/sunli/Documents/gitlab/sparse-butterfly/oldtest
    addpath /home/sunli/Documents/Code/experiment/bfemb
    addpath /home/sunli/Documents/Code/aux/MATLAB/MatEmb/src
end

blkSizeSet = 2.^[0:5];
nSet = 2.^[6:14];

% blkSizeSet = 2.^[0:3];
% nSet = 2.^[6:8];
for k2 = 1:length(nSet)
    for k1 = 1:length(blkSizeSet)
        r = blkSizeSet(k1);
        n = nSet(k2);
        m = round(log2(n/r));

        Acell = fftmats(m);

        for j = 1:length(Acell)
            [I,J,val] = find(Acell{j});
            [ mats ] = genSpMats( 'rand', r, r, length(I) );
            blkAcell{j} = matEmbed(I,J,mats);
        end

        clear Acell

        %% test fill-in of FFT Krno EMbedding matrix A   
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

        fprintf('FFT Kron Embedding: n = %4i,  r = %4i \n nz before = %8i, nz lu =%8i, ratio= %3f\n\n', ...
            n,r,nnzA1,nnzA2,  ratA);
        if opt.ifsaveData
            data.nnz1{k1}(k2) = nnzA1;
            data.nnz2{k1}(k2) = nnzA2;
            data.rate{k1}(k2) = ratA;
            data.blkSize{k1}(k2) = r;
            data.n{k1}(k2) = n;
            [data.nEmb{k1}(k2), ~] = size(E);
            save(opt.dataName, 'data');
        end
    end
end
if opt.ifspyplot
    figure
%         set(gcf, 'Position', [200,200,600,600])
    subplot(2,1,1); spy(E); title('E'); subplot(2,1,2); spy(L+U); title('L+U');
end


