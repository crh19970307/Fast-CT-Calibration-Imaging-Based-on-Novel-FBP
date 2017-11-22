function [ output ] = cross_circle( sensor_id, angle )
%CROSS_CIRCLE 第 sensor_id 个探测器对应的 X射线 以 angle 角度 在圆中 经过的距离
	sensor_pos = [39.1272 56.3769] + (sensor_id - 256.6706) * [sin(angle) -cos(angle)] * 0.2844;
    distance = abs((sensor_pos - [95 50]) * [sin(angle); -cos(angle)]);
    if distance >= 4
        output = 0;
    else
        output = 2 * sqrt(16 - distance * distance);
    end
end

