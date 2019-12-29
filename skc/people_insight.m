function people_cell = people_insight(n,r,people_cell,ex_num)
    if ismember(people_cell{n}.strategy , [1,2,3,5])   % 策略S1、S3的人员需要知道视野中的人员，但不需要区分8个方向；策略S2、熟悉环境的则还需要区分
        row = people_cell{n}.row; 
        col = people_cell{n}.column;
        for i = 1:ex_num
            if  i ~= n && people_cell{i}.still_in_room == 1
                dis = pdist([row,col;people_cell{i}.row,people_cell{i}.column],'euclidean');  % 计算该人员与其他某个人员i的距离
                if dis <= r    % 判断人员i是否处于该人员的视野范围内
                    people_cell{n}.insight = [people_cell{n}.insight,i];
                end
            end
        end
    end
end