clc;clear;
%% 计算10个点的吸收率
x=[10.0000 34.5000 43.5000 45.0000 48.5000 50.0000 56.0000 65.5000 79.5000 98.5000];
y=[18.0000 25.0000 33.0000 75.5000 55.5000 75.5000 76.5000 37.0000 18.0000 43.5000];

Projection = xlsread('result/problem3_2.xls');

y_new = floor(x .* 2.56);
x_new = 256 - floor(y .* 2.56);

result = zeros([1 10]);
for i=1:10
    value=Projection(x_new(i), y_new(i)) + Projection(x_new(i)+1,y_new(i)) + Projection(x_new(i)-1, y_new(i)) ...
        + Projection(x_new(i), y_new(i)+1) + Projection(x_new(i)+1,y_new(i)+1) + Projection(x_new(i)-1, y_new(i)+1) ...
        + Projection(x_new(i), y_new(i)-1) + Projection(x_new(i)+1,y_new(i)-1) + Projection(x_new(i)-1, y_new(i)-1);
    result(i)=value/9;
end

figure('Name','Fig1');
imshow(Projection,[]);
hold on
scatter(y_new, x_new, 'w');
result
    

