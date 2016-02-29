clear
bfopt.rfin = 75;
bfopt.funName = 'dftm';
bfopt.tol = 1e-12;
bfopt.trueP = 0;

n = 2^10;

A = OBFMimic2( n, bfopt );
% 
% B = A;
% for k = 2:length(A);
%     
%      [I,J,~] = find(B{k});
%      P{k} = sparse(J,I,ones(length(I),1));
%      B{k} = P{k}*B{k};
%      if k < length(A)
%         B{k+1} = B{k+1}*P{k}';
%      end
% end
