% 一个遵守靠右行驶的两车道的元胞自动机交通流模型
clc;
clear;
close all;
conf = config();

% 元胞实际大小，一个元胞为 cell_size*cell_size m^2 实际大小
cell_size = 0.4;
space_w = 25; % 空间的宽度
space_h = 25; % 空间的长度
exit_w = 5; % 出口的宽度
Ks = 0.1;   % 熟悉环境的行人比例
h = NaN;  % 图像的句柄
per_show_time = 0.3;    %单次展示时间

iterations=50;    % 迭代次数
prospace_wc=0.05;          % 车辆的密度
% prospace_wv=[0.1 1];      % 两种车流的密度分布
prospace_wslow=0.3;       % 随机慢化的概率
Dsafe=1;            % 表示换道时车至少与后面车距离多少个单位才算安全
% VTypes=[1,2];       %道路上一共有几种最大速度不同的车辆,速度是什么

%生成疏散空间
[plaza,v] = create_plaza(space_w,space_h,exit_w);
% h = show_plaza(plaza,h,per_show_time);
[plaza,v,vmax]=new_cars(plaza,v,prospace_wc);
plaza = dist_people(plaza,Ks);
% PLAZA=rot90(plaza,2);
h=show_plaza(plaza,h,per_show_time);

for t=1:iterations
    plaza = move_forward(plaza);
    h=show_plaza(plaza,h,per_show_time);
       index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_4);
	[index_i, index_j]=ind2sub(size(plaza),index);
    people_num = size(index,1);
    disp(people_num);
    
    
    
    
%     [v,gap,LUP,LDOWN]=para_count(plaza,v,vmax);%计算每个元胞的状态，速度，周围环境
%     [plaza,v,vmax]=switch_lane(plaza,v,vmax,gap,LUP,LDOWN);%变道
%     [plaza,v,vmax]=random_slow(plaza,v,vmax,prospace_wslow);%随机慢化
%     [plaza,v,vmax]=move_forward(plaza,v,vmax);%更新各元胞状态，车流向前行驶，一个周期结束
end




