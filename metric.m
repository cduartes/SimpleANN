function [a, f1, f2] = metric(tp, tn, fp, fn)
  if tp + tn + fp + fn != 0
    a = (tp + tn) / (tp + tn + fp +fn);
  else
    a = 0;
  endif
  if tp + fp != 0
    p1 = tp / (tp + fp);
  else
    p1 = 0;
  endif
  if tp + fn != 0
    r1 = tp / (tp + fn);
  else
    r1 = 0;
  endif
  if p1 + r1 != 0
    f1 = 2 * ((p1 * r1) / (p1 + r1));
  else
    f1 = 0;
  endif
  
  if tn + fn != 0
    p2 = tn / (tn + fn);
  else
    p2 = 0;
  endif
  if tn + fp != 0
    r2 = tn / (tn + fp);
  else
    r2 = 0;
  endif
  if p2 + r2 != 0
    f2 = 2 * ((p2 * r2) / (p2 + r2));
  else
    f2 = 0;
  endif
endfunction