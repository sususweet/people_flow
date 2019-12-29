function people_cell = people_insight_8d(n,people_cell)    
    if ~ismember(people_cell{n}.strategy , [2,5]) % ��Ϥ��������Ա�Ͳ���S2����Ա����Ҫ֪����Ұ��Moore����8���������Ա
        return;
    end
    % �ó���Ұ��8���������Ա��������鹹�ɵ�Ԫ��
    people_cell{n}.insight_8d = cell(1,8);  % ÿ��Ԫ��Ԫ��Ϊĳ����Ұ�����ϵ���Ա�������
    row = people_cell{n}.row; 
    col = people_cell{n}.column;
    in_num = size(people_cell{n}.insight,2);  % in_num��ʾ����Ա��Ұ��Χ�ڵ�������Ա��Ŀ
    for i = 1:in_num
        in_row = people_cell{people_cell{n}.insight(i)}.row; % ��Ұ�����people_cell{n}.insight(i)��Ա������
        in_col = people_cell{people_cell{n}.insight(i)}.column;
        % ���ϲ���
        if in_row <= row && in_col <= col
            if abs(in_row - row) <= abs(in_col - col)
                % ��Ա����1����
                people_cell{n}.insight_8d{1} = [people_cell{n}.insight_8d{1},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % ��Ա����2����
                people_cell{n}.insight_8d{2} = [people_cell{n}.insight_8d{2},people_cell{n}.insight(i)];
            end
        end
        % ���ϲ���
        if in_row <= row && in_col >= col
            if abs(in_row - row) <= abs(in_col - col)
                % ��Ա����4����
                people_cell{n}.insight_8d{4} = [people_cell{n}.insight_8d{4},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % ��Ա����3����
                people_cell{n}.insight_8d{3} = [people_cell{n}.insight_8d{3},people_cell{n}.insight(i)];
            end
        end
        % ���²���
        if in_row >= row && in_col <= col
            if abs(in_row - row) <= abs(in_col - col)
                % ��Ա����8����
                people_cell{n}.insight_8d{8} = [people_cell{n}.insight_8d{8},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % ��Ա����7����
                people_cell{n}.insight_8d{7} = [people_cell{n}.insight_8d{7},people_cell{n}.insight(i)];
            end
        end
         % ���²���
        if in_row >= row && in_col >= col
            if abs(in_row - row) <= abs(in_col - col)
                % ��Ա����5����
                people_cell{n}.insight_8d{5} = [people_cell{n}.insight_8d{5},people_cell{n}.insight(i)];
            end
            if abs(in_row - row) >= abs(in_col - col)
                % ��Ա����6����
                people_cell{n}.insight_8d{6} = [people_cell{n}.insight_8d{6},people_cell{n}.insight(i)];
            end
        end
    end
end