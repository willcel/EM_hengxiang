%% 分块展示
% clc
clear
close all
dbstop if error
pset = 1:17;
% delta_pset = 1;            % 娴嬬偣涔嬮棿鐨勮窛绂? 锛坢锛?
ns = length(pset);                  % 娴嬬偣鐨勪釜鏁?
nolayer = 5;                  % 鍒掑垎鐨勫眰鏁?
total_depth = 25;           % 鏈?澶ф繁搴? m
no_para = 2 * nolayer -1;

%% load 文件
savename = '.\a060210618v1-1.5.mat';
load(savename)

saveFigName = 'D:\0602测线1横向约束结果\1Mgroup.tif';

%% 定义一下基本结构
% 隧道结构
% 起步和终止测点
tar_st = 4;
tar_ed = 8;

% 顶点位置
tar_mid = 6;

% 目标层数
tar_lay = 4;

%% 微调参数
a1 = a;

% 测点4第一层调整厚度
height_4_1 =  a1(4,1+5) ;
height_4_2 =  a1(4,2+5) ;
height_3_1 =  a1(3,1+5) ;
tmp = abs(height_4_1 - height_3_1) ;
a1(4,1+5) =  height_4_1 - tmp ;
a1(4,2+5) =  height_4_2 + tmp ;



%% 开始画图，step1分割横线，step2分割竖线，step3
depth_layer = zeros(ns,4);
for i=1:4
    for j = 1:i
        depth_layer(:,i) = depth_layer(:,i)+a1(:,j+nolayer);
    end
end

% step1分割横线
seperate_lines = zeros(ns,3);
seperate_lines(:,1) = depth_layer(:,1);
for k=1:ns
%     if ismember(k ,[5 6 7 8 9  12 13 14 15])  % 3个分界面

        seperate_lines(k,2) = depth_layer(k,3);
        seperate_lines(k,3) = depth_layer(k,4);

%     elseif ismember(k, [1 2 3 4 10 11 16 17]) % 只有两个分界面
%         seperate_lines(k,2) = depth_layer(k,4);
%         seperate_lines(k,3) = depth_layer(k,4)+0.01;
%     end
end

% 处理一下太深的高阻
% seperate_lines([1:4],[2 3]) = seperate_lines([1:4],[2 3]) -4;
% seperate_lines([10],[2 3]) = seperate_lines([10],[2 3]) -2;

d1 = total_depth-seperate_lines;
x = 1:ns;
xi = 1:1/10:ns;
d2 = [];
for i=1:3
    y = d1(:,i);
    yi = interp1(x,y,xi, 'spline');
    d2 = [d2; yi];
end
figure
for i=1:size(d2,1)
    plot(xi, d2(i,:),'b-','LineWidth', 4.5)
    hold on
end



%% % step2分割竖线，标示出隧道结构
ind_st = find(xi==tar_st);
ind_ed = find(xi==tar_ed);

ind = ind_st:ind_ed;
tunnel = d2(2:3,ind);

shift = 0;
ind1 = ind_st-shift:ind_ed+shift;
tunnel1 = d2(2:3,ind1); % 获取线段端点的坐标

% 四段包围成一个图案
plot(xi(ind), tunnel(1,:),'k-','LineWidth', 4.5)
hold on
plot(xi(ind1), tunnel1(2,:),'k-','LineWidth', 4.5)
hold on
plot([xi(ind(1)), xi(ind1(1))], [tunnel(1,1), tunnel1(2,1)],'k-','LineWidth', 4.5)
hold on
plot([xi(ind(end)), xi(ind1(end))], [tunnel(1,end), tunnel1(2,end)],'k-','LineWidth', 4.5)

ylim([0,total_depth])
axis off
xlabel('X axis (m)','FontName','Calibri','FontSize',15,'FontWeight','bold')
ylabel('Z axis (m)','FontName','Calibri','FontSize',15,'FontWeight','bold')
set(gca,'defaultfigurecolor','w')    


% 不同分辨率数组，重新对rho赋值
depth_new = total_depth-d2';    % 3301x3
rho_new = zeros(size(depth_new,1),4);
rho_new(:, 1) = 0.4;
rho_new(:, 2) = -0.8;
rho_new(:, 3) = -2.4; % 标注第二个低阻体
rho_new( ind, 3) = -3;

% rho_new( find(xi==11):find(xi==15), 3) = -2.1; 

rho_new(:, 4) = 5;
a = [rho_new, depth_new(:,1), depth_new(:,2)-depth_new(:,1), depth_new(:,3)-depth_new(:,2)];
ns = size(a,1);                 % 测点数


%% 最后画图展示
nolayer = 4;         % 层数
scale_factor = 10;
mat = zeros(ns,total_depth*scale_factor);
for x = 1:ns  
    depth = zeros(1,nolayer-1);
    for k=1:nolayer-1
        for t = 1:k
            depth(k) = depth(k)+a(x,t+1*nolayer);
        end
    end

    for y = 1:total_depth*scale_factor
        y1 = y/scale_factor;
        
        flag=0;
        for i=1:nolayer-1
            if(y1<=depth(i))
                mat(x,y)=a(x,i);

                
                flag=1;
                break
            end
            
            if(flag==0)
                mat(x,y)=a(x, nolayer);

            end
            
        end
    end
    
end



dy = 1/scale_factor;
y = 0:dy:total_depth-dy;

figure%(Position=[1221	413.666666666667	784	625.333333333333])
imagesc(0.5*xi-0.5, y, mat')
colormap jet
xlabel('测线 (m)','FontSize',15,'FontWeight','bold')
ylabel('深度 (m)','FontSize',15,'FontWeight','bold')
set(gca,'FontSize',18,'FontWeight','bold')
caxis([-4,2])
% save('mat_20ms0210.mat', 'mat')
saveas(gcf, saveFigName )
% h=colorbar;