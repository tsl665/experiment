clear

addpath ../../aux/MATLAB/MatEmb/src/
n = 2000;
m  =500;
A = rand(n);
[U, ~ , V] = svd(A);
% [V, ~] = eig(A);U = inv(V);
B = sparse(U(:, 1:m));
C = sparse(V(:, 1:m));

E = matEmbed([1,2,2], [2,1,2], {C', B, -speye(n)});
% b = ones(m,1);
% bE = [zeros(n,1); b];
% z = E\bE;
% x = z(1:m);
% y = z(m+1:m+n);

B = full(B);
C = full(C);

% x_true = (C'*B)\ones(m,1);
cond_orig = cond(C'*B)
cond_E = cond(full(E))
% relerr_y = norm(C'*y-b)/norm(b)
% relerr_x = norm(B*x-y)/norm(y)