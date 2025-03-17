classdef Singles
    methods(Static)

        function singles(Solver)
        % Implements obvious singles and hidden singles technique
            % for every cell
            for i=1:1:9
                for j=1:1:9
                    % if the cell is unsolved
                    if Solver.Figure.Board.Solutions(i,j)==0
                        % for every candidate
                        for n=1:1:9
                            if Solver.Figure.Board.Candidates(i,j,n)~=0
                                % check if its the last candidate of that
                                % number in column row and box
                                Singles.vertSingle(Solver,i,j,n);
                                Singles.horiSingle(Solver,i,j,n);
                                Singles.boxSingle(Solver,i,j,n);
                            end
                        end
                    end
                end
            end
        end

        function vertSingle(Solver,i,j,n)
            % for every element in the column
            for I=1:1:9
                % skip current cell
                if I==i
                    continue
                % if that candidate exists then stop checking, this i,j,n
                % is not a single
                elseif Solver.Figure.Board.Candidates(I,j,n)==1
                    return
                end
            end
            % only singles progress here call function that removes all 
            % other candidates and create solution
            Singles.singlesUpdateCansFlagSol(Solver,i,j,n)
        end

        function horiSingle(Solver,i,j,n)
            % for every element in the column
            for J=1:1:9
                % skip current cell
                if J==j
                    continue
                % if that candidate exists then stop checking, this i,j,n
                % is not a single
                elseif Solver.Figure.Board.Candidates(i,J,n)==1
                    return
                end
            end
            % only singles progress here call function that removes all 
            % other candidates and create solution
            Singles.singlesUpdateCansFlagSol(Solver,i,j,n)
        end

        function boxSingle(Solver,i,j,n)
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
                    elseif Solver.Figure.Board.Candidates(I,J,n)==1
                        return
                    end
                end
            end
            % only singles progress here call function that removes all 
            % other candidates and create solution
            Singles.singlesUpdateCansFlagSol(Solver,i,j,n)
        end

        function singlesUpdateCansFlagSol(Solver,i,j,n)
            Solver.Figure.updateSols(i,j,n); % flag cell to be solved
            Solver.Figure.Board.Candidates(i,j,:)=0; % set all candidates as not possible
            Solver.Figure.Board.Candidates(i,j,n)=1; % set only possible candidate as possible
            found=0; % since elements are sorted row 1 can skip once weve passed it
            % for every candidate
            k=1;
            while k<=length(Solver.Figure.DisplayCans)
                % delete candidates that are not the single
                if(Solver.Figure.DisplayCans(1,k)==i...
                   && Solver.Figure.DisplayCans(2,k)==j...
                   && Solver.Figure.DisplayCans(3,k)~=n)                   
                    Solver.Figure.deleteCansText(k);
                    found=1;
                    continue % don't increment counter
                elseif found==1 && Solver.Figure.DisplayCans(1,k)>i
                    break
                end
                k=k+1;
            end
        end

    end
end