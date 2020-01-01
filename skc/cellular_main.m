clc;
clear;
close all;

%% �������ó�ʼ��
% �������
cell_size = 0.8; %Ԫ��ʵ�ʴ�С��һ��Ԫ��Ϊ cell_size*cell_size m^2 ʵ�ʴ�С
length = 25;    % �ռ�ĳ���
width = 25;     % �ռ�Ŀ��
exit_w = 5;     % ���ڵĿ��
% ��Ա����
Ks = 0.4;   % ��Ϥ���������˱���
h = 0.1;    % ���沽��Ϊ0.3s
p = 0.3;    % ��Ա�ܶ�p
r = 3.0/cell_size;      % ��Ա��Ұ�뾶����Ԫ��������ʾ
tmax = 5;   % ԭ�صȴ�ʱ�����ֵ

%% �����ͼ��ʼ����ǽ��Ԫ��ֵΪ-1������Ԫ��ֵΪ0������Ԫ��ֵΪ1
time = 0;
room_map = zeros(length+2,width+2);
% ǽ��Ԫ����ʼ��
room_map(1:length+2,[1,width+2]) = -1;
room_map([1,length+2],1:width+2) = -1;
% ������ɷ����ڵ���Ա,���˵�Ԫ��ֵΪ1
row = 2:length+1;
column = 2:width+1;
room_map(row,column) = rand(length,width) < p; % ���������Ա����λ��
ex_num = sum(sum(room_map(row,column))); % ex_numΪ�����ڵĳ�ʼ��Ա��
now_num = ex_num; % now_numΪ��ʱ�����ڵ���Ա���������Ǹ��Ѿ��ߵ��յ����Ա
% �ɼ����ڷ�ΧԪ����ʼ��,Ԫ��ֵΪ2,���ҵõ��ɼ����ڷ�Χ������ly,lx
exit_width = 5; % ���ڿ��
des_column = 1; % ����������
%des_row = ceil((length + 2 - exit_width)/2) + 1 : ceil((length + 2 - exit_width)/2) + exit_width; % ����������
des_row = ceil((length + 2)/2);
[~,l_col,l_row] = exit_visible(room_map,exit_width);
% ��ʼ����Ա��
[people_cell,room_map] = people_intial(ex_num,Ks,room_map,l_row,l_col,exit_width);  % ��ʼ����Ա��

%% ��ͼ
% ����GUI����
% plotbutton=uicontrol('style','pushbutton','string','����', 'fontsize',12, 'position',[750,930,50,20], 'callback', 'run=1;');
% erasebutton=uicontrol('style','pushbutton','string','ֹͣ','fontsize',12,'position',[850,930,50,20],'callback','freeze=1;');
% quitbutton=uicontrol('style','pushbutton','string','�˳�','fontsize',12,'position',[950,930,50,20],'callback','stop=1;close;');
% ex_num_show = uicontrol('style','text','string',num2str(ex_num),'fontsize',12, 'position',[650,930,50,20]);
plotbutton=uicontrol('style','pushbutton','string','����', 'fontsize',12, 'position',[600,600,50,20], 'callback', 'run=1;');
erasebutton=uicontrol('style','pushbutton','string','ֹͣ','fontsize',12,'position',[700,600,50,20],'callback','freeze=1;');
quitbutton=uicontrol('style','pushbutton','string','�˳�','fontsize',12,'position',[800,600,50,20],'callback','stop=1;close;');
ex_num_show = uicontrol('style','text','string',['������������',num2str(now_num)],'fontsize',12, 'position',[400,600,200,20]);
time_show = uicontrol('style','text','string',['ʱ�䣺',num2str(time),'s'],'fontsize',12, 'position',[300,600,100,20]);
% ��ͼ��ʼ��
imh = NaN; % ͼ����
set(gcf,'outerposition',get(0,'screensize'));
imh = show_room(room_map, imh, h);

%% ���¼�ѭ��
stop= 0; run = 0; freeze = 0;
while stop == 0 && now_num > 0
    if run == 1
        % ���»�ͼ
        now_num = ex_num;
        for n = 1:ex_num
            if people_cell{n}.still_in_room == 1
                people_cell = people_insight(n,r,people_cell,ex_num);    % ���¸���Ա����Ұ��������Ա���������
                people_cell = people_insight_8d(n,people_cell);
                [people_cell,room_map] = go_forward(n,room_map,people_cell,des_row,des_column,tmax);  % ����Ա������һ���ж�
                [room_map,people_cell] = people_update(n,room_map,people_cell,l_row,l_col);   % ���¸���Ա������һ���ж���ķ����ͼ
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
    set(ex_num_show,'string',['������������',num2str(now_num)])
    set(time_show,'string',['ʱ�䣺',num2str(time),'s'])
    imh = show_room(room_map, imh, h);
end