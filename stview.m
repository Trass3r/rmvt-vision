function stview(L, R)

    image(2256*[L R]);
    
    Y = 100;
    X = 100;
        ud.hline = line('XData',get(gca,'XLim'),'YData',[Y Y], ...
                     'EraseMode','xor','Tag','Horizontal Cursor');
        ud.vline = line('XData',[X X],'YData',get(gca,'YLim'), ...
                     'EraseMode','xor','Tag','Vertical Cursor');
   set(gca, 'UserData', ud);

    % Set the WindowButton...Fcn of the figure
    set(gcf,'WindowButtonDownFcn', @buttonDown,...
            'WindowButtonUpFcn',@buttonUp);	
                
end
        
function moveCursor(src, event)
    ud = get(gca, 'UserData');
     cp = get(gca,'CurrentPoint');
     cp
     set(ud.hline, 'YData', [cp(1,2) cp(2,2)]);
     set(ud.vline, 'XData', [cp(1,1) cp(2,1)]);
end

function buttonDown(src, event)
    set(gcf, 'WindowButtonMotionFcn',@moveCursor);
disp('down');

end

function buttonUp(src, event)
disp('up');
    set(gcf, 'WindowButtonMotionFcn','');

end
