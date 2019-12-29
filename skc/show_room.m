function imh = show_room(room_map, imh, h)
    [L,W]=size(room_map); 
    %更新重画人员
    room = room_map;
    if ishandle(imh)
        set(imh,'CData',room);
    else    %调整展示图像大小和格式
        imh=imagesc(room);
        colorbar;
        hold on;
        plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k');
        plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k');
        axis image
        set(gca, 'xtick', [], 'ytick', []);
    end
    pause(h);%展示时长
end