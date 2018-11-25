function [sum] = transfer(w, r, c, X, numNodes)
  [rows,cols] = size(X);
  sum = zeros(1,rows);
  for x = 1:rows
    aux = 0;
    for j = 1:numNodes
      x_n = X(x, :);
      c_j = c(j, :);
      r_j = r(j, :);
      w_j = w(j);
      h_n = activation(x_n, r_j, c_j);
      aux=aux+w_j*h_n;
    endfor
    sum(1,x)=aux;
  endfor
endfunction
