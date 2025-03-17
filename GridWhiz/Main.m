clear,clc,close all;

board=BOARD("extreme",1);

%% BEGIN GRIDWHIZ

% speed = -1 for super fast
% speed = 0 for fast
% speed = 1 for slow
speed=0;

if speed==0 || speed==-1
    beforeP=0;
    duringP=0;
else
    beforeP=2;
    duringP=0.5;
end

boardGW=GWBoard(board);

figGW=GWFig(boardGW);
solverGW=GWSolver(figGW);

figGW.createGUI();
pause(beforeP);
disp("SOLVE")

solverGW.last();
figGW.initDisplayCandidates();
if speed>=0
    drawnow
end

for i=1:1:25
    if ~ishandle(figGW.FigureHandle)
        disp("PREMATURE EXIT")
        close all;
        break
    end

    solverGW.solve();

    if ~solverGW.Solvable
        break
    end

    disp("LAST")

    solverGW.last();
    if speed>0
        pause(duringP);
    elseif speed==0
        drawnow
    end
    solverGW.increaseDifficulty(1);


    figGW.updateCandidatesText();
    if speed>0
        pause(duringP);
    elseif speed==0
        drawnow
    end

    if sum(boardGW.Solutions==0,"all")==0 
%         figGW.updateSols();
        disp("FINISHED SOLVE IN")
        disp(i)
        disp("ITERATIONS")
        disp("Difficulty:")
        disp(solverGW.getDifficulty())
        break
    end

end








