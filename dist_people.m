function [plaza]=dist_people(plaza, Ks)
    conf = config();
	[L,W]=size(plaza);
    index = find(plaza == conf.TYPE_PEOPLE_FAMILIAR);
	[index_i, index_j]=ind2sub(size(plaza),index);
    people_num = size(index,1);
    people_unfami_num_1 = 0;
    people_unfami_num_2 = 0;
    people_unfami_num_3 = 0;
    people_unfami_num_4 = 0;

    for i=1:size(index_i,1)
        if rand<=Ks
            plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_FAMILIAR;
        else
            rand_num = rand;
%             if rand_num<=0.25
%                 plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_UNFAMILIAR_1;
%                 people_unfami_num_1 = people_unfami_num_1 + 1;
%             elseif rand_num <= 0.5
%                 plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_UNFAMILIAR_2;
%                 people_unfami_num_2 = people_unfami_num_2 + 1;
%             elseif rand_num <= 0.75
%                 plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_UNFAMILIAR_3;
%                 people_unfami_num_3 = people_unfami_num_3 + 1;
%             else
                plaza(index_i(i), index_j(i)) = conf.TYPE_PEOPLE_UNFAMILIAR_4;
                people_unfami_num_4 = people_unfami_num_4 + 1;
%             end
        end
    end
end

