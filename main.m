# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  load input.mat
  A
  [rows,cols]=size(A);
  # column selection
  if length(argv)>0
    printf("Archivo de configuracion: %s\n",argv)
    fid = fopen (argv, 'r');
    txt = fgetl (fid);
    dataColumns = strsplit(txt, " ");
    printf(" Caracteristicas seleccionadas: %d\n", length(dataColumns))
    g=sprintf('%s ', dataColumns{});
    printf(' Caracteristicas: %s\n', g)
    DATASET = zeros(rows,length(dataColumns));
    a=1;
    for c = 1:length(dataColumns)
      for r = 1:rows
        DATASET(r,a) = A(r,c);
      endfor
      a++;
    endfor
  else
    DATASET = A;
  endif
  DATASET
  [rows,cols]=size(DATASET);

  # Parameters
  h_nodes = 3;
  iterations = 1;
  weights = rand(1,cols)
  c = rand(h_nodes, cols)
  r = rand(h_nodes, cols)
  clc
  # input to hidden layer
  z1 = transfer(weights, transpose(DATASET), h_nodes, c, r)
  # hidden layer to output layer
  [cols,rows] = size(z1)
  o = zeros(1,rows)
  pause
  for o_i=1:rows
    c = rand(1,rows);
    r = rand(1,rows);
    o(o_i) = activation(z1(o_i), c, r, 1)
  endfor
  pause
  [cols,rows] = size(o);
  for o_i=1:rows
    fprintf(" Result: %d\n", sign(o(o_i)))
  endfor
endfunction