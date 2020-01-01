clc;
clear;
close all;

%% 参数配置初始化
% 房间参数
cell_size = 0.8; %元胞实际大小，一个元胞为 cell_size*cell_size m^2 实际大小
length = 25;    % 空间的长度
width = 25;     % 空间的宽度
exit_w = 5;     % 出口的宽度
% 人员参数
Ks = 0.4;   % 熟悉环境的行人比例
h = 0.1;    % 仿真步长为0.3s
p = 0.3;    % 人员密度p
r = 3.0/cell_size;      % 人员视野半径，以元胞格数表示
tmax = 5;   % 原地等待时间最大值

%% 房间地图初始化，墙壁元胞值为-1，无人元胞值为0，有人元胞值为1
time = 0;
room_map = zeros(length+2,width+2);
% 墙壁元胞初始化
room_map(1:length+2,[1,width+2]) = -1;
room_map([1,length+2],1:width+2) = -1;
% 随机生成房间内的人员,有人的元胞值为1
row = 2:length+1;
column = 2:width+1;
room_map(row,column) = rand(length,width) < p; % 随机生成人员所在位置
ex_num = sum(sum(room_map(row,column))); % ex_num为房间内的初始人员数
now_num = ex_num; % now_num为此时房间内的人员数，包括那个已经走到终点的人员
% 可见出口范围元胞初始化,元胞值为2,并且得到可见出口范围的坐标ly,lx
exit_width = 5; % 出口宽度
des_column = 1; % 出口列坐标
%des_row = ceil((length + 2 - exit_width)/2) + 1 : ceil((length + 2 - exit_width)/2) + exit_width; % 出口行坐标
des_row = ceil((length + 2)/2);
[~,l_col,l_row] = exit_visible(room_map,exit_width);
% 初始化人员类
[people_cell,room_map] = people_intial(ex_num,Ks,room_map,l_row,l_col,exit_width);  % 初始化人员类

%% 绘图
% 设置GUI按键
% plotbutton=uicontrol('style','pushbutton','string','运行', 'fontsize',12, 'position',[750,930,50,20], 'callback', 'run=1;');
% erasebutton=uicontrol('style','pushbutton','string','停止','fontsize',12,'position',[850,930,50,20],'callback','freeze=1;');
% quitbutton=uicontrol('style','pushbutton','string','退出','fontsize',12,'position',[950,930,50,20],'callback','stop=1;close;');
% ex_num_show = uicontrol('style','text','string',num2str(ex_num),'fontsize',12, 'position',[650,930,50,20]);
plotbutton=uicontrol('style','pushbutton','string','运行', 'fontsize',12, 'position',[600,600,50,20], 'callback', 'run=1;');
erasebutton=uicontrol('style','pushbutton','string','停止','fontsize',12,'position',[700,600,50,20],'callback','freeze=1;');
quitbutton=uicontrol('style','pushbutton','string','退出','fontsize',12,'position',[800,600,50,20],'callback','stop=1;close;');
ex_num_show = uicontrol('style','text','string',['房间内人数：',num2str(now_num)],'fontsize',12, 'position',[400,600,200,20]);
time_show = uicontrol('style','text','string',['时间：',num2str(time),'s'],'fontsize',12, 'position',[300,600,100,20]);
% 绘图初始化
imh = NaN; % 图像句柄
set(gcf,'outerposition',get(0,'screensize'));
imh = show_room(room_map, imh, h);

%% 主事件循环
stop= 0; run = 0; freeze = 0;
while stop == 0 && now_num > 0
    if run == 1
        % 更新绘图
        now_num = ex_num;
        for n = 1:ex_num
            if people_cell{n}.still_in_room == 1
                people_cell = people_insight(n,r,people_cell,ex_num);    % 更新该人员的视野内其他人员的序号数组
                people_cell = people_insight_8d(n,people_cell);
                [people_cell,room_map] = go_forward(n,room_map,people_cell,des_row,des_column,tmax);  % 该人员作出下一步行动
                [room_map,people_cell] = people_update(n,room_map,people_cell,l_row,l_col);   % 更新该人员作出下一步行动后的房间地图
            else
                %room_map(people_cell{n}.row , people_cell{n}.column) = 8;
                now_num = now_num - 1; 
            end
        end
        if now_num > 0
            time = time + 0.3;
        end
    end
    if freeze==1
        run = 0;
        freeze = 0;
    end
    set(ex_num_show,'string',['房间内人数：',num2str(now_num)])
    set(time_show,'string',['时间：',num2str(time),'s'])
    imh = show_room(room_map, imh, h);
end