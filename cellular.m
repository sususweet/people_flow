% 一个遵守靠右行驶的两车道的元胞自动机交通流模型
clc;
clear;
close all;
conf = config();

space_w = 25; % 空间的宽度
space_h = 25; % 空间的长度
Ks = 0.4;   % 熟悉环境的行人比例

h = NaN;  % 图像的句柄
per_show_time = 0.1;    %单次展示时间

iterations=400;    % 迭代次数
prospace_wc=0.3;          % 人员密度

%生成疏散空间
[plaza,v,follow,location_pre] = create_plaza(space_w,space_h);
% h = show_plaza(plaza,h,per_show_time);
[plaza,v,vmax]=new_cars(plaza,v,prospace_wc);
[plaza,v] = dist_people(plaza,v,Ks);
% PLAZA=rot90(plaza,2);
h=show_plaza(plaza,h,per_show_time);

for t=1:iterations
    [plaza,v,follow,location_pre] = move_forward(plaza,v,follow,t,location_pre);
    h=show_plaza(plaza,h,per_show_time);
%     index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_4);
%     [index_i, index_j]=ind2sub(size(plaza),index);
%     people_num = size(index,1);
%     % disp(people_num);
end