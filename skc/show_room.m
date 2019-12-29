function imh = show_room(room_map, imh, h)
    [L,W]=size(room_map); 
    %�����ػ���Ա
    room = room_map;
    if ishandle(imh)
        set(imh,'CData',room);
    else    %����չʾͼ���С�͸�ʽ
        imh=imagesc(room);
        colorbar;
        hold on;
        plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k');
        plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k');
        axis image
        set(gca, 'xtick', [], 'ytick', []);
    end
    pause(h);%չʾʱ��
end