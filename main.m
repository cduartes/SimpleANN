# author: Cristian Duartes
# Simple Feed Forward Neural Network with PSO for optimal weights

function main(argv="")
  clc
  disp("Artificial Neural Network")
  
  # Control's flags
  train_flag = 1;     # 1 to activate training; 0 to deactivate
  testing_flag = 0;   # 1 to activate testing; 0 to deactivate
  
  # Parameters
  
  h_nodes = 1;          # number of hidden layers
  
  iterations = 1;     # swarm iterations
  n_particles = 1;     # particle's amount
  
  # cognitive + colective <= 4
  cog_coef = 1.655;     # cognitive coef
  col_coef = 1.655;     # colective coef
  
  # inertia values
  w_max = 0.35;         # Max inertia
  w_min = 0.05;         # Min inertia
  
  ########## Carga de archivos ##########
  #NOTA: Los archivos de entrada se asumen separados, pero se unen para funcionar
  
  input_train_file = "InputTrn.txt";
  output_train_file = "OutpuTrn.txt";
  input_test_file = "InputTst4.txt";
  output_test_file = "OutpuTst4.txt";
  sep = ";";
  
  train_dataset = convert(input_train_file, output_train_file, sep); # convertion to matrix and union
  [rows, cols]=size(train_dataset);
  train_y = train_dataset(:, cols);
  
  test_dataset = convert(input_test_file, output_test_file, sep); # convertion to matrix and union
  [rows_test, cols_test] = size(test_dataset);
  test_y = test_dataset(:, cols_test);
  
  printf("->start time: %s\n",strftime ("%H:%M:%S", localtime (time())))
  printf(" Parameters\n")
  printf("  PSO\n")
  printf("   iter = %d n = %d cog = %f col = %f\n", iterations, n_particles, cog_coef, col_coef)
  printf("   w_max = %f w_min = %f\n", w_max, w_min)
  printf("  Hidden nodes: %d \n\n", h_nodes)
  
  printf(" training dataset size: %d %d\n", size(train_dataset))
  printf(" testing dataset size: %d %d\n\n", size(test_dataset))
  

  ##### Selecci�n de caracteristicas ####
  # argv es el archivo donde est�n las caracteristicas seleccionadas
  if length(argv)>0
    printf("File: %s\n", argv)
    fid = fopen (argv, 'r');
    txt = fgetl (fid);
    dataColumns = strsplit(txt, " ");
    printf(" Selected features: %d\n", length(dataColumns))
    g = sprintf('%s ', dataColumns{});
    printf(' Features: %s\n', g)
    train_x = zeros(rows, length(dataColumns));
    test_x = zeros(rows_test, length(dataColumns));
    a=1;
    for c = 1:length(dataColumns)
      for r = 1:rows
        train_x(r, a) = train_dataset(r, c);
      endfor
      
      for r = 1:rows_test
        test_x(r, a) = test_dataset(r, c);
      endfor
      a++;
    endfor
    
    printf(" training dataset size: %d %d\n", size(train_x)+[0,1])
    printf(" testing dataset size: %d %d\n\n", size(test_x)+[0,1])
    cols = length(dataColumns)+1;
  else
    train_x = train_dataset(:, 1:end-1);
    test_x = test_dataset(:, 1:end-1);
  endif
  
  ########### Entrenamiento ##########
  #NOTA: Recibe set de entrenamiento separado en
  # train_x: set de caracteristicas de training
  # train_y: set de clases de training
  # cols: cantidad de caracteristicas del dataset
  # n_particles: cantidad de particulas del enjambre
  # iterations: cantidad de iteraciones
  # h_nodes: cantidad de nodos ocultos
  
  [start_time, user, system] = cputime();
  mse_log = zeros(1, iterations);
  best_fit = intmax;
  
  particles = PSO_init(h_nodes,cols-1,n_particles);
  if train_flag
    [start_training, user, system] = cputime();
    printf("Training stage...\n")
    for i = 1:iterations
      for p = 1:n_particles
        # separate particle's position
        w = particles(p).x(:, 1);
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
    
    f_plot(iterations, mse_log);
    
    printf(" weights saved, now ploting...\n")
    [end_training, user, system] = cputime();
    printf(" training time: %fs\n\n", end_training-start_training)
  endif
  
  ############### Pruebas #############
  #NOTA: recibe parametros de
  # test_x: set de caracteristicas de testing
  # test_y: set de clases de testing
  # best_w: vector de pesos, primera columna de la matriz de pesos
  # best_r: matriz de pesos radios,
  #        columnas 2 hasta D (cantidad de caracteristicas) de matriz de pesos
  # best_c: matriz de pesos centros, 
  #        desde D (cantidad de caracteristicas) + 1 hasta final de matriz de pesos
  # h_nodes: nodos ocultos, obtenido de las filas de matriz de pesos
  
  if testing_flag
    [start_testing, user, system] = cputime();
    tp = 0;
    tn = 0;
    fp = 0;
    fn = 0;
    
    # carga de pesos desde archivo mat
    [rows, cols] = size(test_x);
    load weights1.mat
    best_x;
    best_w = best_x(:,1);
    h_nodes = size(best_w)(1);
    best_r = best_x(:, 2:cols+1);
    best_c = best_x(:, cols+2:end);
    
    printf(" Hidden nodes: %d \n", h_nodes)
    printf(" Features: %d \n", cols)
    printf("Testing stage...\n")

    o = feedforward(best_w, best_r, best_c, test_x, h_nodes);
    [rows, cols] = size(o);
    compare = zeros(1,cols);
    for o_i = 1:cols
      [tp, tn, fp, fn] = confusion(tp, tn, fp, fn, sign(o(o_i)), test_y(o_i));
      compare(o_i) = sign(o(o_i));
    endfor
    
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
    
    [end_testing, user, system] = cputime();
    printf(" testing time: %fs\n\n", end_testing-start_testing)
  endif
  
  [end_time, user, system] = cputime();
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

