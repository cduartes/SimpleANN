function [w,r,c] = PSO_movement(h_nodes,cols,n_particles)
  w = rand(1,cols)
  r = rand(h_nodes, cols)
  c = rand(h_nodes, cols)
endfunction
