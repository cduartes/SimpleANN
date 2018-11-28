# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  
  # Control's flags
  train_flag = 1;     # 1 to activate training; 0 to deactivate
  testing_flag = 1;   # 1 to activate testing; 0 to deactivate
  
  # Parameters
  
  h_nodes = 7;       # number of hidden layers
  
  iterations = 30;    # swarm iterations
  n_particles = 8;    # particle's amount
  
  # cognitive + colective <= 4
  cog_coef = 1.8;     # cognitive coef
  col_coef = 2.2;     # colective coef
  
  # inertia values
  w_max = 0.35;       # Max inertia
  w_min = 0.035;      # Min inertia
  
  mse_log = zeros(1,iterations);
  best_fit = intmax;
  
  ########## Carga de archivos ##########
  
  x_file = "InputTrn.txt";
  y_file = "OutpuTrn.txt";
  sep = ";";
  train_dataset = convert(x_file, y_file, sep); # convertion to matrix and union
  x_file = "InputTst.txt";
  y_file = "OutpuTst.txt";
  test_dataset = convert(x_file, y_file, sep); # convertion to matrix and union
  
  printf("->start time: %s\n",strftime ("%H:%M:%S", localtime (time())))
  printf(" Parameters\n")
  printf("  PSO\n")
  printf("   iter = %d n = %d cog = %f col = %f\n", iterations, n_particles, cog_coef, col_coef)
  printf("   w_max = %f w_min = %f\n", w_max, w_min)
  printf("  Hidden nodes: %d \n\n", h_nodes)
  
  printf(" training dataset size: %d %d\n", size(train_dataset))
  printf(" testing dataset size: %d %d\n\n", size(test_dataset))
  
  [rows, cols]=size(train_dataset);
  train_y = train_dataset(:, cols);
  
  [rows_test, cols_test] = size(test_dataset);
  test_y = test_dataset(:, cols_test);
  
  ##### Selección de caracteristicas ####
  # argv es el archivo donde están las caracteristicas seleccionadas
  if length(argv)>0
    printf("Archivo de configuracion: %s\n",argv)
    fid = fopen (argv, 'r');
    txt = fgetl (fid);
    dataColumns = strsplit(txt, " ");
    printf(" Selected features: %d\n", length(dataColumns))
    g=sprintf('%s ', dataColumns{});
    printf(' Features: %s\n', g)
    train_x = zeros(rows, length(dataColumns));
    test_x = zeros(rows_test, length(dataColumns));
    a=1;
    for c = 1:length(dataColumns)
      for r = 1:rows
        train_x(r,a) = train_dataset(r,c);
      endfor
      
      for r = 1:rows_test
        test_x(r,a) = test_dataset(r,c);
      endfor
      a++;
    endfor
    
    printf(" training dataset size: %d %d\n", size(train_x)+[0,1])
    printf(" testing dataset size: %d %d\n\n", size(test_x)+[0,1])
    cols = length(dataColumns)+1;
  else
    train_x = train_dataset(:,1:cols-1);
    test_x = test_dataset(:,1:end-1);
  endif
  
  [total, user, system] = cputime();
  start_time = total;
  
  
  ########### Entrenamiento ##########
  #NOTA: Recibe set de entrenamiento separado en
  # train_x: set de caracteristicas de training
  # train_y: set de clases de training
  
  particles = PSO_init(h_nodes,cols-1,n_particles);
  if train_flag
    for i = 1:iterations
      for p = 1:n_particles
        # separate particle's position
        w = particles(p).x(:,1);
        r = particles(p).x(:, 2:cols);
        c = particles(p).x(:, cols+1:end);
        # train the model
        o = feedforward(w, r, c, train_x, h_nodes); # feed-forward method
        # evaluate
        current_fit = mse(train_y, o);
        # compare particle's cognitive value and save the local best
        if current_fit < particles(p).pbest
          particles(p).pbest = current_fit;
          particles(p).xbest = cat(2, w, r, c);
          # compare swarm's colective value and save the best one
          if current_fit < best_fit
            best_fit = current_fit;
            best_x = particles(p).xbest;
          endif
        endif
      endfor
      mse_log(i) = best_fit; # save historic data
      
      # move particles
      inercia = cal_inercia(w_max, w_min, iterations, i);
      particles = PSO_movement(h_nodes, cols, n_particles, particles, col_coef,
          cog_coef, best_x, inercia);
    endfor
    save weights.mat best_x
    best_w = best_x(:,1);
    best_r = best_x(:, 2:cols);
    best_c = best_x(:, cols+1:end);
  else
    load weights.mat
    best_x
    best_w = best_x(:,1);
    best_r = best_x(:, 2:cols);
    best_c = best_x(:, cols+1:end);
  endif
  
  [total, user, system] = cputime();
  end_training = total;
  printf(" training time: %fs\n\n", end_training-start_time)
  
  ############### Pruebas #############
  #NOTA: recibe parametros de
  # test_x: set de caracteristicas de testing
  # test_y: set de clases de testing
  # best_w: vector de pesos
  # best_r: matriz de pesos radios
  # best_c: matriz de pesos centros
  
  tp = 0;
  tn = 0;
  fp = 0;
  fn = 0;
  
  if testing_flag
    o = feedforward(best_w, best_r, best_c, test_x, h_nodes);
    [rows,cols] = size(o);
    compare = zeros(1,cols);
    for o_i = 1:cols
      [tp, tn, fp, fn] = confusion(tp, tn, fp, fn, sign(o(o_i)), train_y(o_i));
      compare(o_i) = sign(o(o_i));
    endfor
  endif
  
  #### Impresion de resultados ####
  [a, f1, f2] = metric(tp, tn, fp, fn);
  printf(" True Positive: %d\n", tp)
  printf(" True Negative: %d\n", tn)
  printf(" False Positive: %d\n", fp)
  printf(" False Negative: %d\n", fn)
  printf(" accuracy: %f\n", a)
  printf(" f-score ataque: %f\n", f1) 
  printf(" f-score normal: %f\n", f2) 
 
  save result.mat compare
  
  f_plot(iterations, mse_log);

  [total, user, system] = cputime();
  end_time = total;
  printf(" testing time: %fs\n\n", end_time-end_training)
  printf(" total time: %fs\n", end_time-start_time)
  printf("->finish time: %s\n", strftime("%H:%M:%S", localtime(time())))
endfunction

function f_plot(iterations, mse_log)
  x = 1:1:iterations;
  plot (x, mse_log(x));
  xlabel ("Iteration");
  ylabel ("MSE");
  title ("2-D Plot for MSE/Iteration");
endfunction

