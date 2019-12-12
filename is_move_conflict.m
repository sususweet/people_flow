function [is_conflict] = is_move_conflict(v1, v2, direction)
%IS_MOVE_CONFLICT 判断两个移动方向是否冲突，direction为在左方还是右方
%   此处显示详细说明
conf = config();

is_conflict = 0;

switch v1
case conf.MOVE_LEFTUP
    if v2 == conf.MOVE_RIGHTDOWN
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_RIGHTUP, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_LEFTDOWN, v2);
        end
    end
case conf.MOVE_LEFTDOWN
    if v2 == conf.MOVE_RIGHTUP
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_LEFTUP, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_RIGHTDOWN, v2);
        end
    end
case conf.MOVE_RIGHTUP
    if v2 == conf.MOVE_LEFTDOWN
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_RIGHTDOWN, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_LEFTUP, v2);
        end
    end
case conf.MOVE_RIGHTDOWN
    if v2 == conf.MOVE_LEFTUP
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_LEFTDOWN, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_RIGHTUP, v2);
        end
    end


case conf.MOVE_UP
    if v2 == conf.MOVE_DOWN
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_RIGHT, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_LEFT, v2);
        end
    end
case conf.MOVE_DOWN
    if v2 == conf.MOVE_UP
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_LEFT, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_RIGHT, v2);
        end
    end
case conf.MOVE_LEFT
    if v2 == conf.MOVE_RIGHT
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_UP, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_DOWN, v2);
        end
    end
case conf.MOVE_RIGHT
    if v2 == conf.MOVE_LEFT
        is_conflict = 1;
    else
        if direction == conf.DIRECTION_LEFT
            is_conflict = is_move_contains(conf.MOVE_DOWN, v2);
        end
        if direction == conf.DIRECTION_RIGHT
            is_conflict = is_move_contains(conf.MOVE_UP, v2);
        end
    end
end


end

