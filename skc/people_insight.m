function people_cell = people_insight(n,r,people_cell,ex_num)
    if ismember(people_cell{n}.strategy , [1,2,3,5])   % ����S1��S3����Ա��Ҫ֪����Ұ�е���Ա��������Ҫ����8�����򣻲���S2����Ϥ����������Ҫ����
        row = people_cell{n}.row; 
        col = people_cell{n}.column;
        for i = 1:ex_num
            if  i ~= n && people_cell{i}.still_in_room == 1
                dis = pdist([row,col;people_cell{i}.row,people_cell{i}.column],'euclidean');  % �������Ա������ĳ����Աi�ľ���
                if dis <= r    % �ж���Աi�Ƿ��ڸ���Ա����Ұ��Χ��
                    people_cell{n}.insight = [people_cell{n}.insight,i];
                end
            end
        end
    end
end