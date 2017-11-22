%% 问题1
clc; clear;
%% 探测器单元之间的距离
load loc loc
coord = loc;
% 小圆的投影探测器个数
circle_projection=coord(4,:) - coord(3,:); 
% 椭圆的投影探测器个数
oval_projection=coord(2,:) - coord(1,:);

mid_value_circle = coord(3,:) + circle_projection / 2;
mid_value_oval = coord(1,:) + oval_projection / 2;

x = 1:180;
figure('Name', '小圆和椭圆投影中心曲线')
plot(x, 512 - mid_value_circle, x, 512 - mid_value_oval);
% 小圆投影平均覆盖探测器个数
circle_mean_num = mean(circle_projection);
% 因为是平行投影，单位：mm
detector_real_distance = 4 * 2 / circle_mean_num

%% CT系统使用的X射线的180个方向
% 椭圆和小圆投影中心之间的实际距离
mid_distance = (mid_value_circle - mid_value_oval) * detector_real_distance
% 以椭圆中心和小圆中心连线为0度，逆时针方向为度数增大方向
degree1 = rad2deg(asin(mid_distance(1:152) / 45));
degree1
degree2 = rad2deg(asin(mid_distance(153:180) / 45));
degree2 = degree1(152) + degree1(152) - degree2;
degree = [degree1 degree2]
% save degree degree

%% 确定CT系统旋转中心在正方形托盘中的位置
% y = a * sin(b * x + c)+d
% sinparam = [2 10 5 4];
xdata = deg2rad(degree);
% 拟合小圆中心正弦函数
options = optimset('MaxFunEvals',1000000); %改写一个参数，用于下面函数lsqcurvefit的设置
sinparam_est1 = lsqcurvefit(@(sinparam, xdata) sinfunc(sinparam, xdata), [100 9 2 256], xdata, 512 - mid_value_circle);
figure('Name','拟合小圆中心正弦函数');
scatter(xdata, 512 - mid_value_circle);
hold on
plot(xdata, sinfunc(sinparam_est1,xdata), 'g-') ;
legend({'观测值','拟合值'});
figure('Name','拟合椭圆中心正弦函数');
% 拟合椭圆中心正弦函数
sinparam_est2 = lsqcurvefit(@(sinparam, xdata) sinfunc(sinparam, xdata),[150 1 30 256], xdata, 512 - mid_value_oval);
scatter(xdata, 512 - mid_value_oval) ;
hold on
plot(xdata,sinfunc(sinparam_est2, xdata), 'g-');
legend({'观测值','拟合值'});

sinparam_est1
sinparam_est2
alpha = rad2deg(sinparam_est2(3) - sinparam_est1(3));
AB = sinparam_est2(1) / 256 * 100; AC = 45; BC = sinparam_est1(1) / 256 * 100;
beta = asin(AB / AC * sin(alpha))
% 以小圆圆心为基准
% y方向 小圆圆心与旋转中心距离
delta_y = BC * sin(beta)
% x方向 小圆圆心与旋转中心距离
delta_x = BC * cos(beta)






