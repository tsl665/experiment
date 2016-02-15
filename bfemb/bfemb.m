function [ E, x, relerr, tSparseSolve, tApply, lvls, FactorRatio ] = bfemb( Factor, b)
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


E = matEmbed( rowInd, colInd, spMats);
[nE,~]=size(E);
bS = [zeros(nE-n,1);b];
tic
xS = E\bS;
tSparseSolve = toc;
x = xS(1:n);

tic
b_solve = apply_bf(Factor, x);
tApply = toc;

relerr = norm(b - b_solve)/norm(b);

end

