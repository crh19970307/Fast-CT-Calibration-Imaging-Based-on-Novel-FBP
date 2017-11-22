function [ output ] = preprocess( input, n )
%PREPROCESS 对抽取出的边界坐标进行预处理
%   输出矩阵每一列包括：[椭圆投影起始坐标, 椭圆投影结束坐标, 圆投影起始坐标, 圆投影结束坐标]
%   每次根据前2列结果对下一列坐标进行预测，并根据预测结果重新排列（需要时补正）下一列坐标
%   本算法将初始2列数据的排列作为ground truth，自动排列所有后续数据
output = input;
target = zeros(n, 1); % 存储预测位置
for i = 3:180
    % 使用（局部）线性插值预测下一个坐标
    for j = 1:n
        target(j, 1) = 2 * output(j, i-1) -  output(j, i-2);
    end
    vacancy = length(find(input(:, i) == 1));
    res = zeros(n, 1); % 存储对实际位置的排列结果
    occupy = zeros(n, 1); % 用于对候选坐标进行分配
    if vacancy > 0 % 存在空坐标，说明有坐标重合了
        for j = vacancy + 1 : n
            current = 0;
            dist = inf;
            for k = 1:n
                if occupy(k, 1) == 0 && abs(input(j, i) - target(k, 1)) < dist
                    dist = abs(input(j, i) - target(k, 1));
                    current = k;
                end
            end
            occupy(current, 1) = 1;
            res(current, 1) = input(j, i);
        end
        [x, y] = find(occupy == 0);
        current = vacancy+1;
        for j = vacancy+2:n
            if abs(input(j, i) - target(x, 1)) < abs(input(current, i) - target(x, 1))
                current = j;
            end
        end
        res(x, 1) = input(current, i);
    else % 直接根据预测坐标大小顺序，排列实际坐标
        [value, index] = sort(target, 1, 'ascend');
        res(index, 1) = input(:, i);
    end
    output(:, i) = res;

end

