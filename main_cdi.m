%%
clc
clear
close all
dbstop if error
%% ---------------------- �������� ----------------------------------

%% ����Ԥ����Ĳ���
pset = 1+[0:5, 5.5:0.5:9, 10:23];  % �������꣬�ļ��е�����
delta_pset = 1;            % ���֮��ľ��� ��m��


%% ���ݲ���
ns = length(pset);                  % ���ĸ���
nt = 56;                        % ���ʱ��
t_st = 2.02e-3; % 2.156e-3;           % ��ʼʱ��        
t_ed = 20e-3;       % ����ʱ�� 

nolayer = 5;


%% ������� ��Ҫȥfortran���޸����±���
% hr = 0.01;   % ������Ȧ�ĸ߶�
% rt = 0.5;                 % ������Ȧ�İ뾶 m
% nturn = 3;              % ��Ȧ������
% rr = 0.25;               % ������Ȧ�İ뾶 m
% nturn1 = 20;          % ������ Ȧ������
% xr = 0.58;    % ���ľ�

% %% ------------------ ����Լ������ --------------------------------
%{
parameter_settings = [nt; nolayer; ns; t_st; t_ed]; % �������Ĳ���

save('parameter_settings.txt','parameter_settings','-ascii')

path_code1 = '.\exp_nanjing_hengxiang1\';   

copyfile('parameter_settings.txt',path_code1)   
copyfile('vobs_20ms.txt', path_code1) 
copyfile('point1set.txt', path_code1)  
copyfile('point2set.txt', path_code1)
copyfile('point3set.txt', path_code1)
copyfile('point4set.txt', path_code1)
% 
copyfile('rho_pro_tunnel_single.txt',path_code1)  
copyfile('dep_pro_tunnel_single.txt',path_code1)  

