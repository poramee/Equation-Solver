function [outA,outb] = BackwardSubLoops(A,b)
     [Ax,Ay] = size(A);
     [bx,by]=  size(b);
     
     i = Ax;
     while i >= 1
         temp = 0;
         for j = i + 1:Ay
             temp = temp + (A(i,j) * b(j,1));
             A(i,j) = 0;
         end
         b(i,1) = (b(i,1) - temp)/A(i,i);
         A(i,i) = 1;
         i = i - 1;
     end
     outA = A;
     outb = b;
end