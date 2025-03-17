classdef HiddenPairs
    methods(Static)
        
        function hiddenPairs(Solver)
        % Implements hidden pairs technique
            % for every cell
            for i=1:1:9
                for j=1:1:9
                    % if the cell is unsolved
                    if Solver.Figure.Board.Solutions(i,j)==0
                        % check for hidden pairs and remove non hidden pair
                        % candidates
                        HiddenPairs.vertHiddenPairs(Solver,i,j);
                        HiddenPairs.horiHiddenPairs(Solver,i,j);
                        HiddenPairs.boxHiddenPairs(Solver,i,j);
                    end
                end
            end
        end

        function vertHiddenPairs(Solver,i,j)
            % skip if its the last cell in the column
            if i>8
                return
            end
            % for every cell below the current cell
            for I=i+1:1:9
                % find which candidates they have in common
                overlaps=and(Solver.Figure.Board.Candidates(i,j,:),Solver.Figure.Board.Candidates(I,j,:));
                overlaps=squeeze(overlaps);
                % get the numbers that they overlap
                overlapIndices=find(overlaps==1);
                % get how many overlaps there are
                numOverlaps=length(overlapIndices);
                % if there are at least 2
                if numOverlaps>=2 
                    % get pairs of the overlapped numbers
                    for a=1:1:numOverlaps-1
                        for b=a+1:1:numOverlaps
                            % get the current possible pair
                            overlapNums=[overlapIndices(a) overlapIndices(b)];
                            % create a vector representing it as candidates
                            curOverlap=zeros(9,1);
                            curOverlap(overlapNums(1))=1;
                            curOverlap(overlapNums(2))=1;
                            goodNums=true;
                            % increment over all the column
                            for l=1:1:9
                                % skip if its the current cells being compared
                                if l==i || l==I
                                    continue
                                end
                                % get the candidates from the cell being
                                % looked at
                                posCans=squeeze(Solver.Figure.Board.Candidates(l,j,:));
                                % if there is overlap then this pair cannot
                                % be a hidden pair
                                if sum(and(curOverlap,posCans))>0
                                    goodNums=false;
                                    break
                                end
                            end   
                            % if there was no overlap of the pair in the
                            % whole column, then it must be a hidden pair so
                            % remove the remaining candidates
                            if goodNums
                                % gets non pair candidates from the first cell
                                posCans=squeeze(Solver.Figure.Board.Candidates(i,j,:));
                                nonPairNums=find(xor(posCans,curOverlap)==1);
                                % removes them
                                if ~isempty(nonPairNums)
                                    Solver.Figure.removeCans(i,j,nonPairNums)
                                end
                                % gets non pair candidates from the second cell
                                posCans=squeeze(Solver.Figure.Board.Candidates(I,j,:));
                                nonPairNums=find(xor(posCans,curOverlap)==1);
                                % removes them
                                if ~isempty(nonPairNums)
                                    Solver.Figure.removeCans(I,j,nonPairNums)
                                end
                            end
                        end
                    end
                end
            end
        end

        function horiHiddenPairs(Solver,i,j)
            % skip if its the last cell in the row
            if j>8
                return
            end
            % for every cell to the right of the current cell
            for J=j+1:1:9
                % find which candidates they have in common
                overlaps=and(Solver.Figure.Board.Candidates(i,j,:),Solver.Figure.Board.Candidates(i,J,:));
                overlaps=squeeze(overlaps);
                % get the numbers that they overlap
                overlapIndices=find(overlaps==1);
                % get how many overlaps there are
                numOverlaps=length(overlapIndices);
                % if there are at least 2
                if numOverlaps>=2 
                    % get pairs of the overlapped numbers
                    for a=1:1:numOverlaps-1
                        for b=a+1:1:numOverlaps
                            % get the current possible pair
                            overlapNums=[overlapIndices(a) overlapIndices(b)];
                            % create a vector representing it as candidates
                            curOverlap=zeros(9,1);
                            curOverlap(overlapNums(1))=1;
                            curOverlap(overlapNums(2))=1;
                            goodNums=true;
                            % increment over all the row
                            for l=1:1:9
                                % skip if its the current cells being compared
                                if l==j || l==J
                                    continue
                                end
                                % get the candidates from the cell being
                                % looked at
                                posCans=squeeze(Solver.Figure.Board.Candidates(i,l,:));
                                % if there is overlap then this pair cannot
                                % be a hidden pair
                                if sum(and(curOverlap,posCans))>0
                                    goodNums=false;
                                    break
                                end
                            end   
                            % if there was no overlap of the pair in the
                            % whole row, then it must be a hidden pair so
                            % remove the remaining candidates
                            if goodNums
                                % gets non pair candidates from the first cell
                                posCans=squeeze(Solver.Figure.Board.Candidates(i,j,:));
                                nonPairNums=find(xor(posCans,curOverlap)==1);
                                % removes them
                                if ~isempty(nonPairNums)
                                    Solver.Figure.removeCans(i,j,nonPairNums)
                                end
                                % gets non pair candidates from the second cell
                                posCans=squeeze(Solver.Figure.Board.Candidates(i,J,:));
                                nonPairNums=find(xor(posCans,curOverlap)==1);
                                % removes them
                                if ~isempty(nonPairNums)
                                    Solver.Figure.removeCans(i,J,nonPairNums)
                                end
                            end
                        end
                    end
                end
            end
        end

        function boxHiddenPairs(Solver,i,j)
            boxHori=floor((i-1)/3);
            boxVert=floor((j-1)/3);
            boxCorner=[boxHori*3+1 boxVert*3+1];
            x=mod(floor(i-1),3);
            y=mod(floor(i-1),3);
            if x==3 && y==3
                return
            end
            for I=boxCorner(1):1:boxCorner(1)+2
                for J=boxCorner(2):1:boxCorner(2)+2
                    % for every cell further in the box of the current cell
                    % find which candidates they have in common
                    overlaps=and(Solver.Figure.Board.Candidates(i,j,:),Solver.Figure.Board.Candidates(I,J,:));
                    overlaps=squeeze(overlaps);
                    % get the numbers that they overlap
                    overlapIndices=find(overlaps==1);
                    % get how many overlaps there are
                    numOverlaps=length(overlapIndices);
                    % if there are at least 2
                    if numOverlaps>=2 
                        % get pairs of the overlapped numbers
                        for a=1:1:numOverlaps-1
                            for b=a+1:1:numOverlaps
                                % get the current possible pair
                                overlapNums=[overlapIndices(a) overlapIndices(b)];
                                % create a vector representing it as candidates
                                curOverlap=zeros(9,1);
                                curOverlap(overlapNums(1))=1;
                                curOverlap(overlapNums(2))=1;
                                goodNums=true;
                                % increment over all the box
                                for X=boxCorner(1):1:boxCorner(1)+2
                                    for Y=boxCorner(2):1:boxCorner(2)+2
                                        % skip if its the current cells being compared
                                        if(x==X && y==Y)||(I==X && J==Y)
                                            continue
                                        end
                                        % get the candidates from the cell being
                                        % looked at
                                        posCans=squeeze(Solver.Figure.Board.Candidates(X,Y,:));
                                        % if there is overlap then this pair cannot
                                        % be a hidden pair
                                        if sum(and(curOverlap,posCans))>0
                                            goodNums=false;
                                            break
                                        end
                                    end
                                end   
                                % if there was no overlap of the pair in the
                                % whole box, then it must be a hidden pair so
                                % remove the remaining candidates
                                if goodNums
                                    % gets non pair candidates from the first cell
                                    posCans=squeeze(Solver.Figure.Board.Candidates(i,j,:));
                                    nonPairNums=find(xor(posCans,curOverlap)==1);
                                    % removes them
                                    if ~isempty(nonPairNums)
                                        Solver.Figure.removeCans(i,j,nonPairNums)
                                    end
                                    % gets non pair candidates from the second cell
                                    posCans=squeeze(Solver.Figure.Board.Candidates(I,J,:));
                                    nonPairNums=find(xor(posCans,curOverlap)==1);
                                    % removes them
                                    if ~isempty(nonPairNums)
                                        Solver.Figure.removeCans(I,J,nonPairNums)
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