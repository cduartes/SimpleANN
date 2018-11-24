function [tp, tn, fp, fn] = confusion(tp, tn, fp, fn, p, t)
  #{
  tp: true positive
  tn: true negative
  fp: false positive
  fn: false negative
  p: predicted
  t: true
  #}
  if p == 1
    if t == 1
      tp = tp + 1;
    elseif t == -1
      fp = fp + 1;
    endif
  elseif p == -1
    if t == 1
      fn = fn + 1;
    elseif t == -1
      tn = tn + 1;
    endif
  endif
endfunction