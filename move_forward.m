% 更新每个元胞状态
% 对熟悉环境人群按照势函数场模型更新，对不熟悉环境人群按照S0~S4策略更新
function [plaza,v]=move_forward(plaza,v)
    conf = config();
	[L,W]=size(plaza);
    
    % 策略S4的移动
    index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_4);
	[index_i, index_j]=ind2sub(size(plaza),index);
    people_num = size(index,1);
    for i = 1:people_num
        y_ori = index_i(i);
        x_ori = index_j(i);
        [plaza, v, x_target, y_target] = select_strategy(plaza, v, x_ori, y_ori);
        % 执行移动操作
        if y_ori ~= y_target || x_ori ~= x_target
            plaza(y_ori, x_ori) = conf.TYPE_PEOPLE_EMPTY;
            plaza(y_target, x_target) = conf.TYPE_PEOPLE_UNFAMILIAR_4;
            v(y_target, x_target) = v(y_ori, x_ori);
            v(y_ori, x_ori) = conf.MOVE_NULL;
        end
    end

end