%%
clc
% clear
close all
dbstop if error
%% ---------------------- 参数设置 ----------------------------------

%% 数据预处理的参数

% delta_pset = 1;            % 测点之间的距离 （m）
%% 反演参数
% ns = length(pset);                  % 测点的个数
% nt = 56;                        % 抽道时间
% t_st = 2.02e-3; % 2.156e-3;           % 起始时间        
% t_ed = 20e-3;       % 结束时间 
% nolayer = 5;


%% 发射参数 需要去fortran里修改重新编译
% hr = 0.01;   % 接收线圈的高度
% rt = 0.5;                 % 发射线圈的半径 m
% nturn = 3;              % 线圈的匝数
% rr = 0.25;               % 接收线圈的半径 m
% nturn1 = 20;          % 接收线 圈的匝数
% xr = 0.58;    % 中心距

%% 电流、电压数据拷贝过来
rawfolder = 'D:\willcel\code1114车_v2\EM_singleBP';
copyfile(fullfile(rawfolder, 'vobs_20ms.txt'), '.\')
copyfile(fullfile(rawfolder, 'point1set.txt'), '.\')
copyfile(fullfile(rawfolder, 'point2set.txt'), '.\')
copyfile(fullfile(rawfolder, 'point3set.txt'), '.\')
copyfile(fullfile(rawfolder, 'point4set.txt'), '.\')

% %% ------------------ 横向约束反演 --------------------------------
% {
parameter_settings = [nt; nolayer; ns; t_st; t_ed; xr; hr; rt;  rr; nturn; nturn1]; 
save('parameter_settings.txt','parameter_settings','-ascii')

path_code1 = '.\exp_nanjing_hengxiang\';   

copyfile('parameter_settings.txt',path_code1)   
copyfile('vobs_20ms.txt', path_code1) 
copyfile('point1set.txt', path_code1)  
copyfile('point2set.txt', path_code1)
copyfile('point3set.txt', path_code1)
copyfile('point4set.txt', path_code1)
% 
copyfile('rho_pro_tunnel_single.txt',path_code1)  
copyfile('dep_pro_tunnel_single.txt',path_code1)  

