function [out] = eqnmat2str(tb,vars)
    tbsize = size(tb);
    [dummy,varsSize] = size(vars);
    ansText = '';
    vars = char(vars);
    if varsSize > 1
        vars([1:9, end-2:end]) = [];
    end
    vars = split(vars,', ');

    for i = 1:tbsize
        ansText = strcat(ansText,convertCharsToStrings(vars(i,:)));
        ansText = strcat(ansText," = ");
        ansText = ansText + num2str(tb(i)) + newline;
    end
    out = ansText;
end