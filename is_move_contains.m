function [contains] = is_move_contains(v1, v2)
%IS_MOVE_CONTAINS �ж�v1�����Ƿ����v2����������������������ϣ��������
%   �˴���ʾ��ϸ˵��
conf = config();
contains = 0;

switch v1
    case conf.MOVE_RIGHTUP
        if v2 == conf.MOVE_RIGHTUP
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHT
            contains = 1;
        end
        if v2 == conf.MOVE_UP
            contains = 1;
        end
    case conf.MOVE_RIGHTDOWN
        if v2 == conf.MOVE_RIGHTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHT
            contains = 1;
        end
        if v2 == conf.MOVE_DOWN
            contains = 1;
        end
    case conf.MOVE_LEFTUP
        if v2 == conf.MOVE_LEFTUP
            contains = 1;
        end
        if v2 == conf.MOVE_LEFT
            contains = 1;
        end
        if v2 == conf.MOVE_UP
            contains = 1;
        end
    case conf.MOVE_LEFTDOWN
        if v2 == conf.MOVE_LEFTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_LEFT
            contains = 1;
        end
        if v2 == conf.MOVE_DOWN
            contains = 1;
        end
    case conf.MOVE_UP
        if v2 == conf.MOVE_LEFTUP
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHTUP
            contains = 1;
        end
        if v2 == conf.MOVE_UP
            contains = 1;
        end
    case conf.MOVE_DOWN
        if v2 == conf.MOVE_LEFTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_DOWN
            contains = 1;
        end
    case conf.MOVE_LEFT
        if v2 == conf.MOVE_LEFTUP
            contains = 1;
        end
        if v2 == conf.MOVE_LEFTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_LEFT
            contains = 1;
        end
    case conf.MOVE_RIGHT
        if v2 == conf.MOVE_RIGHTDOWN
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHTUP
            contains = 1;
        end
        if v2 == conf.MOVE_RIGHT
            contains = 1;
        end
end

end

