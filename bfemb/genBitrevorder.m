function [ y ] = genBitrevorder( x, k, kmax )
%GENBITREVORDER Summary of this function goes here
%   Detailed explanation goes here

ord = mod(x,2^k);
rev = bin2dec(fliplr(dec2bin(x./2^k)))';
z = ord*2^(kmax-k) + rev;

[~, I] = sort(z);
y = x(I);

end

