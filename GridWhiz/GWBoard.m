classdef GWBoard<handle
% Stores the board for GridWhiz

    properties
        Solutions
        Candidates
    end

    methods
        function obj=GWBoard(board)
            obj.Solutions=board;
            obj.determineCandidates();
        end

        function determineCandidates(obj)
            obj.Candidates=zeros(9,9,9);
            onesRow=ones(1,9);
            for i=1:1:9
                for j=1:1:9
                    if obj.Solutions(i,j)==0
                        obj.Candidates(i,j,:)=onesRow;%[1 1 1 1 1 1 1 1 1];
                    end
                end
            end
        end

        function updateSolutions(obj,i,j,n)
            obj.Solutions(i,j)=n;
        end
        
        function removeCandidates(obj,i,j,n)
            for l=1:1:length(n)
                obj.Candidates(i,j,n(l))=0;
            end
        end

    end
end