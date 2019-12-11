%空间生成函数
function [plaza,v,follow]=create_plaza(width,height)
	conf = config();
    plaza=zeros(height+2,width+2);
    v= conf.MOVE_NULL * zeros(height+2,width+2); 
    follow = cell(height+2,width+2);
    
    % 空间的墙壁，不可达
    plaza(1:height+2,[1,2+width])=conf.TYPE_BARRIAR;   % 左右墙壁
    plaza([1,height+2],1:width+2)=conf.TYPE_BARRIAR;   % 上下墙壁

    % 空间出口位置
    plaza(conf.exit_xy(2) - conf.exit_width / 2:conf.exit_xy(2) + conf.exit_width / 2, conf.exit_xy(1))=conf.TYPE_EXIT;    % 左出口
end