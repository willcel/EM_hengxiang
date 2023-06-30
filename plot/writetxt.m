function [] = writetxt(variable, name)
    % 生成一个随机的 nxm 变量
    n = size(variable,1);
    m = size(variable,2);
    
    % 打开文本文件以写入数据
    fileID = fopen(name, 'w');
    
    % 遍历变量的每一行
    for i = 1:n
        % 将当前行的数据写入文本文件
        fprintf(fileID, '%f ', variable(i, 1:m));
        
        % 在每行的末尾添加换行符
        fprintf(fileID, '\n');
    end
    
    % 关闭文本文件
    fclose(fileID);
end
