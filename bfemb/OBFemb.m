function [ E ] = OBFemb( A )
%OBFEMB Summary of this function goes here
%   Detailed explanation goes here
[M,~] = size(A{1});
nBlks = length(A);
rowInd = [1:nBlks,1:nBlks-1];
colInd = [1:nBlks,2:nBlks];
% colInd = colInd - 1;
% colInd(1) = nBlks;
spMats = A;
for j = 1:nBlks-1
    spMats = [spMats {-speye(M)}];
end

E = matEmbed( rowInd, colInd, spMats);



end

