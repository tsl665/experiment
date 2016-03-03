dataFileName = 'fftKron_blkSize_conv2.mat';
load(dataFileName);
figure
hold on
semilogx(data.n{1}, data.rate{1},'b');
semilogx(data.n{2}, data.rate{2},'r');
semilogx(data.n{3}, data.rate{3},'k');
semilogx(data.n{4}, data.rate{4},'g');
semilogx(data.n{5}, data.rate{5},'c');
Leg1 = ['r = ', num2str(blkSize{1}(1))];
Leg2 = ['r = ', num2str(blkSize{2}(1))];
Leg3 = ['r = ', num2str(blkSize{3}(1))];
Leg4 = ['r = ', num2str(blkSize{4}(1))];
Leg5 = ['r = ', num2str(blkSize{5}(1))];

legend(Leg1, Leg2, Leg3, Leg4, Leg5, 'Location', 'NW');