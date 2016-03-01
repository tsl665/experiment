function [ p ] = blkPerm( blkPermVector, blkSize )
%BLKPERM Generate permutation vector for block matrix, given block
%permutation vector and block sizes.
%   For example, B = PA, where P is (row) permutation matrix. A and B are
%   block matrices. A = 
%   [0      0       A13     0  ]
%   [0      A21     0       A24]
%   [A31    0       0       0  ]
%   [A41    0       0       0  ].
%   P is the permutation matrix to swap block row 1 and 3, i.e. P = 
%   [0    0     I     0  ]
%   [0    I     0     0  ]
%   [I    0     0     0  ]
%   [0    0     0     I  ],
%   so that B = 
%   [A31    0       0       0  ]
%   [0      A21     0       A24]
%   [0      0       A13     0  ]
%   [A41    0       0       0  ].
%   Then, blkPermVector = [3,2,1,4], and
%   [blkSize(1),~] = size(A13); [blkSize(2),~] = size(A21) = size(A24); etc.
%   B can be generated by B = A(p, :);
%
%   p = blkPerm( blkPermVector, r ), where r is a scalar, returns the
%   termutation vector for matrix with all blocks of same row/column 
%   size r.
%   
%   p = blkPerm( blkPermVector, rVector ), where rVector is a vector, 
%   returns the termutation vector for matrix with all blocks of  
%   row/columns sizes rVector(1), rVector(2), ...
%

if length(blkSize) == 1
    r = blkSize;
    p = blkPermVector - 1;
    rv = 0:(r-1);
    plen = length(p);
    u = repmat(rv,1,plen);
    v = reshape(repmat(p*r,r,1),1,plen*r);
    permVector = u + v + 1;
elseif length(blkSize) > 1
    [~, I] = sort(blkPermVector);
    sortedBlkSize = blkSize(I);
    stackedInd = {};
    firstInd = 1;
    lastInd = 0;
    for k = 1:length(blkPermVector)
        lastInd = lastInd + sortedBlkSize(k);
        stackedInd = [stackedInd(:); {(firstInd:lastInd)'}];
        firstInd = firstInd + sortedBlkSize(k);

    end
%     stackedInd{:}
    [~, J] = sort(I);
    permVector = vertcat(stackedInd{J})';
end
    
p = permVector;
   

end

