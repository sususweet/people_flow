function [room_map,people_cell] = people_update(n,room_map,people_cell,l_row,l_col)  % ���¸���Ա������һ���ж���ķ����ͼ
    %% �жϸ���Ա�Ƿ��Ѿ��뿪
    if people_cell{n}.still_in_room == 0
        return;
    end
    %% �ж���Ա�Ƿ񵽴��յ�
    if room_map(people_cell{n}.row , people_cell{n}.column) == 8
        people_cell{n}.des = 1;
        room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 7;
        room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
        return;
    end
    %% �жϸ���Ա�Ƿ���һ�����ڿɼ����ڷ�Χ��
    if people_cell{n}.if_inthe_exit == 1
            room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 7;
            room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
        return;
    else
        % �жϸ���Ա��ǰ�Ƿ��ڿɼ����ڷ�Χ��
        for k = 1:size(l_row,2)
            if ismember(people_cell{n}.row , l_row{k})
                if ismember(people_cell{n}.column , l_col(k))
                    people_cell{n}.if_inthe_exit = 1;
                    room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 0;
                    people_cell{n}.strategy = 6; % ���ߵ��ɼ����ڷ�Χ��ʱ���Ա�ΪS0��������6��ʾ
                    room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
                    return;
                end
            end
        end
    end
    %% ������ͨ�������Ա��ֵ
    room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 0;
    room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
end