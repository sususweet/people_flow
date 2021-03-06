%可视化
function h = show_plaza(plaza, h, n)
    conf = config();
    [L,W]=size(plaza); 
    temp=plaza;
    temp(temp==1)=0;    %清空所有的人员
    %更新重画人员
    plaza_draw=plaza;  
    PLAZA = plaza;
    %PLAZA(PLAZA<0)=PLAZA/6;
%     PLAZA(:,:,1)=plaza_draw;
%     PLAZA(:,:,2)=plaza_draw;
%     PLAZA(:,:,3)=temp;
    %PLAZA=1-PLAZA;
    % PLAZA=PLAZA/6;

    if ishandle(h)
        set(h,'CData',PLAZA);
    else    %调整展示图像大小和格式
        figure('position',[50 50 700 700]);
        clims = [conf.TYPE_BARRIAR conf.TYPE_PEOPLE_FAMILIAR];
        h=imagesc(PLAZA, clims);
        ax = gca;
        load('MyColormap','mymap')
        colormap(ax,mymap)
        % colorbar;
        hold on;
        plot([[0:W]',[0:W]']+0.5,[0,L]+0.5,'k');
        plot([0,W]+0.5,[[0:L]',[0:L]']+0.5,'k');
        axis image
        set(gca, 'xtick', [], 'ytick', []);
    end
    pause(n);%展示时长
end