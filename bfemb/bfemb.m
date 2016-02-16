function [ E ] = bfemb( Factor, opt)
%BFEMB Summary of this function goes here
%   Detailed explanation goes here

[n,M] = size(Factor.U);
FactorRatio = M/n;
lvls = length(Factor.ATol)+1;

nBlks = 3 + 2*length(Factor.ATol);
rowInd = [1:nBlks,1:nBlks-1];
colInd = [1:nBlks,2:nBlks];

spMats{1} = Factor.V';
for j = length(Factor.BTol):-1:1
    spMats = [spMats {Factor.BTol{j}'}];
end
spMats = [spMats {Factor.SigmaM}];
for j = 1:length(Factor.ATol)
    spMats = [spMats {Factor.ATol{j}}];
end
spMats = [spMats {Factor.U}];

for j = length(spMats)+1:length(rowInd)
    spMats = [spMats {-speye(M)}];
end

iSigmaM = length(Factor.ATol) + 2;
iEyeOfSigmaM = nBlks + length(Factor.ATol) + 2;
if opt.ifEliminateSigmaM
    spMats{iSigmaM} = speye(M);
    spMats{iEyeOfSigmaM} = -Factor.SigmaM';
end
    
    


E = matEmbed( rowInd, colInd, spMats);

end

