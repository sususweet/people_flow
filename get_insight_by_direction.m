function [people] = get_insight_by_direction(insight_arr, position_x, position_y)
    % 获取指定坐标视野半径内的人员坐标，按照方向分类
    conf = config();
    people_LU = [];   % 左上角
    people_LD = [];   % 左下角
    people_RU = [];   % 右上角
    people_RD = [];   % 右下角
    people_U = [];    % 上面45°扇形区域
    people_D = [];    % 下面45°扇形区域
    people_L = [];    % 左面45°扇形区域
    people_R = [];    % 右面45°扇形区域
    for i=1:size(insight_arr, 1)
        insight_y = insight_arr(i,1);
        insight_x = insight_arr(i,2);
        diff_y = abs(insight_y - position_y);
        diff_x = abs(insight_x - position_x);
        % 计算右下、左下、右上、左上四个扇形区域内的人员数目，包括边界
        if insight_y >= position_y
            if insight_x >= position_x
                people_RD = [people_RD; insight_x insight_y];
                if diff_x >= diff_y
                    people_R = [people_R; insight_x insight_y];
                end
                if diff_x <= diff_y
                    people_D = [people_D; insight_x insight_y];
                end
            end
            if insight_x <= position_x
                people_LD = [people_LD; insight_x insight_y];
                if diff_x >= diff_y
                    people_L = [people_L; insight_x insight_y];
                end
                if diff_x <= diff_y
                    people_D = [people_D; insight_x insight_y];
                end
            end
        end
        if insight_y <= position_y
            if insight_x >= position_x
                people_RU = [people_RU; insight_x insight_y];
                if diff_x >= diff_y
                    people_R = [people_R; insight_x insight_y];
                end
                if diff_x <= diff_y
                    people_U = [people_U; insight_x insight_y];
                end
            end
            if insight_x <= position_x
                people_LU = [people_LU; insight_x insight_y];
                if diff_x >= diff_y
                    people_L = [people_L; insight_x insight_y];
                end
                if diff_x <= diff_y
                    people_U = [people_U; insight_x insight_y];
                end
            end
        end
    end

    people.people_LU = people_LU;   % 左上角
    people.people_LD = people_LD;   % 左下角
    people.people_RU = people_RU;   % 右上角
    people.people_RD = people_RD;   % 右下角
    people.people_U = people_U;    % 上面45°扇形区域
    people.people_D = people_D;    % 下面45°扇形区域
    people.people_L = people_L;    % 左面45°扇形区域
    people.people_R = people_R;    % 右面45°扇形区域
end

