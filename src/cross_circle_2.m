function [ output ] = cross_circle( sensor_id, angle, posX, posY, centerX, centerY, zero, interval, radius )
%CROSS_CIRCLE 第 sensor_id 个探测器对应的 X射线 以 angle 角度 在圆中 经过的距离
    angle = angle + pi;
	sensor_pos = [centerX centerY] + (sensor_id - zero) * [sin(angle) -cos(angle)] * interval;
    distance = abs((sensor_pos - [posX posY]) * [sin(angle); -cos(angle)]);
    if distance >= radius
        output = 0;
    else
        output = 2 * sqrt(radius * radius - distance * distance);
    end
end

