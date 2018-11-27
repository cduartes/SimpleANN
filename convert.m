function [dataset] = convert(x_file, y_file, separator)
  x = txt_to_matrix(x_file, separator);
  y = txt_to_matrix(y_file, separator);
  dataset = cat(2, x, y);
endfunction
      