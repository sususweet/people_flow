function [plaza, position_x_target, position_y_target] = select_strategy(plaza, position_x, position_y)
% 根据不同策略，选择下一步的移动方向
conf = config();
[L,W]=size(plaza);
people = plaza(position_y, position_x);
position_x_target = position_x;
position_y_target = position_y;
switch people
    case conf.TYPE_PEOPLE_UNFAMILIAR_1
    case conf.TYPE_PEOPLE_UNFAMILIAR_2
        
    case conf.TYPE_PEOPLE_UNFAMILIAR_3
    case conf.TYPE_PEOPLE_UNFAMILIAR_4
        near_barrier = 0;
        i=0;
        j=0;
        % 判断障碍物
        if near_barrier == 0
            for i = -1:1
                y_tmp = position_y + i;
                x_tmp = position_x + i;
                if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                    near_barrier = 1;
                    break
                end
            end
        end
        if near_barrier == 0
            for i = -1:1
                y_tmp = position_y - i;
                x_tmp = position_x + i;
                if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                    near_barrier = 1;
                    break
                end
            end
        end
        if near_barrier == 0
            for i = -1:1
                y_tmp = position_y;
                x_tmp = position_x + i;
                if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                    near_barrier = 1;
                    break
                end
            end
        end
        if near_barrier == 0
            for j = -1:1
                y_tmp = position_y + j;
                x_tmp = position_x;
                if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                    near_barrier = 1;
                    break
                end
            end
        end
        % 判断障碍物结束
        
        if near_barrier == 1    % 在墙边，沿着墙走
            if i~=0 && j~=0
                if rand <= 1
                    position_x_target = position_x-i;
                else
                    position_y_target = position_y-j;
                end
            elseif i == 0
                position_y_target = position_y;
                if rand <= 1
                    position_x_target = position_x+1;
                else
                    position_x_target = position_x-1;
                end
            elseif j == 0
                position_x_target = position_x;
                if rand <= 1
                    position_y_target = position_y+1;
                else
                    position_y_target = position_y-1;
                end
            end
        else
            position_x_target = position_x + 1;     % 坚定自己的移动方向，一直朝右走
        end
    case conf.TYPE_PEOPLE_FAMILIAR
        
    otherwise
        error('People Type not Supported!');
end
if plaza(position_y_target, position_x_target) ~= conf.TYPE_PEOPLE_EMPTY
    position_x_target = position_x;
    position_y_target = position_y;
end
end

