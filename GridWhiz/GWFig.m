classdef GWFig<handle
% Handels the creation, and updating of the figure.

    properties
        Board
        FigureHandle
        AxesHandle
        FontSize
        DisplayCans
        DisplayCansHandles
        DisplaySolsHandles
        ResizeListener
        Width
        Height
    end

    methods
        function obj = GWFig(GWBoard)
            obj.Board=GWBoard;
        end

        function createGUI(obj)
            % creates the figure for the GUI
            obj.FigureHandle=figure("Name","GridWhiz",...
                "NumberTitle","off","MenuBar","none","Resize","on");
            % creates the axes to draw the Sudoku grid
            obj.AxesHandle=axes("Parent",obj.FigureHandle,...
                "XTick",[],"YTick",[],"XLim",[0 9],"YLim",[0 9]);
            hold on;

            % used to dynamically resize
            obj.ResizeListener=addlistener(obj.FigureHandle,"SizeChanged",@(gcf,event)obj.draw());

            obj.initDraw();
        end

        function checkResize(obj)
            figPos=get(obj.FigureHandle, "Position");
            if figPos(3)~=obj.Width || figPos(4)~=obj.Height
                if min(figPos(3),figPos(4))~=min(obj.Width,obj.Height)
                    % redraw
                    obj.draw();
                else
                    obj.Width=figPos(3);
                    obj.Height=figPos(4);
                end
            end
        end

        function initDraw(obj)
            cla(obj.AxesHandle);
            axis(obj.AxesHandle,"square");

            % draw grid lines
            obj.drawGrid();

            % get fontsize to be used in the next functions
            figPos=get(obj.FigureHandle, "Position");
            obj.Width=figPos(3);
            obj.Height=figPos(4);
            obj.FontSize=min(obj.Width,obj.Height)/18;
            
            % display numbers
            obj.initDisplaySolutions();
        end

        function draw(obj)
            % get fontsize to be used in the next functions
            figPos=get(obj.FigureHandle, "Position");
            obj.Width=figPos(3);
            obj.Height=figPos(4);
            obj.FontSize=min(obj.Width,obj.Height)/18;
            
            % resizes numbers
            obj.updateSolutionsText();
            obj.updateCandidatesText();
        end

        function drawGrid(obj)
            % draw lines
            for i=0:1:10
                % thick
                if mod(i,3)==0
                    plot([i i],[0 9],"k","lineWidth",2)
                    plot([0 9],[i i],"k","lineWidth",2)
                % thin
                else
                    plot([i i],[0 9],"k","lineWidth",1)
                    plot([0 9],[i i],"k","lineWidth",1)
                end
            end
        end

        function initDisplaySolutions(obj)
            % for every cell in the grid
            numSols=sum(obj.Board.Solutions~=0,"all");
            obj.DisplaySolsHandles=gobjects(1,numSols);
            l=0;
            for i=1:1:9
                for j=1:1:9
                    num=obj.Board.Solutions(i,j);
                    % if is not unsolved
                    if num~=0
                        % display solution in the middle of the cell
                        t=text(j-0.5,9-i+0.5,num2str(num),...
                             'HorizontalAlignment','center',...
                             'VerticalAlignment','middle',...
                             'FontSize',obj.FontSize);
                        l=l+1;
                        obj.DisplaySolsHandles(l)=t;
                    end
                end
            end
        end

        function updateSolutionsText(obj)
            set(obj.DisplaySolsHandles(:),"FontSize",obj.FontSize);
        end

        function updateSols(obj,i,j,n)
            obj.Board.updateSolutions(i,j,n);
            t=text(j-0.5,9-i+0.5,num2str(n),...
                 'HorizontalAlignment','center',...
                 'VerticalAlignment','middle',...
                 'FontSize',obj.FontSize);
            obj.DisplaySolsHandles(end+1)=t;
            for k=1:1:size(obj.DisplayCans,2)
                 if(obj.DisplayCans(1,k)==i...
                        && obj.DisplayCans(2,k)==j...
                        && obj.DisplayCans(3,k)==n)
                    obj.DisplayCans(:,k)=[];
                    delete(obj.DisplayCansHandles(k))
                    obj.DisplayCansHandles(k)=[];
                    break
                 end
            end
        end

        function initDisplayCandidates(obj)
            % Pregenerates coordinates
            xs=(1:27)*0.33333-0.16667;
            ys=9.16667-(1:27)*0.33333;
            smallFont=obj.FontSize/3.2;
            numCans=sum(obj.Board.Candidates~=0,"all");
            obj.DisplayCans=zeros(3,numCans);
            obj.DisplayCansHandles=gobjects(1,numCans);
            l=0;

            % for every cell in the grid
            for i=1:1:9
                for j=1:1:9
                    % if that spot isn't solved
                    if obj.Board.Solutions(i,j)==0
                        % for every possible number
                        for n=1:1:9
                            can=obj.Board.Candidates(i,j,n);
                            % that isn't ruled out
                            if can~=0
                                % put it on screen 
                                xOff=mod(n-1,3)+1;
                                yOff=floor((n-1)/3)+1;
                                x=(j-1)*3+xOff;
                                y=(i-1)*3+yOff;
                                t=text(xs(x),ys(y),num2str(n),...
                                    "HorizontalAlignment","center",...
                                    "VerticalAlignment","middle",...
                                    "FontSize",smallFont);
                                l=l+1;
                                obj.DisplayCans(:,l)=[i,j,n]';
                                obj.DisplayCansHandles(l)=t;
                            end
                        end
                    end
                end
            end
            tempIndicies=find(obj.DisplayCans(1,:)==0);
            for i=1:1:length(tempIndicies)
                obj.DisplayCans(:,tempIndicies(1))=[];
                obj.DisplayCansHandles(tempIndicies(1))=[];
            end
        end

        function updateCandidatesText(obj)
            % make sure the figure is open
            if ~ishandle(obj.FigureHandle)
                close all;
                return
            end
            % calculate font
            smallFont=obj.FontSize/3.2;
            set(obj.DisplayCansHandles(:),"FontSize",smallFont);
        end

        function deleteCansText(obj,n)
            % element is which element it is along the displayCansHandles
            % vector
            obj.DisplayCans(:,n)=[];
            delete(obj.DisplayCansHandles(n))
            obj.DisplayCansHandles(n)=[];
        end

        function removeCans(obj,i,j,n)
            % find the candidates display object and delete it
            if isempty(n)
                return
            end
            l=1;
            k=1;
            while k<=size(obj.DisplayCans,2)
                if(obj.DisplayCans(1,k)==i...
                        && obj.DisplayCans(2,k)==j...
                        && obj.DisplayCans(3,k)==n(l))
                    obj.deleteCansText(k);
                    if l==length(n)
                        break
                    end
                    l=l+1;
                    continue
                end
                k=k+1;
            end
            % removes it as a possible candidate
            obj.Board.removeCandidates(i,j,n);
        end

    end
end