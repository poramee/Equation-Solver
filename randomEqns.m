function [out] = randomEqns(n,mm,mx)
    text = "";
    for i = 1:n
        for j = 1:n
            randNum = randi((mx-mm) + 1) + mm - 1;
            if randNum > 0
                text = text + "+";
            else
                text = text + "-";
            end
            text = text + num2str(randNum) + "*x" + num2str(j);
        end
        randNum = randi((mx-mm) + 1) + mm - 1;
        text = text + " = " + num2str(randNum);
        if i < n
            text = text + ",";
        end
    end
    out = text;
end
