function [out] = Pivot(a)
    [si,sj] = size(a);
    outMat = eye(si);
    if a(1,1) == 0
        for i = 2:si
            if a(i,1) ~= 0
                temp = outMat(1,:);
                outMat(1,:) = outMat(i,:);
                outMat(i,:) = temp;
                break
            end
        end
    end
    out = outMat;
end