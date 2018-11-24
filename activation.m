function [ret] = activation(x_n, r_j, c_j)
  z = ze(x_n, r_j, c_j);
  ret = -z*exp(-0.5*(z.^2));
endfunction

function [z] = ze(x_n, r_j, c_j)
  z = norm((x_n-c_j)/r_j);
endfunction