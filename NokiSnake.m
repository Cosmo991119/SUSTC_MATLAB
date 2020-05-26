
function NokiSnake()
model=0;
% chose model
ButtonName2 = questdlg('准备开始，请选择模式......','mune','关卡模式','无尽模式','关卡模式');
if ButtonName2 == '关卡模式'
    model=0;
elseif ButtonName2 == '无尽模式'
    ButtonName2 = questdlg('选择有障碍则蛇死后会成为障碍物，并重新产生小蛇继续游戏','模式选择','无障碍','有障碍','无障碍');
    if ButtonName2 == '无障碍'
        model=1;
    elseif ButtonName2 == '有障碍'
        model=2;
    end
end

% init
totalsocre=0;
lens=60;
hight=lens;
score=0;
levels=1;
vel=1;
axis(0.5+[0, lens, 0, hight])                       % the size of map
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')% hide the x,y axis
set(gca, 'color', [0.682,0.864,0.710])
hold on

% init location & direction
snakeTop=[lens/2,lens/2];
body = [snakeTop; snakeTop(1,1)-1, snakeTop(1,2) ; snakeTop(1,1)-2, snakeTop(1,2) ;snakeTop(1,1)-3, snakeTop(1,2);snakeTop(1,1)-4, snakeTop(1,2);snakeTop(1,1)-5, snakeTop(1,2) ];
snakeDirect = [vel, 0];                             %direction of nake
long = 6;                                         % init length
food = [10, 10];                                  % init food location

set(gcf, 'KeyPressFcn', @key)     %keypress
fps = 5; % frequency

maps=[];
% the init location of the snake

%draw the snake
plotSnake = scatter(gca, body(:, 1), body(:, 2), 80,'bs', 'filled');

%draw the food
plotFood = scatter(gca, food(1), food(2), 50, [0.328,0.440,0.260], 'filled');

game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @snakeGame);    %timer, to update the snake and food
start(game)     % start the game

    function snakeGame(~,~)
        movtion();
        if model~=2
            crush()
            nextLevel();            
        else
            addMap();
        end
        
        %set(plotwall, 'XData', maps(1),  'YData', maps(2)); % renew map
        set(plotFood, 'XData', food(1),  'YData', food(2));  % renew food
        set(plotSnake, 'XData', body( : , 1), 'YData', body( : , 2)); % renew snake
    end

    function movtion()
        
        % basic movement.
        snakeTop = body(1,:) + snakeDirect;
        body = [snakeTop; body] ;
        
        % cross the edge
        body(body>lens)=body(body>lens)-lens;
        body(body<1)=body(body<1)+lens;
        
        %         fprintf('%f,%f    %f,%f\n',body(1,1),body(1,2),snakeTop(1),snakeTop(2));
        
        % delete the redundant part
        if length(body)>long
            body(end, : ) = [];
        end
        
        %eat food
        if isequal(snakeTop, food)
            long = long + 1;
            score=score+1;
            
           newFood();
        end
        
    end


    function crush()
        % the crush of itself
        
        if intersect(body(2 : end, : ), snakeTop, 'rows')
            ButtonName1 = questdlg('游戏结束，请点击按钮继续......','Gave Over','重新开始','关闭游戏', 'Yes');
            if ButtonName1 == '重新开始'
                clf;
                NokiSnake();
            else
                close;
            end
        end
        
        % crush the wall
        if size(maps)~=[0 0]
            if any(ismember(snakeTop, maps, 'rows'))
                ButtonName2 = questdlg('游戏结束，请点击按钮继续......','Gave Over','重新开始','关闭游戏', '关闭游戏');
                if ButtonName2 == '重新开始'
                    clf;
                    NokiSnake();
                else
                    close;
                end
            end
        end
    end


    function addMap()
        change=0;
        if any(ismember(snakeTop, body(2 : end, : ), 'rows'))
            if size(maps)~=[0 0]
                maps=body;
            else
                maps=[maps;body];
            end
            change=1;
        else
            if size(maps)~=[0 0]
                if any(ismember(snakeTop, maps, 'rows'))
                    maps=[maps;body];
                    change=1;
                end
            end
            
        end
        %
        
        if change==1
            clf
            axis([0, lens, 0, hight])                       % the size of map
            set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')% hide the x,y axis
            set(gca, 'color', [0.682,0.864,0.710])
            hold on
            
            if size(maps)~=[0 0]
                plotwall = scatter(gca, maps(:, 1), maps(:, 2), 50,[0.216,0.344,0.240], 'filled');
            end
            
            % new location of snake
            buildSnake();
            gap=[snakeTop(1)+1,snakeTop(2)];
            %
            while any(ismember(maps,body, 'rows') ) || any(ismember(maps,gap, 'rows') )
                buildSnake();
                gap=[snakeTop(1)+1,snakeTop(2)];
            end
            
            % food location
            newFood();
            
            snakeDirect = [vel, 0];                             %direction of nake
            long = 5;                                         % init length
            
            
            %draw the snake
            plotSnake = scatter(gca, body(:, 1), body(:, 2), 80,'bs', 'filled');
            
            %draw the food
            plotFood = scatter(gca, food(1), food(2), 50, [0.328,0.440,0.260], 'filled');
            change=0;
        end
    end

    function nextLevel()
        % next level
        if model==0
            if score==2 %levels*5+levels
                clf
                
                axis([0, lens, 0, hight])                       % the size of map
                set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')% hide the x,y axis
                set(gca, 'color', [0.682,0.864,0.710])
                hold on
                totalsocre=totalsocre+score;
                levels=levels+1;
                
                if levels==8
                    ButtonName2 = questdlg('游戏结束，请点击按钮继续......','Gave Over','重新开始','关闭游戏', '关闭游戏');
                    if ButtonName2 == '重新开始'
                        clf;
                        NokiSnake();
                    else
                        close;
                    end
                end
                
                maps=Map(levels,lens,hight);
                score=0;
                if size(maps)~=[0 0]
                    plotwall = scatter(gca, maps(:, 1), maps(:, 2), 50,[0.216,0.344,0.240], 'filled');
                end
                
                % new location of snake
                buildSnake();
                gap=[snakeTop(1)+1,snakeTop(2)];
                %
                while any(ismember(maps,body, 'rows') ) || any(ismember(maps,gap, 'rows') )
                    buildSnake();
                    gap=[snakeTop(1)+1,snakeTop(2)];
                end
                
                snakeDirect = [vel, 0];                             %direction of nake
                long = 5;                                         % init length
                food = [10, 10];                                  % init food location
                
                %draw the snake
                plotSnake = scatter(gca, body(:, 1), body(:, 2), 80,'bs', 'filled');
                
                %draw the food
                plotFood = scatter(gca, food(1), food(2), 50, [0.328,0.440,0.260], 'filled');
            end
            
        end
               
    end

    function newFood()
        food = [randi(lens),randi(hight)];
        
        if size(maps)~=[0 0]
            while any(ismember(food,body, 'rows')) || any(ismember(food, maps, 'rows'))
                food =[randi(lens),randi(hight)];
            end
        else
            while any(ismember(food,body, 'rows'))
                food =[randi(lens),randi(hight)];
            end
        end
    end


