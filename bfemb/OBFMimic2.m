function [ A,r, finestSize ] = OBFMimic2( n, opt )
%OBFMIMIC Summary of this function goes here
%   Detailed explanation goes here
lvls = round(log2(n/opt.rfin));
% lvls = round(log2(n));
M = 2^lvls;
p = round(n/sqrt(M));
Nsamples = 1;
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

n1 = n - floor(n/M)*M;
finestSize = [ceil(n/M)*ones(1,n1),floor(n/M)*ones(1,M-n1)];
A{1} = matEmbed(1:M,1:M,mat2cell(sparse(rand(r, n)),r,finestSize));

for l = 1:lvls-1
    nDiagBlks = 2^(l-1);
    matsPerDiagBlks = M / nDiagBlks;
    for j = 1:nDiagBlks
        diagBlks{j} = OBFpermutation(mat2cell(sparse(rand(r, 2*r*matsPerDiagBlks ...
        )),r,2*r*ones(matsPerDiagBlks,1)));
    end
    A{l+1} = matEmbed(1:nDiagBlks, 1:nDiagBlks, diagBlks);
end
A{lvls+1} = matEmbed(1:M,1:M,mat2cell(sparse(rand(n, r)),finestSize,r));

end

