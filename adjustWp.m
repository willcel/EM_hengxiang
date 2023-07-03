%{
do i=1,size1
    if(i .ge. (1+3*npara) .and. i .le. 10*npara)then
        Wp(i,i) = 0.001
    else
        Wp(i,i) = 1.5
    end if
end do
%}


ns = 17;
nolayer = 5;
% para 每行前面是nolayer个rho，然后是nolay-1个dep
npara = 2*nolayer-1; % 9
size1 = (ns-1)*npara; % 16*9=

% 前期准备工作，先准备一批 [a,b] 的数对，表征想控制的约束集合
% 或者用矩阵的数据结构，把 a,b 作为横纵坐标，矩阵值为约束大小。a总长度ns-1，b总长度npara
% 最后由这个矩阵一一对应着生成 Wp
a = ns - 1;
b = npara;
coef = 1;
bindarr = ones(a,b) * coef; % coef是全局加的约束，这里定1.5

%{
! 06022
! 请用fortran语法写
! 结构4-8不约束，需要从3-4开始到8-9
coef = 1.5
bindarr = coef
bindarr(3:8,:) = 0.001

! 结构1-3的第四层的阻值不约束
bindarr(1:2,4) = 0.001

! 隧道结构体内部的阻值可以约束，埋深不变而已
bindarr(4:7,1:5) = coef

! 结构12的阻值不约束
bindarr(11:12,4)
%}

% {
! 0628/cexian2
! 请用fortran语法写
! 结构8-12不约束，需要从7-8开始到12-13
coef = 1.5 ! 横向约束的系数
bindarr = coef
bindarr(7:12,:) = 0.001

! 0629/cexian1
! 请用fortran语法写
! 结构3-6不约束，需要从2-3开始到6-7
coef = 1.5 ! 横向约束的系数
bindarr = coef
bindarr(2:6,:) = 0.001
%}

show = bindarr';
% 转换bindarr为Wp矩阵
for a = 1:ns-1
    for b = 1:npara
        Wp((a-1)*npara+b,(a-1)*npara+b) = bindarr(a,b);
    end
end

%{
    04071
% 结构5-9不约束，需要从4-5开始到9-10
bindarr(4:9,:) = 0.001;

% 测点12-15单独约束，所以需要让11-12,15-16小一些
bindarr([11 15], :) = 0.001;

% 但是结构5-9, 12-15 的第一层高阻层还是可以参与全局约束的，就是b=1和b=nolayer+1的时候
bindarr(:,[1 6]) = coef;
% 隧道结构体内部的阻值可以约束，埋深不变而已，内部从5-6开始到8-9
bindarr(5:8,1:5) = coef;
%}


% 04072
%{
% 结构7-11隧道一 不加约束，从6-7开始到11-12
% 结构16-19隧道二 不加约束, 从15-16开始到18-19
bindarr(6:11,:) = 0.001;
bindarr(15:18,:) = 0.001;
% 14-15需要小小约束一下，加小一点
bindarr(14,:) = 0.5;
% 12,13 不能和旁边约束，即11-12, 13-14
bindarr([11 13],:) = 0.001;
% 12,13 内部可以约束, 12-13
bindarr(12,:) = coef;

% 测点2,5,6的低阻不能和相邻的高阻约束。但是需要约束厚度，平滑一些。
bindarr(1:5, 4) = 0.001;

% 但是结构的第一层高阻层还是可以参与全局约束的，就是b=1和b=nolayer+1的时候
bindarr(:,[1 6]) = coef;
%}



%{
% Rp = Wp*Rp
% Rp size: SxT,  size1 X (ns)*npara
% Wp size: SxS,  size1 X size1
% Wp*Rp*deltaM = erp
% deltaM size: Tx1, ns*npara X 1
deltaM(1:npara, 1) = rho11, rho12, ..., rho1N, dep11, dep12, ... ,dep1N
deltaM(npara+1, 1) = rho21
Rp(1,1:npara) =       1,  0 , ...,      0,     0,     0,     0,    0
Rp(1,1:npara*ns) =   稀疏矩阵, 只有rho11是1, rho12下是-1
Rp(2,:)          针对 rho12-rho22
Rp(nolayer+1,:)  针对 dep11-dep21
Rp(npara+1,:)    针对 rho21-rho31

% Wp*Rp*deltaM = erp
% erp size:    Sx1, size1 X 1
erp(1:npara, 1) = rho11-rho21, rho12-rho22, ... , rho1N-rho2N, dep11-dep21, dep12-dep22, ..., dep1N-dep2N

% 第 a 个测点， 第 b 层的电阻率 
deltaM( (a-1)*npara + b, 1 )
% 第 a+1 个测点， 第 b 层的电阻率 
deltaM( (a)*npara   + b, 1 )
% 对应的关系
Rp( (a-1)*npara + b, (a-1)*npara + b) = 1
Rp( (a-1)*npara + b, (a )*npara + b) = -1

% 第 a 个测点， 第 b 层的层厚度 （看作第 b+N个参数）
deltaM( (a-1)*npara + b + N, 1 )  % N = nolayer
% 第 a+1 个测点， 第 b 层的层厚度 
deltaM( (a)*npara   + b + N, 1 )  % N = nolayer
% 对应的关系
Rp( (a-1)*npara + b + N, (a-1)*npara + b + N) = 1
Rp( (a-1)*npara + b + N, (a )*npara + b + N) = -1

% 所以如果要将第a个测点与第a+1个测点的，第b层的阻值约束改为0.01，那么需要
Rp( (a-1)*npara + b, (a-1)*npara + b) = 0.01
Rp( (a-1)*npara + b, (a )*npara + b) = -0.01
% 这意味着，在Rp的第 (a-1)*npara + b 行上乘一个系数，所以等价于
Wp((a-1)*npara + b, (a-1)*npara + b) = 0.01;
%}





