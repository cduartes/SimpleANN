function [tp, tn, fp, fn] = confusion(tp, tn, fp, fn, p, t)
  #{
  tp: true positive
  tn: true negative
  fp: false positive
  fn: false negative
  p: predicted
  t: true
  #}
  
  #Si predecimos ataque
  if p == -1
    #Y si en verdad es ataque
    if t == -1
      #Es true positive
      tp = tp + 1;
    #Y si en verdad es normal
    elseif t == 1
      #Es false positive
      fp = fp + 1;
    endif
  #Si predecimos normal
  elseif p == 1
    #Y si en verdad es ataque
    if t == -1
      #Es false negative
      fn = fn + 1;
    #Y si en verdad es normal
    elseif t == 1
      #Es true negative
      tn = tn + 1;
    endif
  endif
endfunction