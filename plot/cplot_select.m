% % 瀹炴祴鏁版嵁鐨勪綔鍥?
% % function [] = myplot4(ns, nolayer, pset, total_depth, delta_pset)
% clear
% close all
dbstop if error
% pset = 1+[0:5, 5.5:0.5:9, 10:23];  % 测点的坐标，文件夹的名称
delta_pset = 1;               % 娴嬬偣涔嬮棿鐨勮窛绂? 锛坢锛?
ns = length(pset);                  % 娴嬬偣鐨勪釜鏁?
% nolayer = 6;                  % 鍒掑垎鐨勫眰鏁?
% total_depth = 50;           % 鏈?澶ф繁搴? m
no_para = 2 * nolayer -1;
%%

%%
interpPlot = 1;
filefolder = savefold;
savename ='.\selectAns_Hengxiang.mat';

saveRawName = '.\raw.tif';
saveReviseName = '.\revise.tif';

saveFigName = saveRawName;
a1 = []; 

fileid = fopen( fullfile(filefolder, 'res2d.dat'   ));
res = textscan(fileid,'%f64');
res2 = res{1,1}; res2 = res2';
line = length(res2)/(2*nolayer-1);
res3 = reshape(res2, [ (2*nolayer-1),line]);
res4 = res3';
iterA = floor(line / ns);
fclose(fileid)


ii = 30;
indLine = (1:ns) + (ii-1)*ns;
a = res4(indLine, :);

layerHeight = a(:, nolayer+1:end);
a_observe = zeros(ns, nolayer-1);
a_observe(:, 1) = layerHeight(:, 1);
for layer = 2:4
    a_observe(:, layer) = layerHeight(:,layer)+a_observe(:,layer-1);
end
a_observe = a_observe';


%% 图像美观修正
% 
% layerHeight(4:8, 4) = 2.5;
% layerHeight(4,1) = 7;
% a(:, 6:end) = layerHeight;


%%
selectAns_Hengxiang = a;
save( savename,'selectAns_Hengxiang')


scale_factor = 100;
mat = zeros(ns,total_depth*scale_factor);


for x = 1:ns 
    
    depth = zeros(1,nolayer-1);
    for k=1:nolayer-1
        for t = 1:k
            depth(k) = depth(k)+a(max(1,round(x)),t+1*nolayer);
        end
    end
    
    
    for y = 1:total_depth*scale_factor
        y1 = y/scale_factor;
        
        flag=0;
        for i=1:nolayer-1
            if(y1<=depth(i))
                mat(x,y)=a(max(1,round(x)),i);
                
                
                flag=1;
                break
            end
            
            if(flag==0)
                mat(x,y)=a(max(1,round(x)), nolayer);
                
            end
                
        end
    end
    
end


dy = 1/scale_factor;
y = 0:dy:total_depth-dy;
%%
% writetxt(mat','.\0629测线1.txt')

xdraw_range = [pset, pset(end)+1]; mat = [mat;zeros(1,total_depth*scale_factor)];

close all
figure('Position',[10 10 1200 600])
pcolor(delta_pset*(xdraw_range - min(xdraw_range)),y,log10(mat'))
    
if interpPlot == 0
shading flat%
else
shading interp
xlim([0 pset(end)-1])
end


colormap jet
xlabel('Measurement Line / m','FontSize',15,'FontWeight','bold')
ylabel('Depth / m','FontSize',15,'FontWeight','bold')
h=colorbar;
set(get(h,'title'),'string','log10(\rho)');
% title('predicted model')
set(gca,'FontSize',18,'FontWeight','bold')
caxis([-4,2])
set(gca,'ydir','reverse')
    for i = 1:ns
        % 追求标号的准确性
        if(i<ns) interval = xdraw_range(i+1)-xdraw_range(i); end

        text(xdraw_range(i)-1 + 0.5*interval, 2, num2str(i), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', 'FontSize', 12);
    end
%{
for i = 1:ns
    text(i*0.5-0.25, 2, num2str(i), ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', 'FontSize', 12);
end

%}

saveas(gcf, saveFigName )


%     close all
