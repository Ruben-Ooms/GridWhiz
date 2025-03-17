classdef ObviousTriples
    methods(Static)

        function obviousTriples(Solver)
        % Implements obvious triples technique
            % for every cell
            for i=1:1:9
                for j=1:1:9
                    % if the cell is unsolved and has less than 3 candidates
                    if Solver.Figure.Board.Solutions(i,j)==0 && length(find(Solver.Figure.Board.Candidates(i,j,:)==1))<=3
                        % check for obvious triples and remove them from
                        % other cells
                        ObviousTriples.vertObviousTriples(Solver,i,j);
                        ObviousTriples.horiObviousTriples(Solver,i,j);
                        ObviousTriples.boxObviousTriples(Solver,i,j);
                    end
                end
            end
        end

        function vertObviousTriples(Solver,i,j)
            % there has to be atleast 3 cells in the column for a triple
            if i>7
                return
            end
            % get first candidates list
            cansi=squeeze(Solver.Figure.Board.Candidates(i,j,:));
            % for every cell below
            for I=i+1:1:9
                % if its solved continue to the next cell
                if Solver.Figure.Board.Solutions(I,j)~=0
                    continue
                end
                % otherwise get the second set of candidates
                cansI=squeeze(Solver.Figure.Board.Candidates(I,j,:));
                % find which candidates overlap
                cansCommon2=or(cansi,cansI);
                % if there are more than 3 then go to next cell
                if length(find(cansCommon2==1))~=3
                    continue
                end
                % otherwise go through the remain cells below
                for X=I+1:1:9
                    % if its solved continue to the next cell
                    if Solver.Figure.Board.Solutions(X,j)~=0
                        continue
                    end
                    % otherwise get the third set of candidates
                    cansX=squeeze(Solver.Figure.Board.Candidates(X,j,:));
                    % find which candidates overlap
                    cansCommon3=or(cansCommon2,cansX);
                    % if there are more than 3 then go to next cell
                    if length(find(cansCommon3==1))>3
                        continue
                    end
                    % otherwise find which numbers are a part of the triple
                    cansCommonNums=find(cansCommon3==1);
                    % for every cell in the column
                    for l=1:1:9
                        % if its unsolved and not part of the triple cells
                        if Solver.Figure.Board.Solutions(i,l)==0 ...
                            && l~=i && l~=I && l~=X
                            % remove the triple candidates from the cell
                            Solver.Figure.removeCans(l,j,cansCommonNums);
                        end
                    end
                end
            end
        end

        function horiObviousTriples(Solver,i,j)
            % there has to be atleast 3 cells in the row for a triple
            if j>7
                return
            end
            % get first candidates list
            cansj=squeeze(Solver.Figure.Board.Candidates(i,j,:));
            % for every cell to the right
            for J=j+1:1:9
                % if its solved continue to the next cell
                if Solver.Figure.Board.Solutions(i,J)~=0
                    continue
                end
                % otherwise get the second set of candidates
                cansJ=squeeze(Solver.Figure.Board.Candidates(i,J,:));
                % find which candidates overlap
                cansCommon2=or(cansj,cansJ);
                % if there are more than 3 then go to next cell
                if length(find(cansCommon2==1))~=3
                    continue
                end
                % otherwise go through the remain cells to the right
                for Y=J+1:1:9
                    % if its solved continue to the next cell
                    if Solver.Figure.Board.Solutions(i,Y)~=0
                        continue
                    end
                    % otherwise get the third set of candidates
                    cansY=squeeze(Solver.Figure.Board.Candidates(i,Y,:));
                    % find which candidates overlap
                    cansCommon3=or(cansCommon2,cansY);
                    % if there are more than 3 then go to next cell
                    if length(find(cansCommon3==1))>3
                        continue
                    end
                    % otherwise find which numbers are a part of the triple
                    cansCommonNums=find(cansCommon3==1);
                    % for every cell in the row
                    for l=1:1:9
                        % if its unsolved and not part of the triple cells
                        if Solver.Figure.Board.Solutions(i,l)==0 ...
                            && l~=j && l~=J && l~=Y
                            % remove the triple candidates from the cell
                            Solver.Figure.removeCans(i,l,cansCommonNums);
                        end
                    end
                end
            end
        end

        function boxObviousTriples(Solver,i,j)
            boxHori=floor((i-1)/3);
            boxVert=floor((j-1)/3);
            boxCorner=[boxHori*3+1 boxVert*3+1];
            % there has to be atleast 3 cells in the box for a triple
            if mod(i,3)==0 && mod(j-1,3)>2
                return
            end
            % get first candidates list
            cans1=squeeze(Solver.Figure.Board.Candidates(i,j,:));
            % for every cell in the box
            for I=boxCorner(1):1:boxCorner(1)+2
                for J=boxCorner(2):1:boxCorner(2)+2
                    % if it is solved or earlier in the box than first cell
                    % go to next cell
                    if Solver.Figure.Board.Solutions(I,J)~=0 ...
                            || I<i || (I==i && J<=j)
                        continue
                    end
                    % otherwise get the second set of candidates
                    cans2=squeeze(Solver.Figure.Board.Candidates(I,J,:));
                    % find which candidates overlap
                    cansCommon2=or(cans1,cans2);
                    % if there are more than 3 then go to next cell
                    if length(find(cansCommon2==1))~=3
                        continue
                    end
                    % otherwise for every cell in the box
                    for X=boxCorner(1):1:boxCorner(1)+2
                        for Y=boxCorner(2):1:boxCorner(2)+2
                            % if it is solved or earlier in the box than
                            % first two cells go to next cell
                            if Solver.Figure.Board.Solutions(X,Y)~=0 ...
                                    || X<I || (X==I && Y<=J)
                                continue
                            end
                            % otherwise get the third set of candidates
                            cans3=squeeze(Solver.Figure.Board.Candidates(X,Y,:));
                            % find which candidates overlap
                            cansCommon3=or(cansCommon2,cans3);
                            % if there are more than 3 then go to next cell
                            if length(find(cansCommon3==1))>3
                                continue
                            end
                            % otherwise find which numbers are a part of the triple
                            cansCommonNums=find(cansCommon3==1);
                            % for every cell in the box
                            for k=boxCorner(1):1:boxCorner(1)+2
                                for l=boxCorner(2):1:boxCorner(2)+2
                                    % if its unsolved and not part of the triple cells
                                    if Solver.Figure.Board.Solutions(k,l)==0 ...
                                        && ((k~=i && l~=j) || (k~=I && l~=J) || (k~=X && l~=Y))
                                        % remove the triple candidates from the cell
                                        Solver.Figure.removeCans(k,l,cansCommonNums);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

    end
end
