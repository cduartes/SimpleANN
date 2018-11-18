function [sum] = transfer(weight, X, numNodes, c, r)
  [rows,cols] = size(X);
  sum=zeros(1,cols);
  for x = 1:cols
    aux = 0;
    for j = 1:numNodes
      w_j=weight(j);
      h_n = activation(X(:,x), c, r, j);
      aux=aux+w_j*h_n;
    endfor
    sum(1,x)=aux;
  endfor
endfunction
