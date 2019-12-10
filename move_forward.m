% ����ÿ��Ԫ��״̬
% ����Ϥ������Ⱥ�����ƺ�����ģ�͸��£��Բ���Ϥ������Ⱥ����S0~S4���Ը���
function [plaza,v]=move_forward(plaza,v)
    conf = config();
	[L,W]=size(plaza);
    
    % ����S4���ƶ�
    index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_4);
	[index_i, index_j]=ind2sub(size(plaza),index);
    people_num = size(index,1);
    for i = 1:people_num
        y_ori = index_i(i);
        x_ori = index_j(i);
        [plaza, v, x_target, y_target] = select_strategy(plaza, v, x_ori, y_ori);
        % ִ���ƶ�����
        if y_ori ~= y_target || x_ori ~= x_target
            plaza(y_ori, x_ori) = conf.TYPE_PEOPLE_EMPTY;
            plaza(y_target, x_target) = conf.TYPE_PEOPLE_UNFAMILIAR_4;
            v(y_target, x_target) = v(y_ori, x_ori);
            v(y_ori, x_ori) = conf.MOVE_NULL;
        end
    end

end