function cn = config()
    cn.TYPE_BARRIAR = -2;
	cn.TYPE_EXIT = -1;
    cn.TYPE_PEOPLE_EMPTY = 0;
    cn.TYPE_PEOPLE_FAMILIAR = 5;
    cn.TYPE_PEOPLE_UNFAMILIAR_1 = 1;
    cn.TYPE_PEOPLE_UNFAMILIAR_2 = 2;
    cn.TYPE_PEOPLE_UNFAMILIAR_3 = 3;
    cn.TYPE_PEOPLE_UNFAMILIAR_4 = 4;
    
    cn.MOVE_NULL = -1;
    cn.MOVE_STOP = 0;
    cn.MOVE_LEFT = 1;
    cn.MOVE_RIGHT = 2;
    cn.MOVE_UP = 3;
    cn.MOVE_DOWN = 4;
    cn.MOVE_LEFTUP = 5;
    cn.MOVE_RIGHTUP = 6;
    cn.MOVE_LEFTDOWN = 7;
    cn.MOVE_RIGHTDOWN = 8;
    
    % 行人自己前进方向的参考系
    cn.DIRECTION_LEFT = 0;
    cn.DIRECTION_RIGHT = 1;

    % 元胞实际大小，一个元胞为 cell_size*cell_size m^2 实际大小
    cn.cell_size = 0.4;
    cn.sight_r = 3/cn.cell_size;  % 行人的视野半径

    cn.exit_xy = [1 14];    % 空间出口位置
    cn.exit_width = 6;    % 出口的宽度
end