clear
n  =10000;
P = sparse(randperm(n), 1:n, ones(1,n));
[L, U, ~, ~] = lu(P);
figure
subplot(1,3,1); spy(P);subplot(1,3,2); spy(L);subplot(1,3,3);spy(U);
