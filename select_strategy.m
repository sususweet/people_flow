function [plaza, v, follow, has_exit, position_x_target, position_y_target] = select_strategy(plaza, v, follow, position_x, position_y, promote_strategy)
% 根据不同策略，选择下一步的移动方向
global sight_r;
conf = config();
[y_max, x_max]=size(plaza);
has_exit = 0;
people = plaza(position_y, position_x);
ori_v = v(position_y, position_x);
position_x_target = position_x;
position_y_target = position_y;
exit_x = conf.exit_xy(1);
exit_y = conf.exit_xy(2);
insight_arr = get_insight(plaza, v, position_x, position_y);

index = find(plaza ~= conf.TYPE_PEOPLE_EMPTY & plaza ~= conf.TYPE_BARRIAR & plaza ~= conf.TYPE_EXIT);
[index_i, ~]=ind2sub(size(plaza),index);
people_num = size(index_i,1);

% 熟悉环境行人的策略
if people == conf.TYPE_PEOPLE_FAMILIAR
    cost_mat = [];
    
    for i_k = -1:1
        for j_k = -1:1
            if i_k == 0 && j_k == 0
                continue;
            end
            
            position_x_tmp = position_x + i_k;
            position_y_tmp = position_y + j_k;
            
            people_insight = get_insight_by_direction(insight_arr, position_x_tmp, position_y_tmp);
            
            count_LU = size(people_insight.people_LU, 1);   % 左上角
            count_LD = size(people_insight.people_LD, 1);   % 左下角
            count_RU = size(people_insight.people_RU, 1);   % 右上角
            count_RD = size(people_insight.people_RD, 1);   % 右下角
            count_U = size(people_insight.people_U, 1); % 上面45°扇形区域
            count_D = size(people_insight.people_D, 1); % 下面45°扇形区域
            count_L = size(people_insight.people_L, 1); % 左面45°扇形区域
            count_R = size(people_insight.people_R, 1); % 右面45°扇形区域
            
            % 当前行人运动方向的左右90°扇形区间, 在此视野范围内, 影响该行人运动的干扰
            Nlr = 0;
            % 90°视野范围内的总人数
            Np = 0;
            switch v(position_y_tmp, position_x_tmp)
                case conf.MOVE_LEFTUP
                    for i = 1:count_L
                        insight_x = people_insight.people_L(i,1);
                        insight_y = people_insight.people_L(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                    for i = 1:count_U
                        insight_x = people_insight.people_U(i,1);
                        insight_y = people_insight.people_U(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    
                case conf.MOVE_LEFTDOWN
                    for i = 1:count_L
                        insight_x = people_insight.people_L(i,1);
                        insight_y = people_insight.people_L(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    for i = 1:count_D
                        insight_x = people_insight.people_D(i,1);
                        insight_y = people_insight.people_D(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                case conf.MOVE_RIGHTUP
                    for i = 1:count_R
                        insight_x = people_insight.people_R(i,1);
                        insight_y = people_insight.people_R(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    for i = 1:count_U
                        insight_x = people_insight.people_U(i,1);
                        insight_y = people_insight.people_U(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                case conf.MOVE_RIGHTDOWN
                    for i = 1:count_R
                        insight_x = people_insight.people_R(i,1);
                        insight_y = people_insight.people_R(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                    for i = 1:count_D
                        insight_x = people_insight.people_D(i,1);
                        insight_y = people_insight.people_D(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    
                case conf.MOVE_UP
                    for i = 1:count_LU
                        insight_x = people_insight.people_LU(i,1);
                        insight_y = people_insight.people_LU(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                    for i = 1:count_RU
                        insight_x = people_insight.people_RU(i,1);
                        insight_y = people_insight.people_RU(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                case conf.MOVE_DOWN
                    for i = 1:count_RD
                        insight_x = people_insight.people_RD(i,1);
                        insight_y = people_insight.people_RD(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                    for i = 1:count_LD
                        insight_x = people_insight.people_LD(i,1);
                        insight_y = people_insight.people_LD(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    
                case conf.MOVE_LEFT
                    for i = 1:count_LU
                        insight_x = people_insight.people_LU(i,1);
                        insight_y = people_insight.people_LU(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
                    for i = 1:count_LD
                        insight_x = people_insight.people_LD(i,1);
                        insight_y = people_insight.people_LD(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                case conf.MOVE_RIGHT
                    for i = 1:count_RU
                        insight_x = people_insight.people_RU(i,1);
                        insight_y = people_insight.people_RU(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_LEFT);
                    end
                    for i = 1:count_RD
                        insight_x = people_insight.people_RD(i,1);
                        insight_y = people_insight.people_RD(i,2);
                        Np = Np + 1;
                        Nlr = Nlr + is_move_conflict(v(position_y_tmp, position_x_tmp), v(insight_y, insight_x), conf.DIRECTION_RIGHT);
                    end
            end
            
            yita = Nlr / people_num;
            
            % 视野范围内的总人数
            Na = size(insight_arr, 1);
            % 视野半径为1 m 时, r = 3, 半径大于等于2 m 时, 认为r = 5
            if sight_r * conf.cell_size < 2.0
                r = 3;
            else
                r = 5;
            end
            p = Na / r^2;
            
            cost_value = 0.025 * yita ^ 2 + 0.075 * p ^ 2;
            fai_value = (abs(position_y_tmp - exit_y) + abs(position_x_tmp - exit_x)) * cost_value;
            
            cost_mat = [cost_mat; fai_value i_k j_k];
        end
    end
    cost_mat = sortrows(cost_mat, 1);
    for i = 1:size(cost_mat,1)
        move_x = cost_mat(i,2);
        move_y = cost_mat(i,3);
        if ~(move_x == 0 && move_y == 0)
            position_x_target = position_x + move_x;
            position_y_target = position_y + move_y;
            
            if plaza(position_y_target, position_x_target) == conf.TYPE_EXIT
                has_exit = 1;
                break;
            elseif plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                break;
            else
                position_x_target = position_x;
                position_y_target = position_y;
            end
        end
    end
    return;
end


% 静态场域策略 S0
exit_distance = sqrt((position_y - exit_y)^2+(position_x - exit_x)^2);
if exit_distance <= sight_r
    % 找到这个人周围8个邻域内距离出口最近的邻域，按照距离大小，选取没人的邻域进入
    [distance_mat] = get_distance_move(position_x, position_y, exit_x, exit_y);
    for i = 1:size(distance_mat,1)
        move_x = distance_mat(i,2);
        move_y = distance_mat(i,3);
        if ~(move_x == 0 && move_y == 0)
            position_x_target = position_x + move_x;
            position_y_target = position_y + move_y;
            
            if plaza(position_y_target, position_x_target) == conf.TYPE_EXIT
                has_exit = 1;
                break;
            elseif plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                break;
            else
                position_x_target = position_x;
                position_y_target = position_y;
            end
        end
    end
    return;
end

if promote_strategy == conf.TYPE_BARRIAR
    % 不熟悉环境行人的策略S1
    if people == conf.TYPE_PEOPLE_UNFAMILIAR_1 && size(insight_arr, 1) ~= 0 % 视野中有人
        follow_yx = follow{position_y, position_x};
        % 有跟随的人，判断是否还在视野范围内
        if size(follow_yx, 1) ~= 0
            follow_in_sight = 0;
            for i=1:size(insight_arr, 1)
                if isequal(follow_yx,  insight_arr(i,:))
                    follow_in_sight = 1;
                    break;
                end
            end
            
            % 如果跟随的人超出了视野范围，则脱离跟随
            if follow_in_sight == 0
                follow{position_y, position_x} = [];
            end
        end
        
        % 如果没有跟随的人了，从视野范围内等概率随机选一个人来跟随
        follow_yx = follow{position_y, position_x};
        if size(follow_yx, 1) == 0
            follow{position_y, position_x} = insight_arr(unidrnd(size(insight_arr, 1)), :);
            follow_yx = follow{position_y, position_x};
        end
        
        follow_y = follow_yx(1,1);
        follow_x = follow_yx(1,2);
        
        % 找到这个人周围8个邻域内距离目标点最短的邻域，按照距离大小，选取没人的邻域进入
        [distance_mat] = get_distance_move(position_x, position_y, follow_x, follow_y);
        for i = 1:size(distance_mat,1)
            move_x = distance_mat(i,2);
            move_y = distance_mat(i,3);
            if ~(move_x == 0 && move_y == 0)
                position_x_target = position_x + move_x;
                position_y_target = position_y + move_y;
                if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                    break;
                else
                    position_x_target = position_x;
                    position_y_target = position_y;
                end
            end
        end
        
        % 更新人员移动方向矩阵v
        if move_x == 0
            if move_y == -1
                v(position_y, position_x) = conf.MOVE_UP;
            elseif move_y == 0
                v(position_y, position_x) = conf.MOVE_STOP;
            elseif move_y == 1
                v(position_y, position_x) = conf.MOVE_DOWN;
            else
                error('Invalid move_y vector!');
            end
        elseif move_x == -1
            if move_y == -1
                v(position_y, position_x) = conf.MOVE_LEFTUP;
            elseif move_y == 0
                v(position_y, position_x) = conf.MOVE_LEFT;
            elseif move_y == 1
                v(position_y, position_x) = conf.MOVE_LEFTDOWN;
            else
                error('Invalid move_y vector!');
            end
        elseif move_x == 1
            if move_y == -1
                v(position_y, position_x) = conf.MOVE_RIGHTUP;
            elseif move_y == 0
                v(position_y, position_x) = conf.MOVE_RIGHT;
            elseif move_y == 1
                v(position_y, position_x) = conf.MOVE_RIGHTDOWN;
            else
                error('Invalid move_y vector!');
            end
        else
            error('Invalid move_x vector!');
        end
    end
    
    % 不熟悉环境行人的策略S2
    if people == conf.TYPE_PEOPLE_UNFAMILIAR_2 && size(insight_arr, 1) ~= 0
        people_insight = get_insight_by_direction(insight_arr, position_x, position_y);
        
        count_LU = size(people_insight.people_LU, 1);   % 左上角
        count_LD = size(people_insight.people_LD, 1);   % 左下角
        count_RU = size(people_insight.people_RU, 1);   % 右上角
        count_RD = size(people_insight.people_RD, 1);   % 右下角
        count_U = size(people_insight.people_U, 1); % 上面45°扇形区域
        count_D = size(people_insight.people_D, 1); % 下面45°扇形区域
        count_L = size(people_insight.people_L, 1); % 左面45°扇形区域
        count_R = size(people_insight.people_R, 1); % 右面45°扇形区域
        
        dense_mat = [count_LU conf.MOVE_LEFTUP;
            count_LD conf.MOVE_LEFTDOWN; count_RU conf.MOVE_RIGHTUP;count_RD conf.MOVE_RIGHTDOWN;
            count_U conf.MOVE_UP; count_D conf.MOVE_DOWN;count_L conf.MOVE_LEFT;count_R conf.MOVE_RIGHT];
        dense_mat = sortrows(dense_mat, 1);
        
        move_action = conf.MOVE_STOP;
        % 这里逆序遍历，因为是要找人流最大的地方移动
        for i = size(dense_mat,1):-1:1
            move_action = dense_mat(i,2);
            [~, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
            if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                break;
            else
                move_action = conf.MOVE_STOP;
            end
        end
        
        % [count_max, index] = max([count_LU count_LD count_RU count_RD count_U count_D count_L count_R]);
        
        [v, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
    end
    
    % 不熟悉环境行人的策略S3
    if people == conf.TYPE_PEOPLE_UNFAMILIAR_3 && size(insight_arr, 1) ~= 0
        count_LU = 0;   % 左上角
        count_LD = 0;   % 左下角
        count_RU = 0;   % 右上角
        count_RD = 0;   % 右下角
        count_U = 0;    % 上面45°扇形区域
        count_D = 0;    % 下面45°扇形区域
        count_L = 0;    % 左面45°扇形区域
        count_R = 0;    % 右面45°扇形区域
        for i=1:size(insight_arr, 1)
            insight_y = insight_arr(i,1);
            insight_x = insight_arr(i,2);
            switch v(insight_y, insight_x)
                case conf.MOVE_LEFTUP
                    count_LU = count_LU + 1;
                case conf.MOVE_LEFTDOWN
                    count_LD = count_LD + 1;
                case conf.MOVE_RIGHTUP
                    count_RU = count_RU + 1;
                case conf.MOVE_RIGHTDOWN
                    count_RD = count_RD + 1;
                case conf.MOVE_UP
                    count_U = count_U + 1;
                case conf.MOVE_DOWN
                    count_D = count_D + 1;
                case conf.MOVE_LEFT
                    count_L = count_L + 1;
                case conf.MOVE_RIGHT
                    count_R = count_R + 1;
            end
        end
        
        dense_mat = [count_LU conf.MOVE_LEFTUP;
            count_LD conf.MOVE_LEFTDOWN; count_RU conf.MOVE_RIGHTUP;count_RD conf.MOVE_RIGHTDOWN;
            count_U conf.MOVE_UP; count_D conf.MOVE_DOWN;count_L conf.MOVE_LEFT;count_R conf.MOVE_RIGHT];
        dense_mat = sortrows(dense_mat, 1);
        
        move_action = conf.MOVE_STOP;
        % 这里逆序遍历，因为是要找人流最大的地方移动
        for i = size(dense_mat,1):-1:1
            move_action = dense_mat(i,2);
            [~, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
            if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                break;
            else
                move_action = conf.MOVE_STOP;
            end
        end
        
        % [count_max, index] = max([count_LU count_LD count_RU count_RD count_U count_D count_L count_R]);
        
        [v, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
        
        if position_x_target <= 1 || position_y_target <= 1
            xxxxx = 10;
        end
    end
end

% 不熟悉环境行人的策略S4，当采用S1、S2、S3策略的人视野范围内没人时，也采用此策略
if people == conf.TYPE_PEOPLE_UNFAMILIAR_4 || promote_strategy == conf.TYPE_PEOPLE_UNFAMILIAR_4 ...
        || (people == conf.TYPE_PEOPLE_UNFAMILIAR_1 && size(insight_arr, 1) == 0) ...
        || (people == conf.TYPE_PEOPLE_UNFAMILIAR_2 && size(insight_arr, 1) == 0) ...
        || (people == conf.TYPE_PEOPLE_UNFAMILIAR_3 && size(insight_arr, 1) == 0)	% 视野中没有人
    has_blocked = 0;
    while 1
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
                    if rand<=0.5
                        v(position_y, position_x) = conf.MOVE_LEFT;
                    else
                        v(position_y, position_x) = conf.MOVE_RIGHT;
                    end
                end
                if j == 0 && (ori_v == conf.MOVE_LEFT || ori_v == conf.MOVE_RIGHT)
                    if rand<=0.5
                        v(position_y, position_x) = conf.MOVE_UP;
                    else
                        v(position_y, position_x) = conf.MOVE_DOWN;
                    end
                end
            elseif size(barrier_arr,1) == 2 % 在四个角落
                barrier_arr_sum = sum(barrier_arr);
                i = barrier_arr_sum(1,1);
                j = barrier_arr_sum(1,2);
                % 到墙角后，绕着墙向出口走
                if i == -1 && j == -1   %左上角
                    v(position_y, position_x) = conf.MOVE_DOWN;
                elseif i == 1 && j == -1   %右上角
                    v(position_y, position_x) = conf.MOVE_LEFT;
                elseif i == -1 && j == 1   %左下角
                    v(position_y, position_x) = conf.MOVE_UP;
                elseif i == 1 && j == 1   %右下角
                    v(position_y, position_x) = conf.MOVE_LEFT;
                end
            end
        end
        if has_blocked >= 1
            % v(position_y, position_x) = unidrnd(conf.MOVE_RIGHTDOWN);
            v(position_y, position_x) = unidrnd(conf.MOVE_DOWN);
        end
        ori_v = v(position_y, position_x);
        [v_tmp, position_x_target, position_y_target] = proceed_move(ori_v, v, position_x, position_y);
        if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
            v=v_tmp;
            break;
        elseif has_blocked > 7
            position_y_target = position_y;
            position_x_target = position_x;
            break;
        else
            position_x_target = position_x;
            position_y_target = position_y;
            has_blocked = has_blocked + 1;
        end
    end
end
end

