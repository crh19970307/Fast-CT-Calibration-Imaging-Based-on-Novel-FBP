circle_image = zeros(512, 128);
oval_image = zeros(512, 128);
loc = zeros(4, 180);
for i = 1:180
    for j = 1:512
        circle_image(j, i) = cross_circle(j, deg2rad(original_degree(i)));
        oval_image(j, i) = cross_oval(j, deg2rad(original_degree(i)));
    end
end
diff_image = Diff(oval_image, false);
[value, index] = sort(diff_image, 1, 'descend');
loc([1 2], :) = index([1 512], :);
diff_image = Diff(circle_image, false);
[value, index] = sort(diff_image, 1, 'descend');
loc([3 4], :) = index([1 512], :);
coord = loc;
% 小圆的投影探测器个数
circle_projection=coord(4,:) - coord(3,:); 
% 椭圆的投影探测器个数
oval_projection=coord(2,:) - coord(1,:);

mid_value_circle = coord(3,:) + circle_projection ./ 2;
mid_value_oval = coord(1,:) + oval_projection ./ 2;
circle_mean_num = mean(circle_projection);
detector_real_distance = (4 * 2) / circle_mean_num;
mid_distance = (mid_value_circle - mid_value_oval) .* (detector_real_distance);
mid_distance = mid_distance / max(abs(mid_distance));
degree = rad2deg(asin(mid_distance(1:180)));
degree = 180 - degree;
m = max(degree);
b = find(degree == m, 1, 'first');
degree = [degree(1:b), degree(b)*2-degree(b+1:180)];
xdata = deg2rad(degree(1))-deg2rad(degree);
options = optimset('MaxFunEvals',10000000); %改写一个参数，用于下面函数lsqcurvefit的设置
cosparam_est1 = lsqcurvefit(@(cosparam, xdata) cosfunc(cosparam, xdata), [206 0 239], xdata, mid_value_circle);
cosparam_est2 = lsqcurvefit(@(cosparam, xdata) cosfunc(cosparam, xdata),[46 0 247], xdata, mid_value_oval);

radius_circle = detector_real_distance * cosparam_est1(1);
theta_circle = cosparam_est1(2) + deg2rad(degree(1)) - pi/2;
pos_from_circle = [95 - radius_circle * cos(theta_circle) ;50 - radius_circle * sin(theta_circle)];
radius_oval = detector_real_distance * cosparam_est2(1);
theta_oval = cosparam_est2(2) + deg2rad(degree(1)) - pi/2;
pos_from_oval = [50 - radius_oval * cos(theta_oval) ;50 - radius_oval * sin(theta_oval)];
ang = acos((radius_oval*radius_oval + 45*45 - radius_circle*radius_circle)/2/45/radius_oval);
final_pos = [50 + radius_oval * cos(ang); 50 + radius_oval * sin(ang)];

ttt = theta_circle - theta_oval;
radius_circle = 45 / abs(sin(ttt)) * abs(sin(theta_oval));
final_pos_2 = [95 - radius_circle * cos(theta_circle) ;50 - radius_circle * sin(theta_circle)];

pos = (pos_from_circle+pos_from_oval+final_pos+final_pos_2)/4

res1 = abs(interval-detector_real_distance);
res2 = res1/interval*100;
res3 = mean(abs(degree - original_degree))*16;
res4 = mean(abs((degree - original_degree) ./ original_degree))*16;
res5 = sqrt((pos(1)-posX)*(pos(1)-posX)+(pos(2)-posY)*(pos(2)-posY));