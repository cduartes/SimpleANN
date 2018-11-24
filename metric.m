function [p, f] = metric(tp, fp, fn)
  p = tp / (tp + fp);
  r = tp / (tp + fn);
  f = 2 * ((p * r) / (p + r));
endfunction