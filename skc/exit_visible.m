function [room_map_temp,l_col,l_row] = exit_visible(room_map,exit_width)
    room_map_temp =room_map;
    [L,~]=size(room_map);   % LΪ����ǽ�ڵĿռ䳤��
    room_map_temp((L+2) / 2 - exit_width / 2 : (L+2) / 2 + exit_width /2 - 1, 1) = 8;
    %% �ɼ����ڷ�ΧԪ����ʼ��,Ԫ��ֵΪ7
    lig = exit_width + 3 + 3; % ����������һ�еĿɼ���
    i = 1;
    l_row = cell(1,ceil(lig/2));
    l_col = linspace(2,1+ceil(lig/2),ceil(lig/2));
    while lig >= 1
        temp = (L+2) / 2 - lig / 2 + 1 : (L+2) / 2 + lig /2;
        l_row{i} = temp;
        room_map_temp(l_row{i},l_col(i)) = 7;
        i = i + 1;
        lig = lig - 2;
    end
end