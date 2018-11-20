function [w,r,c] = PSO_init(h_nodes,rows,cols,n_p)
  w = rand(1,cols)
  c = rand(h_nodes, cols)
  r = rand(h_nodes, cols)
  
  #{
  for p = 1:n_p
    particles(p).id = p; 
    particles(p).nombre = "nombre de particula";
    particles(p).w = w;
    particles(p).c = c;
    particles(p).r = r;
    particles(p).pbest = intmax;
  endfor
  #}
  
endfunction
