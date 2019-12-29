function [people_cell,room_map] = go_forward(n,room_map,people_cell,des_row,des_column,tmax)
    [l,w] = size(room_map);  % l,w为包括墙壁的房间尺寸
    des_num = size(des_row,2); % 终点的格子数
    c_row = des_row(ceil(size(des_row,2)/2));  % 终点中心的行坐标
%     MOVE_STOP = 0;
%     MOVE_LEFT = 1;
%     MOVE_RIGHT = 2;
%     MOVE_UP = 3;
%     MOVE_DOWN = 4;
%     MOVE_LEFTUP = 5;
%     MOVE_RIGHTUP = 6;
%     MOVE_LEFTDOWN = 7;
%     MOVE_RIGHTDOWN = 8;
    %% 判断人员是否已经在终点
    if people_cell{n}.des == 1
        people_cell{n}.still_in_room = 0;
        room_map(people_cell{n}.row , people_cell{n}.column) = 8;   % 该人员从终点离开
        return;
    end
    %% 根据策略作出下一步
    switch people_cell{n}.strategy
       %% 策略S1
        case 1 % 策略S1
            people_cell{n}.direction_fore = people_cell{n}.direction_next;  % 更新上一步的方向
            if ~isempty(people_cell{n}.insight)     % 逻辑1表示该人员的视野范围内至少存在一个其他人员
                % 先决定要跟随的人员
                if ismember(people_cell{n}.follow , people_cell{n}.insight) % 逻辑1表示之前的被跟随人员仍然在视野范围内
                    people_cell{n}.follow = people_cell{n}.follow;
                else
                    in_num = size(people_cell{n}.insight,2);    % in_num表示该人员视野范围内的其他人员数目
                    people_cell{n}.follow = people_cell{n}.insight(randi(in_num)); % 随机选择要跟随的人员
                end
                f = people_cell{n}.follow;  % f为所要跟随人员的序号
                % 计算周围8个格子到所要跟随人员的距离排序
                tof_distance = zeros(1,8);
                tof_distance = todes_distance(tof_distance,people_cell{n},people_cell{f}.row,people_cell{f}.column,1);
                [~,direction_next] = sort(tof_distance);
                for i = 1:8
                    people_cell{n}.direction_tend = direction_next(i);% 选择当前想要走的方向
                    % 判断下个元胞是否原来有人或者是不是墙壁等
                    if cell_free(room_map,people_cell{n})
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break;
                    elseif i == 8  % 周围8个格子都不能走的情况
                        people_cell{n}.direction_next = 0;
                    end
                end
            else  % 视野内没有人的情况
                people_cell{n}.follow = 0;
                people_cell{n}.direction_next = 0;
            end
            people_cell{n} = move_direction(people_cell{n}); % 人员发生实际行动
            people_cell{n}.insight = [];  % 视野清零
            % 如果该人员原地等待时间超过上限，则改变策略为S4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end                   
       %% 策略S2
        case 2  % 策略S2
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% 更新上一步的方向
            people_cell{n} = s2_direction(n,people_cell{n},people_cell,room_map); 
            people_cell{n} = move_direction(people_cell{n});
            people_cell{n}.insight = [];  % 视野清零 
            % 如果该人员原地等待时间超过上限，则改变策略为S4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end  
       %% 策略S3
        case 3  % 策略S3
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% 更新上一步的方向
            people_cell{n} = s3_direction(n,people_cell{n},people_cell,room_map);
            people_cell{n} = move_direction(people_cell{n});
            people_cell{n}.insight = [];  % 视野清零
            % 如果该人员原地等待时间超过上限，则改变策略为S4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end   
       %% 策略S4
        case 4  % 策略S4
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% 更新上一步的方向
            people_cell{n} = is_wall(room_map,people_cell{n},l,w);   % 决定该人员的下一步方向
            people_cell{n} = move_direction(people_cell{n});
            % 如果等待时间超过上限，随机换个方向走
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.direction_tend = randi(8);
                people_cell{n}.clock = randi([0,1]);
            end  
            % people_cell{n}.insight = [];  % 视野清零
       %% 熟悉环境策略
        case 5  % 熟悉环境策略
            people_cell{n}.direction_fore = people_cell{n}.direction_next;   % 更新上一步的方向
            distance_or = pdist([people_cell{n}.row, people_cell{n}.column ; c_row, des_column],'euclidean'); % 计算原地到终点中心的距离
            distance = zeros(1,des_num*8);   % 该人员元胞周围8个格到几个终点的距离数组
            distance = todes_distance(distance,people_cell{n},des_row,des_column,des_num);  % 计算人员周围8个元胞到终点(des_row,des_column)的距离
            [~,direction_next] = sort(distance);   % 到终点的距离按从小到大排序的周围网格的序号
            for i = 1:8*des_num
                if distance(direction_next(i)) <= distance_or  % 行动后到终点的距离要比原地不动到终点中心的距离更短
                    if mod(direction_next(i),8) ~= 0
                        people_cell{n}.direction_tend = mod(direction_next(i),8);% 选择当前想要走的方向
                    else
                        people_cell{n}.direction_tend = 8;
                    end
                    % 判断要走的下一个元胞是否能走
                    if cell_free(room_map,people_cell{n})
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break
                    elseif i == 8*des_num  % 周围都不能走的情况
                        people_cell{n}.direction_next = 0;
                    end
                else
                     people_cell{n}.direction_next = 0;
                end
            end
            people_cell{n} = move_direction(people_cell{n}); % 人员发生实际行动
            people_cell{n}.insight = [];  % 视野清零
       %% 策略S0
        case 6  % 策略S0
            people_cell{n}.direction_fore = people_cell{n}.direction_next;   % 更新上一步的方向
            distance_or = pdist([people_cell{n}.row, people_cell{n}.column ; c_row, des_column],'euclidean'); % 计算原地到终点中心的距离
            distance = zeros(1,des_num*8);   % 该人员元胞周围8个格到几个终点的距离数组
            distance = todes_distance(distance,people_cell{n},des_row,des_column,des_num);  % 计算人员周围8个元胞到终点(des_row,des_column)的距离
            [~,direction_next] = sort(distance);   % 到终点的距离按从小到大排序的周围网格的序号
            for i = 1:8*des_num
                if distance(direction_next(i)) <= distance_or  % 行动后到终点的距离要比原地不动到终点中心的距离更短
                    if mod(direction_next(i),8) ~= 0
                        people_cell{n}.direction_tend = mod(direction_next(i),8);% 选择当前想要走的方向
                    else
                        people_cell{n}.direction_tend = 8;
                    end
                    % 判断要走的下一个元胞是否能走,同时不能走出可见出口范围
                    temp4 = people_cell{n};
                    temp4.direction_next = temp4.direction_tend;
                    temp4 = move_direction(temp4);
                    if ismember(room_map(temp4.row,temp4.column),[7,8])
                        % 要走的下一个元胞处于可见出口范围或终点
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break;
                    elseif i == 8*des_num  % 周围都不能走的情况
                        people_cell{n}.direction_next = 0;
                    end
                else
                     people_cell{n}.direction_next = 0;
                     break;
                end
            end
            people_cell{n} = move_direction(people_cell{n}); % 人员发生实际行动
            % people_cell{n}.insight = [];  % 视野清零
        %%
    end
    
    %% 策略S2的方向判断函数，判断视野范围内8个区域中人员最多的区域作为下一步方向
    function  people = s2_direction(n,people,people_cell,room_map)
        nq = zeros(1,8);
        if ~isempty(people.insight) % 逻辑1表示该人员的视野范围内至少存在一个其他人员
            % nq(i)表示i行动方向上的其他人员数
            nq(1) = size(people_cell{n}.insight_8d{1},2) + size(people_cell{n}.insight_8d{8},2);
            nq(2) = size(people_cell{n}.insight_8d{4},2) + size(people_cell{n}.insight_8d{5},2);
            nq(3) = size(people_cell{n}.insight_8d{2},2) + size(people_cell{n}.insight_8d{3},2);
            nq(4) = size(people_cell{n}.insight_8d{6},2) + size(people_cell{n}.insight_8d{7},2);
            nq(5) = size(people_cell{n}.insight_8d{1},2) + size(people_cell{n}.insight_8d{2},2);
            nq(6) = size(people_cell{n}.insight_8d{3},2) + size(people_cell{n}.insight_8d{4},2);
            nq(7) = size(people_cell{n}.insight_8d{7},2) + size(people_cell{n}.insight_8d{8},2);
            nq(8) = size(people_cell{n}.insight_8d{5},2) + size(people_cell{n}.insight_8d{6},2);
            % 排序，选择方向
            [~,maxh] = sort(nq,'descend');
            people.direction_tend = maxh(1);
            % 判断下一个元胞能不能走
            temp = people;
            temp.direction_next = temp.direction_tend;
            temp = move_direction(temp);
            nextcell_value = room_map(temp.row,temp.column);
            if ismember(nextcell_value , [0,7,8])
                people.direction_next = people.direction_tend;
            else
                people.direction_next = 0;
            end
        else  % 视野内没有人的情况
            people.direction_tend = 0;
            people.direction_next = 0;
        end
    end

    %% 策略S3的方向判断函数，判断视野范围内的人员上一步的行动最多的方向
    function  people = s3_direction(n,people,people_cell,room_map)
        h = zeros(1,9);  % h(9)表示0，原地不动，h中每个元素表示上一步中对应方向上的移动人数
        if ~isempty(people.insight)     % 逻辑1表示该人员的视野范围内至少存在一个其他人员
            sight_num = size(people.insight,2);  % sight_num表示该人员视野范围内的其他人员数目
            for k = 1:sight_num
                if people.insight(k) < n  % 如果视野内的people.insight(k)人员的序号小于该人员的序号n,表明people.insight(k)人员在当前步已经行动过
                    % ne为0~8，表示视野内的people.insight(k)人员上一步的实际行动
                    ne = people_cell{people.insight(k)}.direction_fore;
                else
                    ne = people_cell{people.insight(k)}.direction_next;
                end
                % h数组相应加1
                if ne ~= 0
                    h(ne) = h(ne) + 1;
                else
                    h(9) = h(9) + 1;
                end
            end
            % 排序,得到上一步中大多数行人的移动方向maxh(1)
            [~,maxh] = sort(h,'descend');
            if maxh(1) ~= 9 
                people.direction_tend = maxh(1);
                % 判断要走的下一个元胞是否能走
                temp = people;
                temp.direction_next = temp.direction_tend;
                temp = move_direction(temp);
                nextcell_value = room_map(temp.row,temp.column);
                if ismember(nextcell_value , [0,7,8])
                    people.direction_next = people.direction_tend;
                else
                    people.direction_next = 0;
                end
            else % 上一步中大多数行人原地不动的情况
                people.direction_tend = 0;
                people.direction_next = 0;
            end
        else  % 视野内没有人的情况
            people.direction_tend = 0;
            people.direction_next = 0;
        end
    end

    %% 计算人员周围8个元胞到终点(des_row,des_column)的距离
    function distance = todes_distance(distance,people,des_row,des_column,des_num)
        r = people.row;
        c = people.column;
        for j = 1:des_num
            distance((j-1)*8+1) = pdist([r,c-1;des_row(j),des_column],'euclidean');
            distance((j-1)*8+2) = pdist([r,c+1;des_row(j),des_column],'euclidean');
            distance((j-1)*8+3) = pdist([r-1,c;des_row(j),des_column],'euclidean');
            distance((j-1)*8+4) = pdist([r+1,c;des_row(j),des_column],'euclidean');
            distance((j-1)*8+5) = pdist([r-1,c-1;des_row(j),des_column],'euclidean');
            distance((j-1)*8+6) = pdist([r-1,c+1;des_row(j),des_column],'euclidean');
            distance((j-1)*8+7) = pdist([r+1,c-1;des_row(j),des_column],'euclidean');
            distance((j-1)*8+8) = pdist([r+1,c+1;des_row(j),des_column],'euclidean');
        end
    end
    
    %% 策略S4的方向判断函数，包括判断要走的下一个元胞是否能走，判断下一个元胞是不是墙壁，选择下一步方向等等
    function people = is_wall(room_map,people,l,w)
        % 人员当前位置
        row = people.row;
        col = people.column;
        % temp为假设人员已经行动的模拟人员
        temp = people;
        temp.direction_next = temp.direction_tend;
        temp = move_direction(temp);
        nextcell_value = room_map(temp.row,temp.column);
        % 判断原本要走的下一个元胞是否能走或者是不是墙壁
        if nextcell_value == -1 % 判断是不是墙壁，1表示是，0则反之
            is_wall = 1;
        elseif ismember(nextcell_value , [0,7,8]) %判断要走的下一个元胞是否能走,1表示可以，0则反之
            is_wall = 0;
            people.direction_next = people.direction_tend; % 下一个元胞可以走，该人员方向不变
        else
            is_wall = 0;
            people.direction_next = 0;  % 下一个元胞有人，该人员原地不动
        end
        
        % 如果原本要走的下一个元胞是墙壁，先判断处于哪一段靠墙的位置
        if is_wall == 1
            % 判断人员是否在上下两段
            if row == 2  % 判断人员是否在上面靠墙一段
                if col ~= 2 && col ~= w-1  % 判断是否在墙角，1表示不在墙角
                    % 人员在上面靠墙一段并且不在墙角位置的情况
                    if people.clock == 1
                        people.direction_tend = 2;
                    else
                         people.direction_tend = 1;
                    end
                elseif col == 2  % 人员在左上角的情况
                    if people.clock == 1
                        people.direction_tend = 2;
                    else
                         people.direction_tend = 4;
                    end
                elseif col == w-1  % 人员在右上角的情况
                    if people.clock == 1
                        people.direction_tend = 4;
                    else
                         people.direction_tend = 1;
                    end
                end
            elseif row == l-1  % 判断人员是否在下面靠墙一段
                if col ~= 2 && col ~= w-1  % 判断是否在墙角，1表示不在墙角
                    % 人员在下面靠墙一段并且不在墙角位置的情况
                    if people.clock == 1
                        people.direction_tend = 1;
                    else
                         people.direction_tend = 2;
                    end
                elseif col == 2  % 人员在左下角的情况
                    if people.clock == 1
                        people.direction_tend = 3;
                    else
                         people.direction_tend = 2;
                    end
                elseif col == w-1  % 人员在右下角的情况
                    if people.clock == 1
                        people.direction_tend = 1;
                    else
                         people.direction_tend = 3;
                    end
                end
            end
            % 判断人员是否在左右两段且不在墙角
            if row ~= 2 && row ~= l-1
                if col == 2
                    % 人员在左面靠墙一段并且不在墙角位置的情况
                    if people.clock == 1
                        people.direction_tend = 3;
                    else
                         people.direction_tend = 4;
                    end
                elseif col == w-1
                    % 人员在右面靠墙一段并且不在墙角位置的情况
                    if people.clock == 1
                        people.direction_tend = 4;
                    else
                         people.direction_tend = 3;
                    end
                end
            end
        end
        % 靠墙选择完方向后
        temp2 = people;
        temp2.direction_next = temp2.direction_tend;
        temp2 = move_direction(temp2);
        nextcell_value2 = room_map(temp2.row,temp2.column);
        % 判断原本要走的下一个元胞是否能走或者是不是墙壁
        if ismember(nextcell_value2 , [0,7,8]) %判断要走的下一个元胞是否能走,1表示可以，0则反之
            people.direction_next = people.direction_tend; % 下一个元胞可以走
        else
            people.direction_next = 0;
        end
    end

    %% 判断要走的下一个元胞是否能走,1表示可以，0则反之
    function cell_free = cell_free(room_map,people)
        temp = people;
        temp.direction_next = temp.direction_tend;
        temp = move_direction(temp);
        nextcell_value = room_map(temp.row,temp.column);
        if ismember(nextcell_value , [0,7,8])
            cell_free = 1;
        else
            cell_free = 0;
        end
    end

    %% 实际更新人员的参数
    function people = move_direction(people)
        people.row_fore = people.row;
        people.column_fore = people.column;
        switch people.direction_next
            case 1 
                people.row = people.row;
                people.column = people.column - 1;
                people.stop_time = 0;
            case 2  
                people.row = people.row;
                people.column = people.column + 1;
                people.stop_time = 0;
            case 3 
                people.row = people.row - 1;
                people.column = people.column;
                people.stop_time = 0;
            case 4  
                people.row = people.row + 1;
                people.column = people.column;
                people.stop_time = 0;
            case 5  
                people.row = people.row - 1;
                people.column = people.column - 1;
                people.stop_time = 0;
            case 6  
                people.row = people.row - 1;
                people.column = people.column + 1;
                people.stop_time = 0;
            case 7
                people.row = people.row + 1;
                people.column = people.column - 1;
                people.stop_time = 0;
            case 8
                people.row = people.row + 1;
                people.column = people.column + 1;
                people.stop_time = 0;
            otherwise
                people.stop_time = people.stop_time + 1;
        end
    end
end