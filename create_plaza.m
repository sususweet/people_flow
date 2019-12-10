%�ռ����ɺ���
function [plaza,v]=create_plaza(width,height,exit_width)
	conf = config();
    plaza=zeros(height+2,width+2);
    v= conf.MOVE_NULL * zeros(height+2,width+2); 

    % �ռ��ǽ�ڣ����ɴ�
    plaza(1:height+2,[1,2+width])=conf.TYPE_BARRIAR;   % ����ǽ��
    plaza([1,height+2],1:width+2)=conf.TYPE_BARRIAR;   % ����ǽ��

    % �ռ����λ��
    plaza((height+2) / 2 - exit_width / 2:(height+2) / 2 + exit_width / 2, [1])=conf.TYPE_PEOPLE_EMPTY;    % �����
end