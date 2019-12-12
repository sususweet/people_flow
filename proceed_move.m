function [ v, position_x_target, position_y_target ] = proceed_move( direction, v, position_x, position_y )
%PROCEED_MOVE 根据移动方向执行一步移动操作，返回更新后的移动方向矩阵
%   此处显示详细说明
conf = config();
position_x_target = position_x;
position_y_target = position_y;

switch direction
	case conf.MOVE_STOP
        position_x_target = position_x;
        position_y_target = position_y;
    case conf.MOVE_LEFT
        position_x_target = position_x - 1;
    case conf.MOVE_RIGHT
        position_x_target = position_x + 1;
    case conf.MOVE_UP
        position_y_target = position_y - 1;
    case conf.MOVE_DOWN
        position_y_target = position_y + 1;
    case conf.MOVE_LEFTUP
        position_x_target = position_x - 1;
        position_y_target = position_y - 1;
    case conf.MOVE_LEFTDOWN
        position_x_target = position_x - 1;
        position_y_target = position_y + 1;
    case conf.MOVE_RIGHTUP
        position_x_target = position_x + 1;
        position_y_target = position_y - 1;
    case conf.MOVE_RIGHTDOWN
        position_x_target = position_x + 1;
        position_y_target = position_y + 1;
end
v(position_y, position_x) = direction;
end