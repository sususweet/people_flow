function [people] = get_insight_by_direction(insight_arr, position_x, position_y)
    % ��ȡָ��������Ұ�뾶�ڵ���Ա���꣬���շ������
    conf = config();
    people_LU = [];   % ���Ͻ�
    people_LD = [];   % ���½�
    people_RU = [];   % ���Ͻ�
    people_RD = [];   % ���½�
    people_U = [];    % ����45����������
    people_D = [];    % ����45����������
    people_L = [];    % ����45����������
    people_R = [];    % ����45����������
    for i=1:size(insight_arr, 1)
        insight_y = insight_arr(i,1);
        insight_x = insight_arr(i,2);
        diff_y = abs(insight_y - position_y);
        diff_x = abs(insight_x - position_x);
        % �������¡����¡����ϡ������ĸ����������ڵ���Ա��Ŀ�������߽�
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

    people.people_LU = people_LU;   % ���Ͻ�
    people.people_LD = people_LD;   % ���½�
    people.people_RU = people_RU;   % ���Ͻ�
    people.people_RD = people_RD;   % ���½�
    people.people_U = people_U;    % ����45����������
    people.people_D = people_D;    % ����45����������
    people.people_L = people_L;    % ����45����������
    people.people_R = people_R;    % ����45����������
end

