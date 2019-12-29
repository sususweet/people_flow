function [people_cell,room_map] = go_forward(n,room_map,people_cell,des_row,des_column,tmax)
    [l,w] = size(room_map);  % l,wΪ����ǽ�ڵķ���ߴ�
    des_num = size(des_row,2); % �յ�ĸ�����
    c_row = des_row(ceil(size(des_row,2)/2));  % �յ����ĵ�������
%     MOVE_STOP = 0;
%     MOVE_LEFT = 1;
%     MOVE_RIGHT = 2;
%     MOVE_UP = 3;
%     MOVE_DOWN = 4;
%     MOVE_LEFTUP = 5;
%     MOVE_RIGHTUP = 6;
%     MOVE_LEFTDOWN = 7;
%     MOVE_RIGHTDOWN = 8;
    %% �ж���Ա�Ƿ��Ѿ����յ�
    if people_cell{n}.des == 1
        people_cell{n}.still_in_room = 0;
        room_map(people_cell{n}.row , people_cell{n}.column) = 8;   % ����Ա���յ��뿪
        return;
    end
    %% ���ݲ���������һ��
    switch people_cell{n}.strategy
       %% ����S1
        case 1 % ����S1
            people_cell{n}.direction_fore = people_cell{n}.direction_next;  % ������һ���ķ���
            if ~isempty(people_cell{n}.insight)     % �߼�1��ʾ����Ա����Ұ��Χ�����ٴ���һ��������Ա
                % �Ⱦ���Ҫ�������Ա
                if ismember(people_cell{n}.follow , people_cell{n}.insight) % �߼�1��ʾ֮ǰ�ı�������Ա��Ȼ����Ұ��Χ��
                    people_cell{n}.follow = people_cell{n}.follow;
                else
                    in_num = size(people_cell{n}.insight,2);    % in_num��ʾ����Ա��Ұ��Χ�ڵ�������Ա��Ŀ
                    people_cell{n}.follow = people_cell{n}.insight(randi(in_num)); % ���ѡ��Ҫ�������Ա
                end
                f = people_cell{n}.follow;  % fΪ��Ҫ������Ա�����
                % ������Χ8�����ӵ���Ҫ������Ա�ľ�������
                tof_distance = zeros(1,8);
                tof_distance = todes_distance(tof_distance,people_cell{n},people_cell{f}.row,people_cell{f}.column,1);
                [~,direction_next] = sort(tof_distance);
                for i = 1:8
                    people_cell{n}.direction_tend = direction_next(i);% ѡ��ǰ��Ҫ�ߵķ���
                    % �ж��¸�Ԫ���Ƿ�ԭ�����˻����ǲ���ǽ�ڵ�
                    if cell_free(room_map,people_cell{n})
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break;
                    elseif i == 8  % ��Χ8�����Ӷ������ߵ����
                        people_cell{n}.direction_next = 0;
                    end
                end
            else  % ��Ұ��û���˵����
                people_cell{n}.follow = 0;
                people_cell{n}.direction_next = 0;
            end
            people_cell{n} = move_direction(people_cell{n}); % ��Ա����ʵ���ж�
            people_cell{n}.insight = [];  % ��Ұ����
            % �������Աԭ�صȴ�ʱ�䳬�����ޣ���ı����ΪS4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end                   
       %% ����S2
        case 2  % ����S2
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% ������һ���ķ���
            people_cell{n} = s2_direction(n,people_cell{n},people_cell,room_map); 
            people_cell{n} = move_direction(people_cell{n});
            people_cell{n}.insight = [];  % ��Ұ���� 
            % �������Աԭ�صȴ�ʱ�䳬�����ޣ���ı����ΪS4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end  
       %% ����S3
        case 3  % ����S3
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% ������һ���ķ���
            people_cell{n} = s3_direction(n,people_cell{n},people_cell,room_map);
            people_cell{n} = move_direction(people_cell{n});
            people_cell{n}.insight = [];  % ��Ұ����
            % �������Աԭ�صȴ�ʱ�䳬�����ޣ���ı����ΪS4
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.strategy = 4;
                people_cell{n}.direction_tend = randi(8);
            end   
       %% ����S4
        case 4  % ����S4
            people_cell{n}.direction_fore = people_cell{n}.direction_next;% ������һ���ķ���
            people_cell{n} = is_wall(room_map,people_cell{n},l,w);   % ��������Ա����һ������
            people_cell{n} = move_direction(people_cell{n});
            % ����ȴ�ʱ�䳬�����ޣ��������������
            if people_cell{n}.stop_time >= tmax
                people_cell{n}.direction_tend = randi(8);
                people_cell{n}.clock = randi([0,1]);
            end  
            % people_cell{n}.insight = [];  % ��Ұ����
       %% ��Ϥ��������
        case 5  % ��Ϥ��������
            people_cell{n}.direction_fore = people_cell{n}.direction_next;   % ������һ���ķ���
            distance_or = pdist([people_cell{n}.row, people_cell{n}.column ; c_row, des_column],'euclidean'); % ����ԭ�ص��յ����ĵľ���
            distance = zeros(1,des_num*8);   % ����ԱԪ����Χ8���񵽼����յ�ľ�������
            distance = todes_distance(distance,people_cell{n},des_row,des_column,des_num);  % ������Ա��Χ8��Ԫ�����յ�(des_row,des_column)�ľ���
            [~,direction_next] = sort(distance);   % ���յ�ľ��밴��С�����������Χ��������
            for i = 1:8*des_num
                if distance(direction_next(i)) <= distance_or  % �ж����յ�ľ���Ҫ��ԭ�ز������յ����ĵľ������
                    if mod(direction_next(i),8) ~= 0
                        people_cell{n}.direction_tend = mod(direction_next(i),8);% ѡ��ǰ��Ҫ�ߵķ���
                    else
                        people_cell{n}.direction_tend = 8;
                    end
                    % �ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����
                    if cell_free(room_map,people_cell{n})
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break
                    elseif i == 8*des_num  % ��Χ�������ߵ����
                        people_cell{n}.direction_next = 0;
                    end
                else
                     people_cell{n}.direction_next = 0;
                end
            end
            people_cell{n} = move_direction(people_cell{n}); % ��Ա����ʵ���ж�
            people_cell{n}.insight = [];  % ��Ұ����
       %% ����S0
        case 6  % ����S0
            people_cell{n}.direction_fore = people_cell{n}.direction_next;   % ������һ���ķ���
            distance_or = pdist([people_cell{n}.row, people_cell{n}.column ; c_row, des_column],'euclidean'); % ����ԭ�ص��յ����ĵľ���
            distance = zeros(1,des_num*8);   % ����ԱԪ����Χ8���񵽼����յ�ľ�������
            distance = todes_distance(distance,people_cell{n},des_row,des_column,des_num);  % ������Ա��Χ8��Ԫ�����յ�(des_row,des_column)�ľ���
            [~,direction_next] = sort(distance);   % ���յ�ľ��밴��С�����������Χ��������
            for i = 1:8*des_num
                if distance(direction_next(i)) <= distance_or  % �ж����յ�ľ���Ҫ��ԭ�ز������յ����ĵľ������
                    if mod(direction_next(i),8) ~= 0
                        people_cell{n}.direction_tend = mod(direction_next(i),8);% ѡ��ǰ��Ҫ�ߵķ���
                    else
                        people_cell{n}.direction_tend = 8;
                    end
                    % �ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����,ͬʱ�����߳��ɼ����ڷ�Χ
                    temp4 = people_cell{n};
                    temp4.direction_next = temp4.direction_tend;
                    temp4 = move_direction(temp4);
                    if ismember(room_map(temp4.row,temp4.column),[7,8])
                        % Ҫ�ߵ���һ��Ԫ�����ڿɼ����ڷ�Χ���յ�
                        people_cell{n}.direction_next = people_cell{n}.direction_tend;
                        break;
                    elseif i == 8*des_num  % ��Χ�������ߵ����
                        people_cell{n}.direction_next = 0;
                    end
                else
                     people_cell{n}.direction_next = 0;
                     break;
                end
            end
            people_cell{n} = move_direction(people_cell{n}); % ��Ա����ʵ���ж�
            % people_cell{n}.insight = [];  % ��Ұ����
        %%
    end
    
    %% ����S2�ķ����жϺ������ж���Ұ��Χ��8����������Ա����������Ϊ��һ������
    function  people = s2_direction(n,people,people_cell,room_map)
        nq = zeros(1,8);
        if ~isempty(people.insight) % �߼�1��ʾ����Ա����Ұ��Χ�����ٴ���һ��������Ա
            % nq(i)��ʾi�ж������ϵ�������Ա��
            nq(1) = size(people_cell{n}.insight_8d{1},2) + size(people_cell{n}.insight_8d{8},2);
            nq(2) = size(people_cell{n}.insight_8d{4},2) + size(people_cell{n}.insight_8d{5},2);
            nq(3) = size(people_cell{n}.insight_8d{2},2) + size(people_cell{n}.insight_8d{3},2);
            nq(4) = size(people_cell{n}.insight_8d{6},2) + size(people_cell{n}.insight_8d{7},2);
            nq(5) = size(people_cell{n}.insight_8d{1},2) + size(people_cell{n}.insight_8d{2},2);
            nq(6) = size(people_cell{n}.insight_8d{3},2) + size(people_cell{n}.insight_8d{4},2);
            nq(7) = size(people_cell{n}.insight_8d{7},2) + size(people_cell{n}.insight_8d{8},2);
            nq(8) = size(people_cell{n}.insight_8d{5},2) + size(people_cell{n}.insight_8d{6},2);
            % ����ѡ����
            [~,maxh] = sort(nq,'descend');
            people.direction_tend = maxh(1);
            % �ж���һ��Ԫ���ܲ�����
            temp = people;
            temp.direction_next = temp.direction_tend;
            temp = move_direction(temp);
            nextcell_value = room_map(temp.row,temp.column);
            if ismember(nextcell_value , [0,7,8])
                people.direction_next = people.direction_tend;
            else
                people.direction_next = 0;
            end
        else  % ��Ұ��û���˵����
            people.direction_tend = 0;
            people.direction_next = 0;
        end
    end

    %% ����S3�ķ����жϺ������ж���Ұ��Χ�ڵ���Ա��һ�����ж����ķ���
    function  people = s3_direction(n,people,people_cell,room_map)
        h = zeros(1,9);  % h(9)��ʾ0��ԭ�ز�����h��ÿ��Ԫ�ر�ʾ��һ���ж�Ӧ�����ϵ��ƶ�����
        if ~isempty(people.insight)     % �߼�1��ʾ����Ա����Ұ��Χ�����ٴ���һ��������Ա
            sight_num = size(people.insight,2);  % sight_num��ʾ����Ա��Ұ��Χ�ڵ�������Ա��Ŀ
            for k = 1:sight_num
                if people.insight(k) < n  % �����Ұ�ڵ�people.insight(k)��Ա�����С�ڸ���Ա�����n,����people.insight(k)��Ա�ڵ�ǰ���Ѿ��ж���
                    % neΪ0~8����ʾ��Ұ�ڵ�people.insight(k)��Ա��һ����ʵ���ж�
                    ne = people_cell{people.insight(k)}.direction_fore;
                else
                    ne = people_cell{people.insight(k)}.direction_next;
                end
                % h������Ӧ��1
                if ne ~= 0
                    h(ne) = h(ne) + 1;
                else
                    h(9) = h(9) + 1;
                end
            end
            % ����,�õ���һ���д�������˵��ƶ�����maxh(1)
            [~,maxh] = sort(h,'descend');
            if maxh(1) ~= 9 
                people.direction_tend = maxh(1);
                % �ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����
                temp = people;
                temp.direction_next = temp.direction_tend;
                temp = move_direction(temp);
                nextcell_value = room_map(temp.row,temp.column);
                if ismember(nextcell_value , [0,7,8])
                    people.direction_next = people.direction_tend;
                else
                    people.direction_next = 0;
                end
            else % ��һ���д��������ԭ�ز��������
                people.direction_tend = 0;
                people.direction_next = 0;
            end
        else  % ��Ұ��û���˵����
            people.direction_tend = 0;
            people.direction_next = 0;
        end
    end

    %% ������Ա��Χ8��Ԫ�����յ�(des_row,des_column)�ľ���
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
    
    %% ����S4�ķ����жϺ����������ж�Ҫ�ߵ���һ��Ԫ���Ƿ����ߣ��ж���һ��Ԫ���ǲ���ǽ�ڣ�ѡ����һ������ȵ�
    function people = is_wall(room_map,people,l,w)
        % ��Ա��ǰλ��
        row = people.row;
        col = people.column;
        % tempΪ������Ա�Ѿ��ж���ģ����Ա
        temp = people;
        temp.direction_next = temp.direction_tend;
        temp = move_direction(temp);
        nextcell_value = room_map(temp.row,temp.column);
        % �ж�ԭ��Ҫ�ߵ���һ��Ԫ���Ƿ����߻����ǲ���ǽ��
        if nextcell_value == -1 % �ж��ǲ���ǽ�ڣ�1��ʾ�ǣ�0��֮
            is_wall = 1;
        elseif ismember(nextcell_value , [0,7,8]) %�ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����,1��ʾ���ԣ�0��֮
            is_wall = 0;
            people.direction_next = people.direction_tend; % ��һ��Ԫ�������ߣ�����Ա���򲻱�
        else
            is_wall = 0;
            people.direction_next = 0;  % ��һ��Ԫ�����ˣ�����Աԭ�ز���
        end
        
        % ���ԭ��Ҫ�ߵ���һ��Ԫ����ǽ�ڣ����жϴ�����һ�ο�ǽ��λ��
        if is_wall == 1
            % �ж���Ա�Ƿ�����������
            if row == 2  % �ж���Ա�Ƿ������濿ǽһ��
                if col ~= 2 && col ~= w-1  % �ж��Ƿ���ǽ�ǣ�1��ʾ����ǽ��
                    % ��Ա�����濿ǽһ�β��Ҳ���ǽ��λ�õ����
                    if people.clock == 1
                        people.direction_tend = 2;
                    else
                         people.direction_tend = 1;
                    end
                elseif col == 2  % ��Ա�����Ͻǵ����
                    if people.clock == 1
                        people.direction_tend = 2;
                    else
                         people.direction_tend = 4;
                    end
                elseif col == w-1  % ��Ա�����Ͻǵ����
                    if people.clock == 1
                        people.direction_tend = 4;
                    else
                         people.direction_tend = 1;
                    end
                end
            elseif row == l-1  % �ж���Ա�Ƿ������濿ǽһ��
                if col ~= 2 && col ~= w-1  % �ж��Ƿ���ǽ�ǣ�1��ʾ����ǽ��
                    % ��Ա�����濿ǽһ�β��Ҳ���ǽ��λ�õ����
                    if people.clock == 1
                        people.direction_tend = 1;
                    else
                         people.direction_tend = 2;
                    end
                elseif col == 2  % ��Ա�����½ǵ����
                    if people.clock == 1
                        people.direction_tend = 3;
                    else
                         people.direction_tend = 2;
                    end
                elseif col == w-1  % ��Ա�����½ǵ����
                    if people.clock == 1
                        people.direction_tend = 1;
                    else
                         people.direction_tend = 3;
                    end
                end
            end
            % �ж���Ա�Ƿ������������Ҳ���ǽ��
            if row ~= 2 && row ~= l-1
                if col == 2
                    % ��Ա�����濿ǽһ�β��Ҳ���ǽ��λ�õ����
                    if people.clock == 1
                        people.direction_tend = 3;
                    else
                         people.direction_tend = 4;
                    end
                elseif col == w-1
                    % ��Ա�����濿ǽһ�β��Ҳ���ǽ��λ�õ����
                    if people.clock == 1
                        people.direction_tend = 4;
                    else
                         people.direction_tend = 3;
                    end
                end
            end
        end
        % ��ǽѡ���귽���
        temp2 = people;
        temp2.direction_next = temp2.direction_tend;
        temp2 = move_direction(temp2);
        nextcell_value2 = room_map(temp2.row,temp2.column);
        % �ж�ԭ��Ҫ�ߵ���һ��Ԫ���Ƿ����߻����ǲ���ǽ��
        if ismember(nextcell_value2 , [0,7,8]) %�ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����,1��ʾ���ԣ�0��֮
            people.direction_next = people.direction_tend; % ��һ��Ԫ��������
        else
            people.direction_next = 0;
        end
    end

    %% �ж�Ҫ�ߵ���һ��Ԫ���Ƿ�����,1��ʾ���ԣ�0��֮
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

    %% ʵ�ʸ�����Ա�Ĳ���
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