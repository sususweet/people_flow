function [ i_min, j_min ] = get_mindistance_move(current_x, current_y, target_x, target_y)
%GET_MINDISTANCE_MOVE 找到八个邻域内离目标坐标点距离最短的移动方法
    distance_min = inf;
    i_min = 0;
    j_min = 0;
    for i = -1:1
        for j = -1:1
            distance = sqrt((current_x + i - target_x)^2 + (current_y + j - target_y)^2);
            if distance < distance_min
                distance_min = distance;
                i_min = i;
                j_min = j;
            end
        end
    end
end