% build snake
    function buildSnake()
        snakeTop =[randi(lens),randi(hight)];
        body = [snakeTop; snakeTop(1,1)-1, snakeTop(1,2) ; snakeTop(1,1)-2, snakeTop(1,2) ;snakeTop(1,1)-3, snakeTop(1,2);snakeTop(1,1)-4, snakeTop(1,2);snakeTop(1,1)-5, snakeTop(1,2) ];
    end

% produce the map
    function map=Map(nums,length,hight)
        % i build 5 maps
        
        if nums==1
            map=[];
        elseif nums==2
            % map2
            map=[];
            for cnt=1:0.5:length-1
                map=[map;cnt,0;cnt,hight];
            end
            
            for cnt2=0:0.5:hight
                map=[map;1,cnt2;length,cnt2];
            end
        elseif nums==3
            % map3
            map=[];
            for cnt=1:0.5:10
                map=[map;cnt,0;cnt,hight];
                map=[map;0,cnt;length,cnt];
            end
            
            for cnt=10:0.5:length-11
                map=[map;cnt,hight/3;cnt,hight/3*2];
            end
            
            for cnt=length-10:0.5:length
                map=[map;cnt,0;cnt,hight];
                map=[map;0,cnt;length,cnt];
            end
        elseif nums==4
            map=[];
            for cnt=1:0.5:hight/3*2-10
                map=[map;length/3*2,cnt;cnt,hight/3];
            end
            
            for cnt=hight/3*2:0.5:hight
                map=[map;length/3+10,cnt;cnt,hight/3*2+10];
            end
        elseif nums==5
            map=[];
            for cnt=0:0.5:length
                map=[map;cnt,length/2;length/2,cnt];
            end
        elseif nums==6
            map=[];
            for cnt=5:0.5:length-5
                map=[map;cnt,5;cnt,hight-5;length-5,cnt];
            end
            
            for cnt=length/4:0.5:length/4*3
                map=[map;length/3,cnt;length/3*2,cnt];
            end
            
            for cnt=5:0.5:length/3
                map=[map;5,cnt;5,length-cnt];
            end
        elseif nums==7
            map=[];
            for cnt=0:0.5:length/2-10
                map=[map;4,cnt;4,length-cnt];
                map=[map;length-4,cnt;length-4,length-cnt];
                map=[map;cnt,4;length-cnt,4];
                map=[map;cnt,length-4;length-cnt,length-4];
            end
            
            for cnt=4:0.5:length/4
                map=[map;cnt,length/2-10;cnt,length/2+10];
                map=[map;length-cnt,length/2-10;length-cnt,length/2+10];
                map=[map;length/2-10,cnt;length/2+10,cnt];
                map=[map;length/2-10,length-cnt;length/2+10,length-cnt];
            end
            
            for cnt=length/2-10:0.5:length/2+10
                map=[map;length/4,cnt;cnt,length/4*3];
            end
            
        end
    end

% keyPress
    function key(~,event)
        switch event.Key
            case 'uparrow'
                direct = [0, vel];
            case 'downarrow'
                direct = [0, -vel];
            case 'leftarrow'
                direct = [-vel, 0];
            case 'rightarrow'
                direct = [vel, 0];
            case 'space'
                stop(game);
                direct = snakeDirect;
                ButtonName3 = questdlg('游戏暂停......', 'Stop ', '重新开始', '关闭游戏', '继续游戏', '关闭游戏');
                if ButtonName3 == '重新开始'
                    clf;
                    NokiSnake();
                elseif ButtonName3 == '关闭游戏'
                    close;
                else
                    start(game);
                end
            otherwise
                direct = nan;
        end
        
        if any(snakeDirect + direct)
            snakeDirect = direct;
        end
    end

end