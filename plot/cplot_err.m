
%%
rawfileid = fullfile(folderbase, '\exp_nanjing_hengxiang\log.dat');
% fileid = fullfile(folder2, 'log.dat');
fileid = fopen( rawfileid );

error1 = [];
error2 = [];
error3 = [];
while ~feof(fileid)
    tline=fgetl(fileid);
    if strcmp(tline,' error1:')
        tline = fgetl(fileid);
        error1 = [error1  str2num(tline)];
        continue
    end
    if strcmp(tline,' error2:')
        tline = fgetl(fileid);
        error2 = [error2  str2num(tline)];
        continue
    end
    if strcmp(tline,' error3:')
        tline = fgetl(fileid);
        error3 = [error3  str2num(tline)];
        continue
    end
end
% save(sprintf('error%d.mat', i),"error")
fclose all;

%%
%
figure
semilogy( error1, '-o','LineWidth',1.3)
grid on
hold on
xlabel('反演迭代次数')
ylabel('反演结果误差')
set(gca,'FontSize',14,'FontWeight','bold')
title('数值拟合误差')
name = fullfile(savefold,'error1.fig');
saveas(gcf, name)
name = fullfile(savefold,'error1.tif');
saveas(gcf, name)

figure
semilogy( error2, '-o','LineWidth',1.3)
grid on
hold on
xlabel('反演迭代次数')
ylabel('反演结果误差')
set(gca,'FontSize',14,'FontWeight','bold')
title('横向约束参数拟合误差')
name = fullfile(savefold,'error2.fig');
saveas(gcf, name)
name = fullfile(savefold,'error2.tif');
saveas(gcf, name)

figure
semilogy( error3, '-o','LineWidth',1.3)
grid on
hold on
xlabel('反演迭代次数')
ylabel('反演结果误差')
set(gca,'FontSize',14,'FontWeight','bold')
title('综合误差')
name = fullfile(savefold,'error3.fig');
saveas(gcf, name)
name = fullfile(savefold,'error3.tif');
saveas(gcf, name)