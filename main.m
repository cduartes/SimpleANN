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
  w = rand(1,cols)
  c = rand(h_nodes, cols)
  r = rand(h_nodes, cols)
  if train
    (w,c,r) = train(w,DATASET, h_nodes, c, r)
  endif
endfunction