function [room_map_temp,l_col,l_row] = exit_visible(room_map,exit_width)
    room_map_temp =room_map;
    [L,~]=size(room_map);   % L为加上墙壁的空间长度
    room_map_temp((L+2) / 2 - exit_width / 2 : (L+2) / 2 + exit_width /2 - 1, 1) = 8;
    %% 可见出口范围元胞初始化,元胞值为7
    lig = exit_width + 3 + 3; % 离出口最近的一列的可见度
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