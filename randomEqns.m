function [out] = randomEqns(n)
    text = ""
    for i = 1:n
        for j = 1:n
            if randi(2) == 1
                text = text + "+";
            else
                text = text + "-";
            end
            text = text + num2str(randi(1000)) + "*x" + num2str(j);
        end
        text = text + " = " + num2str(randi(1000));
        if i < n
            text = text + ",";
        end
    end
    out = text;
end
