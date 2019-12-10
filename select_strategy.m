function [plaza, v, position_x_target, position_y_target] = select_strategy(plaza, v, position_x, position_y)
% 根据不同策略，选择下一步的移动方向
conf = config();
[L,W]=size(plaza);
people = plaza(position_y, position_x);
ori_v = v(position_y, position_x);
position_x_target = position_x;
position_y_target = position_y;
switch people
    case conf.TYPE_PEOPLE_UNFAMILIAR_1
    case conf.TYPE_PEOPLE_UNFAMILIAR_2
        
    case conf.TYPE_PEOPLE_UNFAMILIAR_3
    case conf.TYPE_PEOPLE_UNFAMILIAR_4
        % 不熟悉环境行人的策略S4
        near_barrier = 0;
        i=0;
        j=0;
        barrier_arr = [];
        % 判断障碍物
        for i = -1:1
            j = 0;
            y_tmp = position_y;
            x_tmp = position_x + i;
            if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                near_barrier = 1;
                barrier_arr = [barrier_arr; i j];
            end
        end
        for j = -1:1
            i = 0;
            y_tmp = position_y + j;
            x_tmp = position_x;
            if plaza(y_tmp, x_tmp) == conf.TYPE_BARRIAR
                near_barrier = 1;
                barrier_arr = [barrier_arr; i j];
            end
        end
        % 判断障碍物结束
        
        % 如果遇到了障碍物，更改自己的速度矢量
        % 不在墙边坚定自己原来的移动方向
        if near_barrier == 1    % 在墙边，沿着墙走
            if size(barrier_arr,1) == 1 % 在墙边，但不在四个角落
                % i, j为障碍物的偏移位置
                i = barrier_arr(1,1);
                j = barrier_arr(1,2);
                
                % 如果是第一次碰到墙壁，则更改自己的速度矢量
                if i == 0 && (ori_v == conf.MOVE_UP || ori_v == conf.MOVE_DOWN)
                    if rand<=1
                        v(position_y, position_x) = conf.MOVE_LEFT;
                    else
                        v(position_y, position_x) = conf.MOVE_RIGHT;
                    end
                end
                if j == 0 && (ori_v == conf.MOVE_LEFT || ori_v == conf.MOVE_RIGHT)
                    if rand<=1
                        v(position_y, position_x) = conf.MOVE_UP;
                    else
                        v(position_y, position_x) = conf.MOVE_DOWN;
                    end
                end 
            elseif size(barrier_arr,1) == 2 % 在四个角落
                barrier_arr_sum = sum(barrier_arr);
                i = barrier_arr_sum(1,1);
                j = barrier_arr_sum(1,2);
                % 到墙角后，绕着墙逆时针走
                if i == -1 && j == -1   %左上角
                    v(position_y, position_x) = conf.MOVE_DOWN;
                elseif i == 1 && j == -1   %右上角
                    v(position_y, position_x) = conf.MOVE_LEFT;
                elseif i == -1 && j == 1   %左下角
                    v(position_y, position_x) = conf.MOVE_RIGHT;
                elseif i == 1 && j == 1   %右下角
                    v(position_y, position_x) = conf.MOVE_UP;
                end
            end
        end
        ori_v = v(position_y, position_x);
        switch ori_v
            case conf.MOVE_LEFT
                position_x_target = position_x - 1;
            case conf.MOVE_RIGHT
                position_x_target = position_x + 1;
            case conf.MOVE_UP
                position_y_target = position_y - 1;
            case conf.MOVE_DOWN
                position_y_target = position_y + 1;
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

