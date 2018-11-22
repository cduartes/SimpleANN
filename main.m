# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  load input.mat
  A
  [rows,cols]=size(A);
  DATASET_class = A(:,cols)
  
  # column selection
  if length(argv)>0
    printf("Archivo de configuracion: %s\n",argv)
    fid = fopen (argv, 'r');
    txt = fgetl (fid);
    dataColumns = strsplit(txt, " ");
    printf(" Caracteristicas seleccionadas: %d\n", length(dataColumns))
    g=sprintf('%s ', dataColumns{});
    printf(' Caracteristicas: %s\n', g)
    DATASET_input = zeros(rows,length(dataColumns));
    a=1;
    for c = 1:length(dataColumns)
      for r = 1:rows
        DATASET(r,a) = A(r,c);
      endfor
      a++;
    endfor
  else
    DATASET_input = A(:,1:cols-1);
    
  endif
  
  DATASET_input
  
  # Parameters
  h_nodes = 3;
  iterations = 5;
  train_flag = 1;
  n_particles = 1;
  best_mse = intmax;
  [w,r,c] = PSO_init(h_nodes,cols-1,n_particles)
  #{
  for p = 1:n_particles
    particles(p).id = p; 
    particles(p).nombre = "nombre de particula";
    particles(p).x = 1;
    particles(p).pbest = intmax;
  endfor
  #}
  #[w,r,c] = PSO_init(h_nodes,cols,n_particles,particles)
  # inicializar PSO una vez
  if train_flag
    for i = 1:iterations
      for p = 1:n_particles
        o = train(w, r, c, DATASET_input, h_nodes)
        current_mse = mse(DATASET_class,transpose(o));
        if current_mse < best_mse
          best_mse = current_mse;
          best_w = w;
          best_c = c;
          best_r = r;
        endif
        # comparar cognitivo de particula -> setear el mejor local
      endfor
      # comparar colectivo -> setear el mejor de enjambre
      # mover particulas de acuerdo a evaluación
      [w,r,c] = PSO_movement(h_nodes,cols,n_particles)
    endfor
    best_mse
    best_w
    best_c
    best_r
  endif
  testing_flag = 1;
  DATA_test = [0,0,1]
  pause
  if testing_flag
    o = train(best_w, best_r, best_c, DATA_test, h_nodes)
    [rows,cols] = size(o);
    for o_i = rows
      disp(sign(o(o_i)))
    endfor
  endif
endfunction