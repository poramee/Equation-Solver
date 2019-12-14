function [eqn,RHS,LHS,vars] = inputProcessor(input)
   inputMat = split(input,',');
   eqnSize = size(inputMat);
   tempExp = [];
   for i = 1:eqnSize
       tempExp = [tempExp str2sym(inputMat{i})];
   end
   [eqnMatRHS,eqnMatLHS] = equationsToMatrix(tempExp);
   variables = symvar(tempExp);
   eqn = tempExp;
   RHS = double(eqnMatRHS);
   LHS = double(eqnMatLHS);
   vars = variables;
end