% 一个考虑在能见度受限下行人跟随行为特性的行人流元胞自动机
clc;
clear;
close all;
conf = config();
global sight_r;

space_w = 25; % 空间的宽度
space_h = 25; % 空间的长度
time_step_arr = [];

% for prospace_wc = 0.1:0.1:1
    Ks = 0.4;   % 熟悉环境的行人比例
    sight_t = 3.0;
    sight_r = sight_t/conf.cell_size;  % 行人的视野半径

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

    time_arr=[];
    people_num_u1=[];
    people_num_u2=[];
    people_num_u3=[];
    people_num_u4=[];
    people_num_f=[];
    for t=1:iterations
        [plaza,v,follow,location_pre] = move_forward(plaza,v,follow,t,location_pre);
        h=show_plaza(plaza,h,per_show_time);

        time_arr = [time_arr, t];
        people_total = 0;

        index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_1);
        people_num_u1 = [people_num_u1, size(index,1)];
        people_total = people_total + size(index,1);
        index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_2);
        people_num_u2 = [people_num_u2, size(index,1)];
        people_total = people_total + size(index,1);
        index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_3);
        people_num_u3 = [people_num_u3, size(index,1)];
        people_total = people_total + size(index,1);
        index = find(plaza == conf.TYPE_PEOPLE_UNFAMILIAR_4);
        people_num_u4 = [people_num_u4, size(index,1)];
        people_total = people_total + size(index,1);
        index = find(plaza == conf.TYPE_PEOPLE_FAMILIAR);
        people_num_f = [people_num_f, size(index,1)];
        people_total = people_total + size(index,1);

        if people_total <= 0
            break;
        end
        if mod(t,20) == 0
            pause;
        end
    %     [index_i, index_j]=ind2sub(size(plaza),index);
    %     people_num = size(index,1);
    %     % disp(people_num);
    end
    time_step_arr = [time_step_arr, t];
% end


% figure;
% plot(0:0.05:1,time_step_arr,'LineWidth',2);
% hold on;
% xlabel('环境熟悉度'),ylabel('疏散时间步');

% figure;
% plot(1:0.5:5,time_step_arr,'LineWidth',2);
% hold on;
% xlabel('视野半径/m'),ylabel('疏散时间步');

% figure;
% plot(0.1:0.1:1,time_step_arr,'LineWidth',2);
% hold on;
% xlabel('人员密度'),ylabel('疏散时间步');

% figure;
% plot(time_arr,people_num_f,'Color',[183 70 255]./255,'LineWidth',2);
% hold on;
% plot(time_arr,people_num_u1,'Color',[255 0 0]./255,'LineWidth',2);
% hold on;
% plot(time_arr,people_num_u2,'Color',[255 105 41]./255,'LineWidth',2);
% hold on;
% plot(time_arr,people_num_u3,'Color',[19 159 255]./255,'LineWidth',2);
% hold on;
% plot(time_arr,people_num_u4,'Color',[0 0 255]./255,'LineWidth',2);
% hold on;
% xlabel('时间步'),ylabel('人数');
% title('采用不同策略人员人数的变化');