function [w,c,r] = train(weights,DATASET, h_nodes, c, r)
  
  # input to hidden layer
  z1 = transfer(weights, transpose(DATASET), h_nodes, c, r)
  # hidden layer to output layer
  [cols,rows] = size(z1);
  o = zeros(1,rows);
  for o_i=1:rows
    c = rand(1,rows);
    r = rand(1,rows);
    o(o_i) = activation(z1(o_i), c, r, 1);
  endfor
endfunction