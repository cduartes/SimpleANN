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
    DATASET_input = A(:,1:cols-1);
    DATASET_class = A(:,cols)
  endif
  DATASET_input
  # Parameters
  h_nodes = 3;
  iterations = 2;
  train_flag = 1;
  if train_flag
    [w,c,r] = train(DATASET_input,h_nodes,iterations,5)
  endif
  w
  c
  r
endfunction