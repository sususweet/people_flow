function [plaza,v,vmax]=new_cars(plaza,v,probc)
    conf = config();
    [L,W]=size(plaza);
    vmax=zeros(L,W);
    % ��������ռ��е���Ա
    for lanes=2:W-1
        for i=2:L-1
            if(rand<=probc) %�ڸ�λ���������һ����Ա
                tmp=rand;
                plaza(i,lanes)=conf.TYPE_PEOPLE_FAMILIAR;
                v(i,lanes)=conf.MOVE_STOP;
            end
        end
    end
    %������ɵ���Ա�ܶ�С��probc
    needn=ceil((W-2)*(L-2)*probc);
    %  needn = 2;
    number=size(find(vmax~=0),1);
    if(number<needn)%����ܶ�С��Ԥ��
        while(number~=needn)
            i=ceil(rand*(L-2));
            lanes=floor(rand*(W-2))+2;
            if(plaza(i,lanes)==conf.TYPE_PEOPLE_EMPTY)
                plaza(i,lanes)=conf.TYPE_PEOPLE_FAMILIAR;
                v(i,lanes)=conf.MOVE_STOP;
                number=number+1;
            end
        end
    end
    %������ɵ���Ա�ܶȴ���probc
    if(number>needn)
        temp=find(plaza==conf.TYPE_PEOPLE_FAMILIAR);
        for k=1:number-needn
            i=temp(k);
            plaza(i)=conf.TYPE_PEOPLE_EMPTY;
            v(i,lanes)=conf.MOVE_STOP;
        end
    end
end