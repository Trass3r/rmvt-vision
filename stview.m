function stview(L, R)

    % display the images side by side
    idisp([L R], 'nogui');
    
    % initial cross hair location
    Y = 100;
    X = 100;

    % create the 3 lines segments and stash in user data on the axis
    ud.w = size(L,2);   % width of left image
    ud.hline = line('XData',get(gca,'XLim'),'YData',[Y Y], ...
                 'EraseMode','xor','Tag','Horizontal Cursor');
    ud.vline_l = line('XData',[X X],'YData',get(gca,'YLim'), ...
                 'EraseMode','xor','Tag','Vertical Cursor');
    ud.vline_r = line('XData',[X+ud.w X+ud.w],'YData',get(gca,'YLim'), ...
                 'EraseMode','xor','Tag','Vertical Cursor');
    ud.vline_r2 = line('XData',[X+ud.w X+ud.w],'YData',get(gca,'YLim'), ...
                 'EraseMode','xor','Tag','Vertical Cursor', 'color', 'g');
    ud.panel = uicontrol(gcf, ...
            'style', 'text', ...
            'units',  'norm', ...
            'pos', [.5 .935 .48 .05], ...
            'background', [1 1 1], ...
            'HorizontalAlignment', 'left', ...
            'string', ' Machine Vision Toolbox for Matlab  ' ...
        );
   set(gca, 'UserData', ud);

    % Set the WindowButtonFcn of the figure
    set(gcf,'WindowButtonDownFcn', @buttonDown,...
            'WindowButtonUpFcn',@buttonUp);	
                
end
        
function moveCursor(src, event)
    ud = get(gca, 'UserData');
    cp = get(gca,'CurrentPoint');
    % cp = [xfront yfront xfront; xback yback zback]

    if cp(1,1) < ud.w
        set(ud.hline, 'YData', [cp(1,2) cp(1,2)]);
        set(ud.vline_l, 'XData', [cp(1,1) cp(1,1)]);
        set(ud.vline_r, 'XData', ud.w+[cp(1,1) cp(1,1)]);
    else
        set(ud.vline_r2, 'XData', [cp(1,1) cp(1,1)]);
        xl = get(ud.vline_l, 'XData');
        %fprintf('d = %f\n', cp(1,1) - xl(1) - ud.w);
        set(ud.panel, 'string', sprintf('d = %f\n', cp(1,1) - xl(1) - ud.w));
    end
end

function buttonDown(src, event)
    set(gcf, 'WindowButtonMotionFcn',@moveCursor);
    moveCursor(src, event);
    %disp('down');
end

function buttonUp(src, event)
    %disp('up');
    set(gcf, 'WindowButtonMotionFcn','');
end
