clear
Nset = [100, 200, 400, 800, 1600, 3200, 6400];
imax = length(Nset);
% imax = 2
for i = 1:imax
    N = Nset(i)
    x = linspace(0,1,N);
    A = legmtx(x);
    b = ones(N,1);
    [~,~,~,ii]=gmres(A,b,[],[],N);
    ITER(i) = ii(2)
    n(i) = N;
    
end

save('iter.mat', 'n', 'ITER')