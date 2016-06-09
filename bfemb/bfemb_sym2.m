function [ E ] = bfemb_sym2( Factor, opt)
%BFEMB Summary of this function goes here
%   Detailed explanation goes here

[n,M] = size(Factor.U);
FactorRatio = M/n;
lvls = length(Factor.ATol)+1;

nBlks = 3 + 2*length(Factor.ATol);
rowInd = [1:nBlks-1, nBlks,2:nBlks];
colInd = [2:nBlks,nBlks, 1:nBlks-1];

spMats{1} = Factor.U;
spMats{2} = -speye(M);

for k = length(Factor.ATol):-1:1
    spMats = [spMats, {Factor.ATol{k}}, {speye(M)}];
end

spMats = [spMats, {Factor.SigmaM}, {Factor.V'}, {-speye(M)}];

for k = length(Factor.BTol):-1:1
    spMats = [spMats, {Factor.BTol{k}'}, {speye(M)}];
end

% iSigmaM = length(Factor.ATol) + 2;
% iEyeOfSigmaM = nBlks + length(Factor.ATol) + 2;
% if opt.ifEliminateSigmaM
%     spMats{iSigmaM} = speye(M);
%     spMats{iEyeOfSigmaM} = -Factor.SigmaM';
% end
    
    


E = matEmbed( rowInd, colInd, spMats);

end

