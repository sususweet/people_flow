% ����ÿ��Ԫ��״̬
% ����Ϥ������Ⱥ�����ƺ�����ģ�͸��£��Բ���Ϥ������Ⱥ����S0~S4���Ը���
function [plaza,v,follow,location_pre]=move_forward(plaza,v,follow,iteration,location_pre)
conf = config();
[L,W]=size(plaza);

strategy_prior = [conf.TYPE_PEOPLE_UNFAMILIAR_4; conf.TYPE_PEOPLE_UNFAMILIAR_1; conf.TYPE_PEOPLE_FAMILIAR;
                  conf.TYPE_PEOPLE_UNFAMILIAR_2; conf.TYPE_PEOPLE_UNFAMILIAR_3];

% �������ȼ��ƶ�����
for k=1:size(strategy_prior,1)
    index = find(plaza == strategy_prior(k,1));
    [index_i, index_j]=ind2sub(size(plaza),index);
    people_num = size(index,1);
    for i = 1:people_num
        y_ori = index_i(i);
        x_ori = index_j(i);
        location_pre{y_ori, x_ori} = [location_pre{y_ori, x_ori}; y_ori x_ori];

        promote_strategy = conf.TYPE_BARRIAR;

        % һ��ʱ���ʼ����˵�λ��
        if iteration > conf.max_iteration
            y_diff = location_pre{y_ori, x_ori}(iteration, 1) - location_pre{y_ori, x_ori}(iteration - conf.max_iteration, 1);
            x_diff = location_pre{y_ori, x_ori}(iteration, 2) - location_pre{y_ori, x_ori}(iteration - conf.max_iteration, 2);
            distance = sqrt((y_diff)^2+(x_diff)^2);
            % ����������һ��������ͣ�����ã�����ò���S4
            if distance <= conf.max_iteration_r || abs(y_diff) <= conf.max_iteration_r || abs(x_diff) <= conf.max_iteration_r
                promote_strategy = conf.TYPE_PEOPLE_UNFAMILIAR_4;
            end
        end

        [plaza, v, follow, has_exit, x_target, y_target] = select_strategy(plaza, v, follow, x_ori, y_ori, promote_strategy);
        % ִ���ƶ�����
        if has_exit == 1
            plaza(y_ori, x_ori) = conf.TYPE_PEOPLE_EMPTY;
            v(y_ori, x_ori) = conf.MOVE_NULL;
            follow{y_ori, x_ori} = [];
            location_pre{y_ori, x_ori} = [];
        else
            if y_ori ~= y_target || x_ori ~= x_target
                plaza(y_ori, x_ori) = conf.TYPE_PEOPLE_EMPTY;
                plaza(y_target, x_target) = strategy_prior(k);
                v(y_target, x_target) = v(y_ori, x_ori);
                v(y_ori, x_ori) = conf.MOVE_NULL;
                follow{y_target, x_target} = follow{y_ori, x_ori};
                follow{y_ori, x_ori} = [];
                location_pre{y_target, x_target} = location_pre{y_ori, x_ori};
                location_pre{y_ori, x_ori} = [];
            end
        end
    end
end
end