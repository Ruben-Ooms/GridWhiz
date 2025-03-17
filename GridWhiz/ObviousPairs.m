classdef ObviousPairs
    methods(Static)

        function obviousPairs(Solver)
        % Implements obvious pairs technique
            % for every cell
            for i=1:1:9
                for j=1:1:9
                    % if the cell is unsolved
                    if(Solver.Figure.Board.Solutions(i,j)==0 ...
                       && length(find(Solver.Figure.Board.Candidates(i,j,:)==1))==2)
                        % check for obvious pairs and remove them from
                        % other cells
                        ObviousPairs.vertObviousPairs(Solver,i,j);
                        ObviousPairs.horiObviousPairs(Solver,i,j);
%                         ObviousPairs.boxObviousPairs(Solver,i,j);
                    end
                end
            end
        end

        function vertObviousPairs(Solver,i,j)
            % skip if its the last cell in the column
            if i>8
                return
            end
            % gets the candidates of the current cell
            originalCandidates=squeeze(Solver.Figure.Board.Candidates(i,j,:));
            % for every cell below the current cell
            for I=i+1:1:9
                % get the cell of the possible pair
                pairedCandidates=squeeze(Solver.Figure.Board.Candidates(I,j,:));
                % if they match
                if originalCandidates==pairedCandidates
                    % find those candidates in other cells in the column
                    for X=1:1:9
                        if X==i || X==I
                            continue
                        end
                        % and get rid of them
                        checkCandidates=squeeze(Solver.Figure.Board.Candidates(X,j,:));
                        overlapIndices=find(and(originalCandidates,checkCandidates)==1);
                        if isempty(overlapIndices)
                            Solver.Figure.removeCans(X,j,overlapIndices);
                        end
                    end
                end
            end
        end

        function horiObviousPairs(Solver,i,j)
            % skip if its the last cell in the row
            if j>8
                return
            end
            % gets the candidates of the current cell
            originalCandidates=squeeze(Solver.Figure.Board.Candidates(i,j,:));
            % for every cell to the right of the current cell
            for J=j+1:1:9
                % get the cell of the possible pair
                pairedCandidates=squeeze(Solver.Figure.Board.Candidates(i,J,:));
                % if they match
                if originalCandidates==pairedCandidates
                    % find those candidates in other cells in the row
                    for Y=1:1:9
                        if Y==j || Y==J
                            continue
                        end
                        % and get rid of them
                        checkCandidates=squeeze(Solver.Figure.Board.Candidates(i,Y,:));
                        overlapIndices=find(and(originalCandidates,checkCandidates)==1);
                        if ~isempty(overlapIndices)
                            Solver.Figure.removeCans(i,Y,overlapIndices);
                        end
                    end
                end
            end
        end

%         function boxObviousPairs(Solver,i,j)
% 
%         end

    end
end