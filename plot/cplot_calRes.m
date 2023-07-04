
%% load �ļ�
savename = '.\selectAns_Hengxiang.mat';
load(savename)
a = selectAns_Hengxiang;

%% ����һ�»����ṹ
% ����ṹ
% �𲽺���ֹ���
tar_st = 3;
tar_ed = 6;

% ����λ��
tar_mid = 5;

% Ŀ�����
tar_lay = 4;

%% ����ؼ�ָ��
layerHeight = a(:, nolayer+1:end);
a_observe = zeros(ns, nolayer-1);
a_observe(:, 1) = layerHeight(:, 1);
for layer = 2:4
    a_observe(:, layer) = layerHeight(:,layer)+a_observe(:,layer-1);
end
a_observe = a_observe';

% �����������
tmp = a_observe(tar_lay - 1, tar_mid);
fprintf(' ����������%.3f ��\n', tmp)

% ��һ����ƽ������ֵ
rhotmp = a(:, 1);
tmp = mean(rhotmp);
fprintf(' ��һ����ƽ������ֵ��%.3f \n', tmp)

% �ڶ�����ƽ������ֵ
rhotmp = a(:, 3);
tmp = mean(rhotmp);
fprintf(' �ڶ�����ƽ������ֵ��%.3f \n', tmp)

% ����ṹƽ������ֵ
rhotmp = a(tar_st : tar_ed, tar_lay);
tmp = mean(rhotmp);
fprintf(' ����ṹƽ������ֵ��%.3f \n', tmp)

% ���ಿ��
rhotmp = a( [1:3,9:end] , tar_lay);
tmp = mean(rhotmp);
fprintf(' ���ಿ��ƽ������ֵ��%.3f \n', tmp)





