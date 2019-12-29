classdef people_flow
    %% 人员类的定义
    properties
        num         % 人员序号
        clock       % 策略S4的随机顺逆时针方向
        row_fore    % 上一步的行坐标
        column_fore % 上一步的列坐标
        row         % 行坐标       
        column      % 列坐标
        strategy    % 策略类型，% 1~4分别表示不熟悉环境人员的四种策略，5表示熟悉环境策略，6表示处于可见出口范围内的策略
        insight     % 视野内人员的序号数组
        insight_8d  % 视野内8个方向人员的序号元胞数组
        follow          % 所要跟随的人员的编号
        direction_fore  % 上一步的实际方向
        direction_tend  % 人员想要采取的行动
        direction_next  % 马上要走的下一步实际方向
        stop_time       % 在某处原地不动持续的时间，每步迭代时要记得加1或清零，并且判断是否达到阈值
        des             % 1表示人员到达出口（终点)，0则相反
        still_in_room   % 1表示人员还在房间内，没有到达出口（终点），0则相反
        if_inthe_exit   % 1表示人员处于可见出口范围内，0则相反
    end
end