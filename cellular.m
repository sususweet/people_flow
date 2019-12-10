% һ�����ؿ�����ʻ����������Ԫ���Զ�����ͨ��ģ��
clc;
clear;
close all;
conf = config();

% Ԫ��ʵ�ʴ�С��һ��Ԫ��Ϊ cell_size*cell_size m^2 ʵ�ʴ�С
cell_size = 0.4;
space_w = 25; % �ռ�Ŀ��
space_h = 25; % �ռ�ĳ���
exit_w = 5; % ���ڵĿ��
Ks = 0.1;   % ��Ϥ���������˱���
h = NaN;  % ͼ��ľ��
per_show_time = 0.3;    %����չʾʱ��

iterations=50;    % ��������
prospace_wc=0.05;          % �������ܶ�
% prospace_wv=[0.1 1];      % ���ֳ������ܶȷֲ�
prospace_wslow=0.3;       % ��������ĸ���
Dsafe=1;            % ��ʾ����ʱ����������泵������ٸ���λ���㰲ȫ
% VTypes=[1,2];       %��·��һ���м�������ٶȲ�ͬ�ĳ���,�ٶ���ʲô

%������ɢ�ռ�
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
    
    
    
    
%     [v,gap,LUP,LDOWN]=para_count(plaza,v,vmax);%����ÿ��Ԫ����״̬���ٶȣ���Χ����
%     [plaza,v,vmax]=switch_lane(plaza,v,vmax,gap,LUP,LDOWN);%���
%     [plaza,v,vmax]=random_slow(plaza,v,vmax,prospace_wslow);%�������
%     [plaza,v,vmax]=move_forward(plaza,v,vmax);%���¸�Ԫ��״̬��������ǰ��ʻ��һ�����ڽ���
end




