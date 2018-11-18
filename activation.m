function [ret] = activation(x_n, c, r, j)
  c_j = c(:,j);
  r_j = r(:,j);
  z = ze(x_n,c_j,r_j);
  ret = -z*exp(-0.5*(z.^2));
endfunction

function [z] = ze(x_n, c_j, r_j)
  z = norm((x_n-c_j)/r_j);
endfunction