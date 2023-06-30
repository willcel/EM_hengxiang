需要把单点结果作为横向初始值
启动需要
pointset 1-4
vobs
dep\rho single.txt
parameter_settings

step1:
对单点选择结果，找到文件
a06021_0614v2.mat

划分层数，可视化
tranSingleRes.m

step2: 
填约束文件
隧道测点不约束
第一层统一约束（？）

step3：
把bindarr拷贝进f90文件
确定coef约束系数

step4:
把单点文件夹最新的电压拷贝过来，然后
用main函数把电压等拷贝进横向文件夹

