function [insight_arr] = get_insight(plaza, v, position_x, position_y)
    % 获取指定坐标视野半径内的人员坐标
    conf = config();
    % plaza_tmp = plaza([position_y-conf.sight_r:position_y+conf.sight_r], [position_x-conf.sight_r:position_x+conf.sight_r]);
    index = find(plaza ~= conf.TYPE_PEOPLE_EMPTY & plaza ~= conf.TYPE_BARRIAR & plaza ~= conf.TYPE_EXIT);
	[index_i, index_j]=ind2sub(size(plaza),index);
    insight_arr = [];
    for i=1:size(index_i,1)
        distance = sqrt((position_y - index_i(i))^2+(position_x - index_j(i))^2);
        if distance <= conf.sight_r && distance > 0
            insight_arr = [insight_arr; index_i(i) index_j(i)];
        end
        % plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_UNFAMILIAR_4;
    end
end

