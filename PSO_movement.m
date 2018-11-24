function [particles] = PSO_movement(h_nodes, cols, n_particles, particles, col_coef, cog_coef, best_x, inercia)
  # for every particle calculate new position based on inercia and random
  for p = 1:n_particles
    new_vel = particles(p).x+cal_vel(inercia, col_coef, cog_coef, particles(p), best_x);
    new_x = particles(p).x + new_vel;
    particles(p).x = new_x;
  endfor
endfunction

function [vel] = cal_vel(inercia, col_coef, cog_coef, particle, best_x)
  r1 = rand();
  r2 = rand();
  old_vel = particle.vel;
  # new velocity
  vel = inercia*old_vel+r1*col_coef*(particle.xbest-particle.x)+r2*cog_coef*(best_x-particle.x);
endfunction
