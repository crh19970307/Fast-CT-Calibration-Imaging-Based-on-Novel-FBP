params = [[50 50 20];[20 80 15];[80 80 10];[20 20 15];[80 20 10]];
interval = normrnd(0.3, 0.05);
begin_deg = normrnd(100, 5);
original_degree = begin_deg:begin_deg+179;
zero = normrnd(256.5, 5);
posX = normrnd(50, 10);
posY = normrnd(50, 10);

circle_image = zeros(5, 512, 128);
diff_image = zeros(5, 512, 128);
loc = zeros(5, 2, 180);
for k = 1:5
    for i = 1:180
        for j = 1:512
            circle_image(k, j, i) = cross_circle_2(j, deg2rad(original_degree(i)), posX, posY, params(k, 1), params(k, 2), zero, interval, params(k, 3));
        end
    end
    diff_image = Diff(reshape(circle_image(k, :, :), 512, 180), false);
    [value, index] = sort(diff_image, 1, 'descend');
    loc(k, :, :) = index([1 512], :);
end
sum_image = reshape(sum(circle_image), 512, 180);
% figure('Name','图像边界');
% imshow(sum_image, []);
% hold on
% plot (1:180,reshape(loc(2,2,:), 1, 180),'LineWidth',1)


Interval = 2 * params(1,3) / mean(loc(1, 2, :) - loc(1, 1, :), 3);

cent = reshape((loc(2:5, 2, :) + loc(2:5, 1, :)) / 2, 4, 180) - 0.5;
proj_1 = (cent(2, :, :) - cent(3, :, :)) / 60 / sqrt(2) * Interval;
proj_1 = proj_1 / max(abs(proj_1));
degree1 = rad2deg(asin(proj_1) + pi/4);
m = max(degree1);
b = find(degree1 == m, 1, 'first');
degree1 = [degree1(1:b), degree1(b)*2-degree1(b+1:180)];
proj_2 = (cent(4, :, :) - cent(1, :, :)) / 60 / sqrt(2) * Interval;
proj_2 = proj_2 / max(abs(proj_2));
degree2 = 180 - rad2deg(asin(proj_2) + pi/4);
m = max(degree2);
b = find(degree2 == m, 1, 'first');
degree2 = [degree2(1:b), degree2(b)*2-degree2(b+1:180)];

degree = (degree1 + degree2) /2;
xdata = deg2rad(degree(1))-deg2rad(degree);
options = optimset('MaxFunEvals',10000000); %改写一个参数，用于下面函数lsqcurvefit的设置

radius = zeros(1, 4);
theta = zeros(1, 4);
pos = zeros(4, 2);
for k=1:4
    cosparam_est1 = lsqcurvefit(@(cosparam, xdata) cosfunc(cosparam, xdata), [141 0 256], xdata, cent(k,:));
    radius(1, k) = Interval * cosparam_est1(1);
    theta(1, k) = cosparam_est1(2) + deg2rad(degree(1)) - pi/2;
    pos(k, :) = [params(k+1, 1) - radius(1, k) * cos(theta(1, k)) ;params(k+1, 2) - radius(1, k) * sin(theta(1, k))];
end
pos = mean(pos, 1);

res1 = abs(interval-Interval);
res2 = res1/interval*100;
res3 = mean(abs(degree - original_degree));
res4 = mean(abs((degree - original_degree) ./ original_degree));
res5 = sqrt((pos(1)-posX)*(pos(1)-posX)+(pos(2)-posY)*(pos(2)-posY));
