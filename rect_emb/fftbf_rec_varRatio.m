clear

addpath /Users/sunlitang/Documents/github/st1552_gitlab/sparse-butterfly/oldtest
addpath ../../aux/MATLAB/MatEmb/src/

%addpath /home/sunli/Documents/gitlab/sparse-butterfly/oldtest
%addpath /home/sunli/Documents/Code/aux/MATLAB/MatEmb/src


m = 12;
% blkSize = 3;
% ratSet = [0.95,0.9,0.85,0.8,0.75,0.7];
ratSet = [0.9];

n1 = 2^m;
r1 = 2^4;


% Acell = fftmats(m);
% fprintf('Block Size = %4i\n',blkSize);

% fprintf('Block ratio = %4i\n',ratio);
% k = 0;
for k = 1:length(ratSet); 
%     Aexp = fftsysmat(m);
    ratio = ratSet(k);
    r2 = round(r1*ratio);
    ndiagblks = round(n1/r1);
    n2 = r2*ndiagblks;
    fprintf('Block ratio = %4i\n',n2/n1);


%     Acell = fftmats(m);   
%     rowInd = [1:m+2, 1:m+1];
%     colInd = [1:m+2, 2:m+2];
%     diagBlks = genSpMats( 'ones', r1, r2, ndiagblks );
%     diagMats = matEmbed(1:ndiagblks, 1:ndiagblks, diagBlks);
%     mats = [{diagMats}, Acell, {diagMats'}];
%     for kk = 1:m+1
%         mats = [mats, {speye(n1)}];
%     end
% 
%     Aexp = matEmbed(rowInd,colInd,mats);


    Bexp = fftsysmat(m);
    sp1 = speye(n1,length(Bexp));
    sp2 = rot90(speye(length(Bexp),n1),2);
    
    Aexp = matEmbed([1,2,3,1,2],[1,2,3,2,3],{speye(n1), Bexp, speye(n1),sp1,sp2});
    figure
    spy(Aexp)


    nnz1(k) = nnz(Aexp);
    
    [l,u,~,~,~] = lu(Aexp);
    
    nnz2(k) = nnz(l)+nnz(u);
    rat(k) = nnz2(k)/nnz1(k);
    n(k) = 2^m;
    fprintf('n = %4i,  nz before = %8i, nz lu =%8i, ratio= %3f\n', 2^m,nnz1(k),...
        nnz2(k), rat(k) )
%      save('recblks', 'n', 'nnz1', 'nnz2', 'rat');
    figure (1)
    subplot(1,length(ratSet),k); spy(Aexp);title('A_{exp}');
    figure (2)
    subplot(1,length(ratSet),k); spy(lu(Aexp));title('L+U');

end
