
pset = 1+[0:5, 5.5:0.5:9, 10:23];  % 测点的坐标，文件夹的名称
delta_pset = 1;            % 测点之间的距离 （m）
ns = length(pset);
total_depth = 25; 
nolayer = 5;



folder2 = "D:\0628五棵松相关\测线2\EM_hengxiang\exp_nanjing_hengxiang1";
savefold = 'D:\0628五棵松相关\测线2\EM_hengxiang\plot\处理结果\0630v1-1.5';

mkdir(savefold)
cd(savefold)
%
fileid = fullfile(folder2, 'res2d.dat');

data = textread(fileid, '%s', 'delimiter', '\n');
%{
% 涓嶆厧璁板綍涓烘瘡琛?13涓?鏁板瓧锛屽疄闄呭簲璇ヤ??9涓?鍙傛暟锛?17*9
groupFinish = floor(length(data) / 12); 

para = [];
for i = 1:groupFinish
    index = (1:12) + (i-1)*12;
    tmp = [];
    for j = index
        str = cell2mat(data(j));
        str_array = strsplit(str);
        num_array = str2double(str_array);
        tmp = [tmp num_array];
    end
    para = [para; tmp];
end
%}
groupFinish = floor(length(data) / ns);

para = [];
for i = 1:groupFinish
    index = (1:ns) + (i-1)*ns;
    tmp = [];
    for j = index
        str = cell2mat(data(j));
        str_array = strsplit(str);
        num_array = str2double(str_array);
        tmp = [tmp num_array];
    end
    para = [para; tmp];
end

save( fullfile(savefold,'res.mat'), "para")
copyfile( fullfile(folder2,'res2d.dat'), fullfile(savefold,'res2d.dat'))
copyfile( fullfile(folder2,'log.dat'), fullfile(savefold,'log.dat'))

%%
j=1;
for ii = 1:groupFinish
    
    tmp = para(ii,:);
    a = reshape(tmp,9,ns);
    a = a';

    scale_factor = 100;
    mat = zeros(ns,total_depth*scale_factor);
    
    for x = 1:ns %*10
        
        depth = zeros(1,nolayer-1);
        for k=1:nolayer-1
            for t = 1:k
                depth(k) = depth(k)+a(max(1,x),t+1*nolayer);
            end
        end
        
        
        for y = 1:total_depth*scale_factor
            y1 = y/scale_factor;
            
            flag=0;
            for i=1:nolayer-1
                if(y1<=depth(i))
                    mat(x,y)=a(max(1,x),i);
                    
                    
                    flag=1;
                    break
                end
                
                if(flag==0)
                    mat(x,y)=a(max(1,x), nolayer);
                    
                end
                
            end
        end
        
    end
    
    
    dy = 1/scale_factor;
    y = 0:dy:total_depth-dy;
    %%
    mat(mat==1)=NaN;


    % ---- 涓轰簡pcolor鐢诲嚭鏈?鍚庝竴涓?娴嬬?? ---------

    xdraw_range = [pset, pset(end)+1]; mat = [mat;zeros(1,total_depth*scale_factor)];

    close all
    figure('Position',[200 200 1500 800])
    pcolor(delta_pset*(xdraw_range - min(xdraw_range)),y,log10(mat'))
    
    shading flat%interp
    colormap jet
    xlabel('Measurement Line / m','FontSize',15,'FontWeight','bold')
    ylabel('Depth / m','FontSize',15,'FontWeight','bold')
    h=colorbar;
    set(get(h,'title'),'string','log10(\rho)');
    % title('predicted model')
    set(gca,'FontSize',14,'FontWeight','bold')
    caxis([-4,2])
    set(gca,'ydir','reverse')
    title(sprintf('Iter %.0f', ii))


    saveas(gcf, fullfile(savefold,[num2str(ii),'.tif']) )
end

% cplot_err