
%% load 文件
savename = '.\selectAns_Hengxiang.mat';
load(savename)
a = selectAns_Hengxiang;

%% 定义一下基本结构
% 隧道结构
% 起步和终止测点
tar_st = 3;
tar_ed = 6;

% 顶点位置
tar_mid = 5;

% 目标层数
tar_lay = 4;

%% 计算关键指标
layerHeight = a(:, nolayer+1:end);
a_observe = zeros(ns, nolayer-1);
a_observe(:, 1) = layerHeight(:, 1);
for layer = 2:4
    a_observe(:, layer) = layerHeight(:,layer)+a_observe(:,layer-1);
end
a_observe = a_observe';

% 隧道顶点埋深
tmp = a_observe(tar_lay - 1, tar_mid);
fprintf(' 隧道顶点埋深：%.3f 米\n', tmp)

% 第一层大地平均电阻值
rhotmp = a(:, 1);
tmp = mean(rhotmp);
fprintf(' 第一层大地平均电阻值：%.3f \n', tmp)

% 第二层大地平均电阻值
rhotmp = a(:, 3);
tmp = mean(rhotmp);
fprintf(' 第二层大地平均电阻值：%.3f \n', tmp)

% 隧道结构平均电阻值
rhotmp = a(tar_st : tar_ed, tar_lay);
tmp = mean(rhotmp);
fprintf(' 隧道结构平均电阻值：%.3f \n', tmp)

% 其余部分
rhotmp = a( [1:3,9:end] , tar_lay);
tmp = mean(rhotmp);
fprintf(' 其余部分平均电阻值：%.3f \n', tmp)





