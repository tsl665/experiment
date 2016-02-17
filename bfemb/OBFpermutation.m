function [ P ] = OBFpermutation( mats )
%OBFPERMUTATION Summary of this function goes here
%   Detailed explanation goes here

nBlks = length(mats);
if mod(nBlks,2)~= 0
    error('The Number of blocks must be even!')
end

rowInd = [1:nBlks];
colInd = [1:nBlks/2, 1:nBlks/2];

P = matEmbed(rowInd,colInd,mats);

end

