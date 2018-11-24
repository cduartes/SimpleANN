function [p, f] = metric(tp, fp, fn)
  if tp + fp != 0
    p = tp / (tp + fp);
  else
    p = 0;
  endif
  if tp + fn != 0
    r = tp / (tp + fn);
  else
    r = 0;
  endif
  if p + r != 0
    f = 2 * ((p * r) / (p + r));
  else
    f = 0;
  endif
endfunction