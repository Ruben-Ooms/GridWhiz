classdef GWSolver<handle


    properties
        Figure
        Solvable
        Difficulty
    end

    methods
        
        function obj=GWSolver(figureHandel)
            obj.Figure=figureHandel;
            obj.Difficulty=0;
        end

        function solve(obj)
            numCans=sum(obj.Figure.Board.Candidates,"all");

            obj.singles();
            if sum(obj.Figure.Board.Candidates,"all")<numCans
                disp("SINGLES")
                obj.Difficulty=obj.Difficulty+2;
                return
            end

            obj.obviousPairs();
            if sum(obj.Figure.Board.Candidates,"all")<numCans
                disp("OBVIOUS PAIRS")
                obj.Difficulty=obj.Difficulty+3;
                return
            end

            obj.hiddenPairs();
            if sum(obj.Figure.Board.Candidates,"all")<numCans
                disp("HIDDEN PAIRS")
                obj.Difficulty=obj.Difficulty+4;
                return
            end

            obj.obviousTriples();
            if sum(obj.Figure.Board.Candidates,"all")<numCans
                disp("OBVIOUS TRIPLES")
                obj.Difficulty=obj.Difficulty+5;
                return
            end

disp("NOT POSSIBLE WITHOUT MORE TECHNIQUES")
            obj.Solvable=false;
        end

        function difficulty=getDifficulty(obj)
            difficulty=obj.Difficulty;
        end

        function increaseDifficulty(obj,n)
            obj.Difficulty=obj.Difficulty+n;
        end

        function last(obj)
            Last.last(obj)
            obj.Figure.checkResize();
        end
        
        function singles(obj)
            Singles.singles(obj)
        end

        function obviousPairs(obj)
            ObviousPairs.obviousPairs(obj)
        end

        function hiddenPairs(obj)
            HiddenPairs.hiddenPairs(obj);
        end


        function obviousTriples(obj)
            ObviousTriples.obviousTriples(obj);
        end

    end
end