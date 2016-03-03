
%% Load and process data
dataFileName = 'fftKron_blkSize_conv2.mat';
dataFileName2 = 'fftKron_blkSize_conv2_plus2.mat';
load(dataFileName);
dara1 = data;
load(dataFileName2);
data2 = data;
clear data
for k = 1:length(data1.n)
    data.n{k} = [dara1.n{k}, data2.n{k}];
    data.nnz1{k} = [dara1.nnz1{k}, data2.nnz1{k}];
    data.nnz2{k} = [dara1.nnz2{k}, data2.nnz2{k}];
    data.rate{k} = [dara1.rate{k}, data2.rate{k}];
    data.blkSize{k} = [dara1.blkSize{k}, data2.blkSize{k}];
    data.nEmb{k} = [dara1.nEmb{k}, data2.nEmb{k}];
end

%% Plot
figure
semilogx(data.n{1}, data.rate{1},'b');
hold on
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