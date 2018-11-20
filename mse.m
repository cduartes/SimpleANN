function [E] = mse(expected,o)
  [rows, cols] = size(expected);
  sum = 0;
  for n = 1:rows
    e_n = expected(i)-o(i);
    sum = sum+(e_n^2);
  endfor
  E = sum/rows;
endfunction
