function stview(L, R)

    % display the images side by side
    idisp([L R], 'nogui');
    
    % initial cross hair location
    Y = 100;
    X = 100;

    % create the 3 lines segments and stash in user data on the axis
    ud.w = size(L,2);
    ud.hline = line('XData',get(gca,'XLim'),'YData',[Y Y], ...
                 'EraseMode','xor','Tag','Horizontal Cursor');
    ud.vline_l = line('XData',[X X],'YData',get(gca,'YLim'), ...
                 'EraseMode','xor','Tag','Vertical Cursor');
    ud.vline_r = line('XData',[X+ud.w X+ud.w],'YData',get(gca,'YLim'), ...
                 'EraseMode','xor','Tag','Vertical Cursor');
   set(gca, 'UserData', ud);

    % Set the WindowButtonFcn of the figure
    set(gcf,'WindowButtonDownFcn', @buttonDown,...
            'WindowButtonUpFcn',@buttonUp);	
                
end
        
function moveCursor(src, event)
    ud = get(gca, 'UserData');
     cp = get(gca,'CurrentPoint');
     set(ud.hline, 'YData', [cp(1,2) cp(2,2)]);
     set(ud.vline_l, 'XData', [cp(1,1) cp(2,1)]);
     set(ud.vline_r, 'XData', ud.w+[cp(1,1) cp(2,1)]);
end

function buttonDown(src, event)
    set(gcf, 'WindowButtonMotionFcn',@moveCursor);
    %disp('down');
end

function buttonUp(src, event)
    %disp('up');
    set(gcf, 'WindowButtonMotionFcn','');
end
