function [ Factor,r ] = bf_mimic( n,opt)
%BFEMB_MIMIC Summary of this function goes here
%   Detailed explanation goes here
% rfin = 75;
lvls = round(log2(n/opt.rfin)/2);
m = 2^(lvls-1);
p = round(n/m);
Nsamples = 10;
switch opt.funName
    case 'dftm'
        for j = 1:Nsamples
            w = exp(-2*pi*i/n);
            sampleIndX = min(n-p-2, round(rand*n));
            sampleIndK = min(n-p-2, round(rand*n));
            [tempX, tempK] = meshgrid(sampleIndX+(0:p-1), sampleIndK + (0:p-1));
            tempMat = w.^(tempX.*tempK)/sqrt(n);
            rr(j) = rank(tempMat, opt.tol);
        end
%         rr
        r = max(rr);
        clear tempX tempK tempMat
end

% shortcut for m^2*r: size of middle matrices
M = m^2*r;

% Middle matrix is a random perturbation matrix of size m^2*r
if opt.ifMiddleEye
    Factor.SigmaM = speye(M);
else
    Factor.SigmaM = sparse(randperm(M), 1:M, ones(1,M));
end
    
Factor.ATol = {};
Factor.BTol = {};
% Sizes of blocks at middle level
% blkSizeCur = [p*ones(1,m-1), n - p*(m-1)];

for j = 1:lvls-1
%     blkSizeNxt(1:2:2*length(blkSizeCur)) = floor(blkSizeCur/2);
%     blkSizeNxt(2:2:2*length(blkSizeCur)) = blkSizeCur - floor(blkSizeCur/2);
% %     nBlksPerG = j*m;
%     avgLenInG = round(blkSizeNxt/m);
%     lenExceptLast = avgLenInG*(m-1);
%     gBlkSize = kron(avgLenInG, ones(1,m));
%     gBlkSize(m:m:m^2) = 
%     nSmallBlks = m
%     nDiagBlks = m*2^j;
%     for k = 1:nDiagBlks
    mj = m*2^(-j+1); %dig boxes per G
    
%     tempVal = rand(M, 2*r);
    blocks = mat2cell(sparse(rand(M, 2*r)), r*ones(m^2,1) ,2*r);
    rowInd = 1:m^2;
    
    tempX = reshape(1:m^2/2,mj,m*2^(j-2));
    colInd = reshape([tempX;tempX],1,m^2);
    
    Factor.ATol{j} = matEmbed(rowInd,colInd,blocks) + speye(M);
    
%     tempVal = rand(2*M, r);
    blocks = mat2cell(sparse(rand(M, 2*r)), r*ones(m^2,1) ,2*r);
    Factor.BTol{j} = matEmbed(rowInd,colInd,blocks) + speye(M);
end
  
n1 = n - floor(n/m^2)*m^2;
rowSize = [ceil(n/m^2)*ones(1,n1),floor(n/m^2)*ones(1,m^2-n1)];
blocks = mat2cell(sparse(rand(n,r)), rowSize,r);
Factor.U = matEmbed( 1:m^2, 1:m^2, blocks);

blocks = mat2cell(sparse(rand(n,r)), rowSize,r);
Factor.V = matEmbed( 1:m^2, 1:m^2, blocks);

end

