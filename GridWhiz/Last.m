classdef Last
    methods(Static)

        function last(Solver)
        % Implements last free cell, last remaining cell, and last
        % possible number techniques
            % for every cell
            for i=1:1:9
                for j=1:1:9
                    % if the cell is unsolved
                    if Solver.Figure.Board.Solutions(i,j)==0
                        % for every remaining candidate check column row
                        % and box for solutions that are the same as the
                        % candidate and remove them from possible
                        % candidates
                        for n=1:1:9
                            if Solver.Figure.Board.Candidates(i,j,n)~=0
                                Last.vertLast(Solver,i,j,n)
                                Last.horiLast(Solver,i,j,n)
                                Last.boxLast(Solver,i,j,n)
                            end
                        end
                        % if there is only 1 candidate left flag it to be
                        % updated
                        n=find(Solver.Figure.Board.Candidates(i,j,:)==1);
                        if length(n)==1
                            Solver.Figure.updateSols(i,j,n)
                        elseif isempty(n)
                            Solver.Solvable=false;
disp("UNSOLVABLE")
disp([i j])
                        end
                    end
                end
            end
        end

        function vertLast(Solver,i,j,n)
            % for every cell in the column
            for I=1:1:9
                % skip current cell
                if I==i
                    continue
                end
                % if solution exists that is the same as the candidate
                if Solver.Figure.Board.Solutions(I,j)==n
                    % call function to find candidate display object, 
                    % delete it, and remove it as a candidate
                    Solver.Figure.removeCans(i,j,n)
                    % candidate has ben rulled out so can stop checking
                    return 
                end
            end
        end

        function horiLast(Solver,i,j,n)
            % for every cell in the row
            for J=1:1:9
                % skip current cell
                if J==j
                    continue
                end
                % if solution exists that is the same as the candidate
                if Solver.Figure.Board.Solutions(i,J)==n
                    % call function to find candidate display object, 
                    % delete it, and remove it as a candidate
                    Solver.Figure.removeCans(i,j,n)
                    % candidate has ben rulled out so can stop checking
                    return 
                end
            end
        end

        function boxLast(Solver,i,j,n)
            % finds the upper left corner of the box the current cell is in
            boxHori=floor((i-1)/3);
            boxVert=floor((j-1)/3);
            boxCorner=[boxHori*3+1 boxVert*3+1];
            % for every cell in the box
            for I=boxCorner(1):1:boxCorner(1)+2
                for J=boxCorner(2):1:boxCorner(2)+2
                    % skip current cell
                    if I==i && J==j
                        continue
                    end
                    % if solution exists that is the same as the candidate
                    if Solver.Figure.Board.Solutions(I,J)==n
                        % call function to find candidate display object, 
                        % delete it, and remove it as a candidate
                        Solver.Figure.removeCans(i,j,n)
                        % candidate has ben rulled out so can stop checking
                        return 
                    end
                end
            end
        end

    end
end