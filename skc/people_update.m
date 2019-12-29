function [room_map,people_cell] = people_update(n,room_map,people_cell,l_row,l_col)  % 更新该人员作出下一步行动后的房间地图
    %% 判断该人员是否已经离开
    if people_cell{n}.still_in_room == 0
        return;
    end
    %% 判断人员是否到达终点
    if room_map(people_cell{n}.row , people_cell{n}.column) == 8
        people_cell{n}.des = 1;
        room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 7;
        room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
        return;
    end
    %% 判断该人员是否上一步已在可见出口范围内
    if people_cell{n}.if_inthe_exit == 1
            room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 7;
            room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
        return;
    else
        % 判断该人员当前是否在可见出口范围内
        for k = 1:size(l_row,2)
            if ismember(people_cell{n}.row , l_row{k})
                if ismember(people_cell{n}.column , l_col(k))
                    people_cell{n}.if_inthe_exit = 1;
                    room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 0;
                    people_cell{n}.strategy = 6; % 人走到可见出口范围内时策略变为S0，用数字6表示
                    room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
                    return;
                end
            end
        end
    end
    %% 更新普通情况下人员的值
    room_map(people_cell{n}.row_fore , people_cell{n}.column_fore) = 0;
    room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
end