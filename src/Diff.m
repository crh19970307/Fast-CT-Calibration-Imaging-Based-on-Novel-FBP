function [ output ] = Diff( input, relu )
%DIFF 对矩阵作一次差分处理
%   对矩阵的每个元素，都减去它的前一个元素。
    slide = [zeros(1, 180); input(1 : 511, :)];
    output = input - slide;
    if relu
        output = max(output, 0);
    end
end

