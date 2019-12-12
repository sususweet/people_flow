function [ v, position_x_target, position_y_target ] = proceed_move( direction, v, position_x, position_y )
%PROCEED_MOVE �����ƶ�����ִ��һ���ƶ����������ظ��º���ƶ��������
%   �˴���ʾ��ϸ˵��
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