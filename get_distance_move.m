function [distance_mat] = get_distance_move(current_x, current_y, target_x, target_y)
%GET_DISTANCE_MOVE 找到八个邻域内离目标坐标点的距离，并排序
    distance_mat = [];
    % distance_min = inf;
    % i_min = 0;
    % j_min = 0;
    for i = -1:1
        for j = -1:1
            distance = sqrt((current_x + i - target_x)^2 + (current_y + j - target_y)^2);
            distance_mat = [distance_mat; distance i j];
            % if distance < distance_min
            %     distance_min = distance;
            %     i_min = i;
            %     j_min = j;
            % end
        end
    end
    distance_mat = sortrows(distance_mat, 1);
end

