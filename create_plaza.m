%空间生成函数
function [plaza,v]=create_plaza(width,height,exit_width)
	conf = config();
    plaza=zeros(height+2,width+2);
    v= conf.MOVE_NULL * zeros(height+2,width+2); 

    % 空间的墙壁，不可达
    plaza(1:height+2,[1,2+width])=conf.TYPE_BARRIAR;   % 左右墙壁
    plaza([1,height+2],1:width+2)=conf.TYPE_BARRIAR;   % 上下墙壁

    % 空间出口位置
    plaza((height+2) / 2 - exit_width / 2:(height+2) / 2 + exit_width / 2, [1])=conf.TYPE_PEOPLE_EMPTY;    % 左出口
end