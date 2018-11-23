function [particles] = PSO_init(h_nodes,cols,n_p)
  for p = 1:n_p
    particles(p).id = p; 
    w = rand(cols, 1);
    r = rand(h_nodes, cols);
    c = rand(h_nodes, cols);
    particles(p).x = cat(2, w, r, c);
    particles(p).xbest = particles(p).x;
    particles(p).pbest = intmax;
    particles(p).vel = rand(h_nodes, cols*2+1);
  endfor
endfunction
