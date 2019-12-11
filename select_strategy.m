function [plaza, v, follow, position_x_target, position_y_target] = select_strategy(plaza, v, follow, position_x, position_y)
% ���ݲ�ͬ���ԣ�ѡ����һ�����ƶ�����
conf = config();
[L,W]=size(plaza);
people = plaza(position_y, position_x);
ori_v = v(position_y, position_x);
position_x_target = position_x;
position_y_target = position_y;

insight_arr = get_insight(plaza, v, position_x, position_y);

% ����Ϥ�������˵Ĳ���S1
if people == conf.TYPE_PEOPLE_UNFAMILIAR_1 && size(insight_arr, 1) ~= 0 % ��Ұ������
    follow_yx = follow{position_y, position_x};
    % �и�����ˣ��ж��Ƿ�����Ұ��Χ��
    if size(follow_yx, 1) ~= 0
        follow_in_sight = 0;
        for i=1:size(insight_arr, 1)
            if isequal(follow_yx,  insight_arr(i,:))
                follow_in_sight = 1;
                break;
            end
        end
        
        % ���������˳�������Ұ��Χ�����������
        if follow_in_sight == 0
            follow{position_y, position_x} = [];
        end
    end
    
    % ���û�и�������ˣ�����Ұ��Χ�ڵȸ������ѡһ����������
    follow_yx = follow{position_y, position_x};
    if size(follow_yx, 1) == 0
        follow{position_y, position_x} = insight_arr(unidrnd(size(insight_arr, 1)), :);
        follow_yx = follow{position_y, position_x};
    end
    
    follow_y = follow_yx(1,1);
    follow_x = follow_yx(1,2);
    
    % �ҵ��������Χ8�������ھ���Ŀ�����̵����򣬰��վ����С��ѡȡû�˵��������
    [distance_mat] = get_distance_move(position_x, position_y, follow_x, follow_y);
    for i = 1:size(distance_mat,1)
        move_x = distance_mat(i,2);
        move_y = distance_mat(i,3);
        if ~(move_x == 0 && move_y == 0)
            position_x_target = position_x + move_x;
            position_y_target = position_y + move_y;
            if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
                break;
            end
        end
    end
    
    % ������Ա�ƶ��������v
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

