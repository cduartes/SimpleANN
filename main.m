# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  
  # Matriz simple
  #{
  load input.mat
  A
  #}
  load train.mat
  A
  
  [rows,cols]=size(A);
  DATASET_class = A(:,cols)
  
  # Feature selection
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
  iterations = 100;
  train_flag = 1;
  n_particles = 20;
  cog_coef = 2;
  col_coef = 2;
  best_fit = intmax;
  mse_log = zeros(1,iterations);
  w_max = 0.95;
  w_min = 0.1;
  particles = PSO_init(h_nodes,cols-1,n_particles);
  # inicializar PSO una vez
  if train_flag
    for i = 1:iterations
      for p = 1:n_particles
        w = particles(p).x(:,1);
        r = particles(p).x(:,2:cols);
        c = particles(p).x(:,cols+1:end);
        o = train(w, r, c, DATASET_input, h_nodes);
        current_fit = mse(DATASET_class, transpose(o));
        # comparar cognitivo de particula -> setear el mejor de particula
        if current_fit < particles(p).pbest
          particles(p).pbest = current_fit;
          particles(p).xbest = cat(2,w,r,c);
          # comparar colectivo de enjambre -> setear el mejor de enjambre
          if current_fit < best_fit
            best_fit = current_fit;
            best_x = particles(p).xbest;
          endif
        endif
      endfor
      mse_log(i) = best_fit;
      # mover particulas de acuerdo a evaluación
      inercia = cal_inercia(w_max, w_min, iterations, i);
      particles = PSO_movement(h_nodes, cols, n_particles, particles, col_coef, cog_coef, best_x, inercia);
    endfor
    best_w = best_x(:,1);
    best_r = best_x(:,2:cols);
    best_c = best_x(:,cols+1:end);
  endif
  testing_flag = 1;
  
  
  # DATA_test = [1,1,0;1,1,0]
  
  load test.mat
  DATA_test
  
  
  if testing_flag
    o = train(best_w, best_r, best_c, DATA_test, h_nodes);
    [rows,cols] = size(o);
    for o_i = 1:cols
      disp(sign(o(o_i)))
    endfor
    DATASET_class
  endif
  f_plot(iterations, mse_log);
endfunction

function f_plot(iterations, mse_log)
  x = 1:1:iterations;
  plot (x, mse_log(x));
  xlabel ("x");
  ylabel ("sin (x)");
  title ("Simple 2-D Plot");
endfunction
