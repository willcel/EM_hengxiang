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
% para ÿ��ǰ����nolayer��rho��Ȼ����nolay-1��dep
npara = 2*nolayer-1; % 9
size1 = (ns-1)*npara; % 16*9=

% ǰ��׼����������׼��һ�� [a,b] �����ԣ���������Ƶ�Լ������
% �����þ�������ݽṹ���� a,b ��Ϊ�������꣬����ֵΪԼ����С��a�ܳ���ns-1��b�ܳ���npara
% ������������һһ��Ӧ������ Wp
a = ns - 1;
b = npara;
coef = 1;
bindarr = ones(a,b) * coef; % coef��ȫ�ּӵ�Լ�������ﶨ1.5

%{
! 06022
! ����fortran�﷨д
! �ṹ4-8��Լ������Ҫ��3-4��ʼ��8-9
coef = 1.5
bindarr = coef
bindarr(3:8,:) = 0.001

! �ṹ1-3�ĵ��Ĳ����ֵ��Լ��
bindarr(1:2,4) = 0.001

! ����ṹ���ڲ�����ֵ����Լ������������
bindarr(4:7,1:5) = coef

! �ṹ12����ֵ��Լ��
bindarr(11:12,4)
%}

% {
! 0628/cexian2
! ����fortran�﷨д
! �ṹ8-12��Լ������Ҫ��7-8��ʼ��12-13
coef = 1.5 ! ����Լ����ϵ��
bindarr = coef
bindarr(7:12,:) = 0.001

! 0629/cexian1
! ����fortran�﷨д
! �ṹ3-6��Լ������Ҫ��2-3��ʼ��6-7
coef = 1.5 ! ����Լ����ϵ��
bindarr = coef
bindarr(2:6,:) = 0.001
%}

show = bindarr';
% ת��bindarrΪWp����
for a = 1:ns-1
    for b = 1:npara
        Wp((a-1)*npara+b,(a-1)*npara+b) = bindarr(a,b);
    end
end

%{
    04071
% �ṹ5-9��Լ������Ҫ��4-5��ʼ��9-10
bindarr(4:9,:) = 0.001;

% ���12-15����Լ����������Ҫ��11-12,15-16СһЩ
bindarr([11 15], :) = 0.001;

% ���ǽṹ5-9, 12-15 �ĵ�һ�����㻹�ǿ��Բ���ȫ��Լ���ģ�����b=1��b=nolayer+1��ʱ��
bindarr(:,[1 6]) = coef;
% ����ṹ���ڲ�����ֵ����Լ�����������ѣ��ڲ���5-6��ʼ��8-9
bindarr(5:8,1:5) = coef;
%}


% 04072
%{
% �ṹ7-11���һ ����Լ������6-7��ʼ��11-12
% �ṹ16-19����� ����Լ��, ��15-16��ʼ��18-19
bindarr(6:11,:) = 0.001;
bindarr(15:18,:) = 0.001;
% 14-15��ҪССԼ��һ�£���Сһ��
bindarr(14,:) = 0.5;
% 12,13 ���ܺ��Ա�Լ������11-12, 13-14
bindarr([11 13],:) = 0.001;
% 12,13 �ڲ�����Լ��, 12-13
bindarr(12,:) = coef;

% ���2,5,6�ĵ��費�ܺ����ڵĸ���Լ����������ҪԼ����ȣ�ƽ��һЩ��
bindarr(1:5, 4) = 0.001;

% ���ǽṹ�ĵ�һ�����㻹�ǿ��Բ���ȫ��Լ���ģ�����b=1��b=nolayer+1��ʱ��
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
Rp(1,1:npara*ns) =   ϡ�����, ֻ��rho11��1, rho12����-1
Rp(2,:)          ��� rho12-rho22
Rp(nolayer+1,:)  ��� dep11-dep21
Rp(npara+1,:)    ��� rho21-rho31

% Wp*Rp*deltaM = erp
% erp size:    Sx1, size1 X 1
erp(1:npara, 1) = rho11-rho21, rho12-rho22, ... , rho1N-rho2N, dep11-dep21, dep12-dep22, ..., dep1N-dep2N

% �� a ����㣬 �� b ��ĵ����� 
deltaM( (a-1)*npara + b, 1 )
% �� a+1 ����㣬 �� b ��ĵ����� 
deltaM( (a)*npara   + b, 1 )
% ��Ӧ�Ĺ�ϵ
Rp( (a-1)*npara + b, (a-1)*npara + b) = 1
Rp( (a-1)*npara + b, (a )*npara + b) = -1

% �� a ����㣬 �� b ��Ĳ��� �������� b+N��������
deltaM( (a-1)*npara + b + N, 1 )  % N = nolayer
% �� a+1 ����㣬 �� b ��Ĳ��� 
deltaM( (a)*npara   + b + N, 1 )  % N = nolayer
% ��Ӧ�Ĺ�ϵ
Rp( (a-1)*npara + b + N, (a-1)*npara + b + N) = 1
Rp( (a-1)*npara + b + N, (a )*npara + b + N) = -1

% �������Ҫ����a��������a+1�����ģ���b�����ֵԼ����Ϊ0.01����ô��Ҫ
Rp( (a-1)*npara + b, (a-1)*npara + b) = 0.01
Rp( (a-1)*npara + b, (a )*npara + b) = -0.01
% ����ζ�ţ���Rp�ĵ� (a-1)*npara + b ���ϳ�һ��ϵ�������Եȼ���
Wp((a-1)*npara + b, (a-1)*npara + b) = 0.01;
%}





