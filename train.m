function [w,c,r] = train(input,expected,h_nodes,iterations, n_p)
  bestmse = intmax;
  currentmse = intmax;
  
  for p = 1:n_p
    particles(p).id = p; 
    particles(p).nombre = "nombre de particula"; 
  endfor
  
  [rows,cols]=size(input);
  [w,c,r] = PSO_init(h_nodes,rows,cols)
  for iter = 1:iterations
    # input to hidden layer
    z1 = transfer(w, transpose(input), h_nodes, c, r)
    # hidden layer to output layer
    [cols,rows] = size(z1);
    o = zeros(1,rows);
    for o_i=1:rows
      c = rand(1, rows);
      r = rand(1, rows);
      o(o_i) = activation(z1(o_i), c, r, 1);
    endfor
    currentmse = mse(expected,o)
    if currentmse < bestmse
      bestmse = currentmse;
      
    endif
  endfor  
endfunction