function [o] = train(w, r, c, input, h_nodes)
  currentmse = 0;
  [rows,cols]=size(input);
  # input to hidden layer
  z1 = transfer(w, r, c, input, h_nodes);
  # hidden layer to output layer
  #{
  [cols,rows] = size(z1);
  o = zeros(1,rows);
  for o_i=1:cols
    o(o_i) = activation(z1(o_i), r_j, c_j);
  endfor
  #}
  o = z1;
endfunction