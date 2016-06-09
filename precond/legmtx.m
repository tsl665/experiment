function [ M ] = legmtx( x )
%LEGMAT Summary of this function goes here
%   Detailed explanation goes here

m = length(x);

for i = 1:m
    M(:, i) = legendreP(i,x);
end


end

