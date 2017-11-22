clc; clear
%% 问题2 计算未知介质在正方形托盘中的位置、几何形状和吸收率 
load datasheet1
load datasheet2
load datasheet3
load datasheet5
load degree
R = datasheet5; % 512 x 180

l = pow2(nextpow2(size(R,1))-1);%重构图像的大小 256 x 256

%滤波反投影法
N=180;
%滤波
H=size(R,1);  % 512
h=zeros((H*2-1),1);
for i=0:H-1
    if i==0
        h(H-i)=1/4;
    elseif rem(i,2)==0
        h(H-i)=0;
        h(H+i)=0;
    else
        h(H-i)=-1/(i*pi)^2;
        h(H+i)=-1/(i*pi)^2;
    end
end
x=zeros(H,N);  % 512 x 180
for i=1:N
    s=R(:,i);
    xx=conv(s',h');  % 1 x 1534
    x(:,i)=xx(H:2*H-1);
end

%反投影
Projection=zeros(l,l);
tmp = [];
overUpperBound=0;
overLowerBound=0;
for i=1:l
    for j=1:l
        for k=1:180
            theta=(degree(k)-90)/180*pi;            
            % 中心坐标(39.1272, 56.3769) 转化后的坐标(100.1656, 111.6751)
            % 39.1272/100*256 = 100.1656
            % (100-56.3769)/100*256 = 111.6751
            % 256.6706: 旋转中心的投影坐标
            % 因为256 * sqrt(2) * sqrt(2) = 512
            t=((j - 100.1656)*cos(theta)+(111.6751-i)*sin(theta))*sqrt(2)+256.5;
            if t > 511
                t = 511;
                overUpperBound=overUpperBound+1;
            elseif t < 1
                t = 1;
                overLowerBound=overLowerBound+1;
            end
            t1=floor(t);
            t2=floor(t+1);
            Projection(i,j)=Projection(i,j)+(t2-t)*x(t1,k)+(t-t1)*x(t2,k);
            %tmp=[tmp [i;j;k]];
        end
    end
end
Projection=pi/N*Projection;
save('Projection_Mat','Projection');
tmp_datasheet1 = zeros([1, 256*256]);
tmp_datasheet2 = zeros([1, 256*256]);

for i = 1:256
    for j = 1:256
        if (Projection(i,j)<0.2)
            Projection(i,j)=0;
        end
    end
end
%Projection = Projection .* 2;

x = 1:256*256;
for i = 1:256
    for j = 1:256
        tmp_datasheet1((i-1)*256+j)=datasheet1(i,j);
        tmp_datasheet2((i-1)*256+j)=Projection(i,j);
    end
end
    
% figure;imshow(datasheet1,[]);%title('原图');
figure;imshow(Projection,[]);%title('滤波反投影法');
xlswrite('result/problem3_2.xls', Projection , 'sheet1');