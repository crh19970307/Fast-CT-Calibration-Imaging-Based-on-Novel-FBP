function [ output ] = max_n( input, n )
%MAX_4 找出矩阵前4个最大值，返回其位置
%   返回矩阵为1x4
    [value, index] = sort(input, 1, 'descend');
    output = index(1:n, :);
    output = sort(output, 1, 'ascend');
end

