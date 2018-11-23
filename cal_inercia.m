function [w] = cal_inercia(w_max, w_min, iterations, i)
  w = w_max - (((w_max - w_min)/iterations)*i);
endfunction