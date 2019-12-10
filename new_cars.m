%初始化函数，随机在道路上生成车辆
function [plaza,v,vmax]=new_cars(plaza,v,probc)
    conf = config();
    [L,W]=size(plaza);
    vmax=zeros(L,W);
    % 随机产生空间中的人员
    for lanes=2:W-1
        for i=2:L-1
            if(rand<=probc) %在该位置随机产生一个车子
                tmp=rand;
                plaza(i,lanes)=conf.TYPE_PEOPLE_FAMILIAR;
                v(i,lanes)=conf.MOVE_STOP;
%                 for k=1:length(probv)   %随机生成一个车子应该有的最大车速
%                     if(tmp<=probv(k))
%                         vmax(i,lanes)=VTypes(k);%判断属于哪个挡的车速并赋值
%                         v(i,lanes)=ceil(rand*vmax(i,lanes));%对当前位置随机赋予一个初速度
%                         break;
%                     end
%                 end
            end
        end
    end
    %如果生成的车辆密度小于probc
    needn=ceil((W-2)*(L-2)*probc);
    %  needn = 2;
    number=size(find(vmax~=0),1);
    if(number<needn)%如果密度小于预期
        while(number~=needn)
            i=ceil(rand*(L-2));
            lanes=floor(rand*(W-2))+2;
            if(plaza(i,lanes)==conf.TYPE_PEOPLE_EMPTY)
                plaza(i,lanes)=conf.TYPE_PEOPLE_FAMILIAR;
                v(i,lanes)=conf.MOVE_STOP;
%                 for k=1:length(probv)   %随机生成一个车子应该有的最大车速
%                    if(tmp<=probv(k))
%                        vmax(i,lanes)=VTypes(k);%判断属于哪个挡的车速并赋值
%                        v(i,lanes)=ceil(rand*vmax(i,lanes));%对当前位置随机赋予一个初速度
%                        break;
%                    end
%                 end
                number=number+1;
            end
        end
    end
    %如果生成的车辆密度大于probc
    if(number>needn)
        temp=find(plaza==conf.TYPE_PEOPLE_FAMILIAR);
        for k=1:number-needn
            i=temp(k);
            plaza(i)=conf.TYPE_PEOPLE_EMPTY;
            % vmax(i)=0;
            v(i,lanes)=conf.MOVE_STOP;
        end
    end
end