% ����Ϥ�������˵Ĳ���S2
if people == conf.TYPE_PEOPLE_UNFAMILIAR_2 && size(insight_arr, 1) ~= 0
    count_LU = 0;   % ���Ͻ�
    count_LD = 0;   % ���½�
    count_RU = 0;   % ���Ͻ�
    count_RD = 0;   % ���½�
    count_U = 0;    % ����45����������
    count_D = 0;    % ����45����������
    count_L = 0;    % ����45����������
    count_R = 0;    % ����45����������
    for i=1:size(insight_arr, 1)
        insight_y = insight_arr(i,1);
        insight_x = insight_arr(i,2);
        diff_y = abs(insight_y - position_y);
        diff_x = abs(insight_x - position_x);
        % �������¡����¡����ϡ������ĸ����������ڵ���Ա��Ŀ�������߽�
        if insight_y >= position_y
            if insight_x >= position_x
                count_RD = count_RD + 1;
                if diff_x >= diff_y
                    count_R = count_R + 1;
                end
                if diff_x <= diff_y
                    count_D = count_D + 1;
                end
            end
            if insight_x <= position_x
                count_LD = count_LD + 1;
                if diff_x >= diff_y
                    count_L = count_L + 1;
                end
                if diff_x <= diff_y
                    count_D = count_D + 1;
                end
            end
        end
        if insight_y <= position_y
            if insight_x >= position_x
                count_RU = count_RU + 1;
                if diff_x >= diff_y
                    count_R = count_R + 1;
                end
                if diff_x <= diff_y
                    count_U = count_U + 1;
                end
            end
            if insight_x <= position_x
                count_LU = count_LU + 1;
                if diff_x >= diff_y
                    count_L = count_L + 1;
                end
                if diff_x <= diff_y
                    count_U = count_U + 1;
                end
            end
        end
    end
    
    dense_mat = [count_LU conf.MOVE_LEFTUP;
        count_LD conf.MOVE_LEFTDOWN; count_RU conf.MOVE_RIGHTUP;count_RD conf.MOVE_RIGHTDOWN;
        count_U conf.MOVE_UP; count_D conf.MOVE_DOWN;count_L conf.MOVE_LEFT;count_R conf.MOVE_RIGHT];
    dense_mat = sortrows(dense_mat, 1);
    
    move_action = conf.MOVE_STOP;
    % ���������������Ϊ��Ҫ���������ĵط��ƶ�
    for i = size(dense_mat,1):-1:1
        move_action = dense_mat(i,2);
        [~, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
        if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
            break;
        end
    end
    
    % [count_max, index] = max([count_LU count_LD count_RU count_RD count_U count_D count_L count_R]);
    
    if move_action ~= conf.MOVE_STOP
        [v, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
    end
end

% ����Ϥ�������˵Ĳ���S3
if people == conf.TYPE_PEOPLE_UNFAMILIAR_3 && size(insight_arr, 1) ~= 0
    count_LU = 0;   % ���Ͻ�
    count_LD = 0;   % ���½�
    count_RU = 0;   % ���Ͻ�
    count_RD = 0;   % ���½�
    count_U = 0;    % ����45����������
    count_D = 0;    % ����45����������
    count_L = 0;    % ����45����������
    count_R = 0;    % ����45����������
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
    % ���������������Ϊ��Ҫ���������ĵط��ƶ�
    for i = size(dense_mat,1):-1:1
        move_action = dense_mat(i,2);
        [~, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
        if plaza(position_y_target, position_x_target) == conf.TYPE_PEOPLE_EMPTY
            break;
        end
    end
    
    % [count_max, index] = max([count_LU count_LD count_RU count_RD count_U count_D count_L count_R]);
    
    if move_action ~= conf.MOVE_STOP
        [v, position_x_target, position_y_target] = proceed_move(move_action, v, position_x, position_y);
    end
end

% ����Ϥ�������˵Ĳ���S4��������S1��S2��S3���Ե�����Ұ��Χ��û��ʱ��Ҳ���ô˲���
if people == conf.TYPE_PEOPLE_UNFAMILIAR_4 || (people == conf.TYPE_PEOPLE_UNFAMILIAR_1 && size(insight_arr, 1) == 0) ...
        || (people == conf.TYPE_PEOPLE_UNFAMILIAR_2 && size(insight_arr, 1) == 0) ...
        || (people == conf.TYPE_PEOPLE_UNFAMILIAR_3 && size(insight_arr, 1) == 0)	% ��Ұ��û����
    has_blocked = 0;
    while 1
        near_barrier = 0;
        i=0;
        j=0;
        barrier_arr = [];
        
        % �ж��ϰ���
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
        % �ж��ϰ������
        
        % ����������ϰ�������Լ����ٶ�ʸ��
        % ����ǽ�߼ᶨ�Լ�ԭ�����ƶ�����
        if near_barrier == 1    % ��ǽ�ߣ�����ǽ��
            if size(barrier_arr,1) == 1 % ��ǽ�ߣ��������ĸ�����
                % i, jΪ�ϰ����ƫ��λ��
                i = barrier_arr(1,1);
                j = barrier_arr(1,2);
                
                % ����ǵ�һ������ǽ�ڣ�������Լ����ٶ�ʸ��
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
            elseif size(barrier_arr,1) == 2 % ���ĸ�����
                barrier_arr_sum = sum(barrier_arr);
                i = barrier_arr_sum(1,1);
                j = barrier_arr_sum(1,2);
                % ��ǽ�Ǻ�����ǽ��ʱ����
                if i == -1 && j == -1   %���Ͻ�
                    v(position_y, position_x) = conf.MOVE_DOWN;
                elseif i == 1 && j == -1   %���Ͻ�
                    v(position_y, position_x) = conf.MOVE_LEFT;
                elseif i == -1 && j == 1   %���½�
                    v(position_y, position_x) = conf.MOVE_RIGHT;
                elseif i == 1 && j == 1   %���½�
                    v(position_y, position_x) = conf.MOVE_UP;
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
        elseif has_blocked>7
            position_y_target = position_y;
            position_x_target = position_x;
            break;
        else
            has_blocked = has_blocked + 1;
        end
    end
end
end

