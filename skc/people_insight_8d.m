function people_cell = people_insight_8d(n,people_cell)    
    if ~ismember(people_cell{n}.strategy , [2,5]) % 熟悉环境的人员和策略S2的人员才需要知道视野中Moore邻域8个方向的人员
        return;
    end
    % 得出视野中8个方向的人员的序号数组构成的元胞
    people_cell{n}.insight_8d = cell(1,8);  % 每个元胞元素为某个视野方向上的人员序号数组
    row = people_cell{n}.row; 
    col = people_cell{n}.column;
    in_num = size(people_cell{n}.insight,2);  % in_num表示该人员视野范围内的其他人员数目
    for i = 1:in_num
        in_row = people_cell{people_cell{n}.insight(i)}.row; % 视野内序号people_cell{n}.insight(i)人员的坐标
        in_col = people_cell{people_cell{n}.insight(i)}.column;
        % 左上部分
        if in_row <= row && in_col <= col
            if abs(in_row - row) <= abs(in_col - col)
                % 人员属于1方向
                people_cell{n}.insight_8d{1} = [people_cell{n}.insight_8d{1},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % 人员属于2方向
                people_cell{n}.insight_8d{2} = [people_cell{n}.insight_8d{2},people_cell{n}.insight(i)];
            end
        end
        % 右上部分
        if in_row <= row && in_col >= col
            if abs(in_row - row) <= abs(in_col - col)
                % 人员属于4方向
                people_cell{n}.insight_8d{4} = [people_cell{n}.insight_8d{4},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % 人员属于3方向
                people_cell{n}.insight_8d{3} = [people_cell{n}.insight_8d{3},people_cell{n}.insight(i)];
            end
        end
        % 左下部分
        if in_row >= row && in_col <= col
            if abs(in_row - row) <= abs(in_col - col)
                % 人员属于8方向
                people_cell{n}.insight_8d{8} = [people_cell{n}.insight_8d{8},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % 人员属于7方向
                people_cell{n}.insight_8d{7} = [people_cell{n}.insight_8d{7},people_cell{n}.insight(i)];
            end
        end
         % 右下部分
        if in_row >= row && in_col >= col
            if abs(in_row - row) <= abs(in_col - col)
                % 人员属于5方向
                people_cell{n}.insight_8d{5} = [people_cell{n}.insight_8d{5},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % 人员属于6方向
                people_cell{n}.insight_8d{6} = [people_cell{n}.insight_8d{6},people_cell{n}.insight(i)];
            end
        end
    end
end