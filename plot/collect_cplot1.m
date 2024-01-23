

folderbase = 'D:\willcel\code0111汤山\EM_hengxiang\';
folder2 = fullfile(folderbase, 'plot');
savefold = fullfile(folder2, '\0111v2-1.5');

mkdir(savefold)
cd(savefold)
%
rawfileid = fullfile(folderbase, '\exp_nanjing_hengxiang\res2d.dat');
fileid = fullfile(folder2, 'res2d.dat');
copyfile(rawfileid, fileid)

% data = textread(fileid, '%s', 'delimiter', '\n');

data = load(fileid);

para = data;
save( fullfile(savefold,'res.mat'), "data")
copyfile( fullfile(folder2,'res2d.dat'), fullfile(savefold,'res2d.dat'))
% copyfile( fullfile(folder2,'log.dat'), fullfile(savefold,'log.dat'))
groupFinish = 30;
%%
j=1;
for ii = 1:groupFinish
    
    tmp = para(ii,:);
    a = reshape(tmp,(2*nolayer-1),ns);
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
    figure('Position',[10 10 1200 600])
    pcolor(delta_pset*(xdraw_range - min(xdraw_range)),y,log10(mat'))
    
    shading flat%
%     shading interp
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

    for i = 1:ns
        % 追求标号的准确性
        if(i<ns) interval = xdraw_range(i+1)-xdraw_range(i); end

        text(xdraw_range(i)-1 + 0.5*interval, 2, num2str(i), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', 'FontSize', 12);
    end
    saveas(gcf, fullfile(savefold,[num2str(ii),'.tif']) )
end
%%
cd ..
cplot_err