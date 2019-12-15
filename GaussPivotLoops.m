function [b_out] = GaussPivotLoops(A,b)
    [Ai,Aj] = size(A);

    for j = 1:Aj
        A(j:end,j:end);
        b(j:end,j:end);
        piv = Pivot(A(j:end,j:end));
        A(j:end,j:end) = piv*A(j:end,j:end);
        b(j:end,1) = piv*b(j:end,1);
        for i = j + 1:Ai
            A(i,j) = A(i,j) / A(j,j);
            for a = j + 1:Aj
                A(i,a) = A(i,a) - (A(i,j)*A(j,a));
            end
            b(i,1) = b(i,1) - (A(i,j)*b(j,1));
        end
    end
    [A,b] = BackwardSubLoops(A,b);
    b_out = b;
end