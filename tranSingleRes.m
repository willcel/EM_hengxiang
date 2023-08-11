% clear
% close all
dbstop if error
% pset = 1+[0:5, 5.5:0.5:9, 10:23];  % 测点的坐标，文件夹的名称
delta_pset = 1;

ns = length(pset);               
nolayer = 5;                  % 
total_depth = 25;           % 
no_para = 2 * nolayer -1;


load('D:\willcel\测线4-0629\EM_singleBP\selectAns.mat')
a = selectAns;

    %% 调整分区
    % sg1:把第四层取消，第二层一分为二
    % sg2:一共三层，第三层和第二层互换，然后取消第四层，第二层一分为二
    % sg3:
    % sg4:取消第四第五层，第二层开头处分出两层作为New第二和第三层
    %  sg1
%     for i = [1,2,3,4,5,8,9,10,11,12,13,14,15,16,17]
%         a(i,:) = sg1(a(i,:));
%     end
%     %  sg2
%     for i = [13,16]
%         a(i,:) = sg2(a(i,:));
%     end
%     % sg4
%     for i = [3]
%         a(i,:) = sg4(a(i,:));
%     end

%% 写入结果
% {
rho_pro = a(:,1:5);
dep_pro = a(:,6:9);


rho_pro1 = zeros(ns*nolayer,1);
dep_pro1 = zeros(ns*nolayer,1);

for i=1:size(rho_pro,1)

    for j=1:size(rho_pro,2)

        rho_pro1(j+(i-1)*size(rho_pro,2)) = rho_pro(i,j);
        
        if(j~=5)
            dep_pro1(j+(i-1)*size(rho_pro,2)) = dep_pro(i,j);
        else
            dep_pro1(j+(i-1)*size(rho_pro,2)) = 1;
        end
        
    end
end

dep_pro1(dep_pro1<=0) = 1;


save('rho_pro_tunnel_single.txt','rho_pro1','-ascii')
save('dep_pro_tunnel_single.txt','dep_pro1','-ascii')
%}

%  close all



%% 纯粹画图
    % 不同层之间划分，方便观察
    depthSeparate = a(:,6:9);
    for j = 2:4
        depthSeparate(:,j) = depthSeparate(:,j-1) + depthSeparate(:,j);
    end

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
    
    mat(mat==1)=NaN;


    % ---- 为了pcolor画出最后一个测点 ---------
    xdraw_range = [pset, pset(end)+1]; mat = [mat;zeros(1,total_depth*scale_factor)];

    % ---------------------------------------
    figure(Position=[83.666666666667	89.666666666667	1046	600.666666666667]) 

    h=pcolor(delta_pset*(xdraw_range - min(xdraw_range)),y,log10(mat'))
    shading flat
    % h.EdgeColor = 'none';
%     shading interp
%     xlim([0 8])
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
        %     scatter(i-0.25,1,'^')
                text(xdraw_range(i)-delta_pset*0.5, 3, num2str(i), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'bottom', 'FontSize', 12);
    end
    
    for i = 1:ns
        hold on
        for k = 1:4
            plot([xdraw_range(i) xdraw_range(i+1)]-1, [depthSeparate(i,k) depthSeparate(i,k)], 'r', 'LineWidth', 1)
        end
        hold off
    end
%%




function tar = sg1(a_in)
    % sg1:把第四层取消，第二层一分为二
    
    rho = a_in(:,1:5);
    dep = a_in(:,6:9);
    dep(4) = dep(3); % 
    tmp = dep(2)/2;
    dep(2) = tmp;
    dep(3) = tmp;
    rho([4,3]) = rho([3,2]);
    tar = [rho,dep];
end

function tar = sg2(a_in)
    % sg2:一共三层，第三层和第二层互换，然后取消第四层，第二层一分为二
    
    rho = a_in(:,1:5);
    dep = a_in(:,6:9);

    tmp1 = rho(2); 
    rho(2) = rho(3); 
    rho(3) = tmp1; 
    tmp2 = dep(2);
    dep(2) = dep(3);
    dep(3) = tmp2;

    dep(4) = dep(3); % 
    tmp = dep(2)/2;
    dep(2) = tmp;
    dep(3) = tmp;
    rho([4,3]) = rho([3,2]);
    tar = [rho,dep];
end



function tar = sg4(a_in)
    % sg4:取消第四第五层，第二层开头处分出两层作为New第二和第三层
    
    rho = a_in(:,1:5);
    dep = a_in(:,6:9);

    tmp1 = dep(2);
    dep(2) = 1;
    dep(3) = 1;
    dep(4) = tmp1 - 2;
    tmp2 = rho(2);
    rho(2) = tmp2;
    rho(3) = tmp2;
    rho(4) = tmp2;

    tar = [rho,dep];
end

