function [people_cell,room_map] = people_intial(ex_num,Ks,room_map,l_row,l_col,exit_width)
    people_cell = cell(1,ex_num);
    l = size(room_map,1)-2;
    w = size(room_map,2)-2;
    n = 1;
    for i = 2:l+1
        for j = 1:w+1
            if room_map(i,j) == 1
                people_cell{n} = people_flow;
                people_cell{n}.follow = 0;
                people_cell{n}.num = n;
                people_cell{n}.clock = randi([0,1]);
                people_cell{n}.direction_fore = 0;
                people_cell{n}.direction_next = 0;
                people_cell{n}.row = i;
                people_cell{n}.column = j;
                people_cell{n}.des = 0;
                people_cell{n}.still_in_room = 1;
                people_cell{n}.stop_time = 0;
                if rand <= Ks  % 随机判断是否是熟悉环境的人员
                    people_cell{n}.strategy = 5;   % 5表示熟悉环境人员
                    room_map(people_cell{n}.row , people_cell{n}.column) = 5;
                else
                    people_cell{n}.strategy = randi(4); % 1~4分别表示不熟悉环境人员的四种策略
                    if people_cell{n}.strategy == 4
                        people_cell{n}.direction_tend = randi(8);  % 随机选择策略S4人员的初始方向
                    end
                    room_map(people_cell{n}.row , people_cell{n}.column) = people_cell{n}.strategy;
                end
                % 判断人员是否在可见出口范围内
                people_cell{n}.if_inthe_exit = 0;
                for k = 1:size(l_row,2)
                    if ismember(people_cell{n}.row , l_row{k})
                        if ismember(people_cell{n}.column , l_col(k))
                            people_cell{n}.if_inthe_exit = 1;
                            people_cell{n}.strategy = 6; % 人走到可见出口范围内时策略变为S0，用数字6表示
                        end
                    end
                end
                n = n+1;
            end
        end
    end
    %% 人员在可见出口范围内的值
    [room_map,~,~] = exit_visible(room_map,exit_width);
    for i = 1:ex_num
         if people_cell{i}.if_inthe_exit == 1
             room_map(people_cell{i}.row , people_cell{i}.column) = people_cell{i}.strategy;
         end
    end
end