# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  
  # Behavior flags
  train_flag = 1;   # 
  testing_flag = 1; # 
  split_flag = 0;   # split single file for training and testing
  
  # Parameters
  
  h_nodes = 7;      # number of hidden layers
  
  iterations = 100;  # swarm iterations
  n_particles = 20;  # particle's amount
  
  # cognitive + colective <= 4
  cog_coef = 1.7;     # jugar con esto
  col_coef = 1.7;     # jugar con esto
  
  # inertia values
  w_max = 0.300;      # jugar con esto
  w_min = 0.020;    # jugar con esto
  
  mse_log = zeros(1,iterations);
  best_fit = intmax;
  
  # load files
  x_file = "InputTrn.txt";
  y_file = "OutpuTrn.txt";
  sep = ";";
  input = convert(x_file, y_file, sep);
  x_file = "InputTst.txt";
  y_file = "OutpuTst.txt";
  output = convert(x_file, y_file, sep);
  
  
  printf("->start time: %s\n",strftime ("%H:%M:%S", localtime (time())))
  printf(" Parameters\n")
  printf("  PSO\n")
  printf("   iter = %d n = %d cog = %f col = %f\n", iterations, n_particles, cog_coef, col_coef)
  printf("   w_max = %f w_min = %f\n", w_max, w_min)
  printf("  Hidden nodes: %d \n\n", h_nodes)
  
  printf(" input size: %d %d\n", size(input))
  printf(" output size: %d %d\n\n", size(output))
  
  if split_flag
    #train_x ,train_y, test_x, test_y
    p_train = 0.5;
    rand_flag = 1;  # randomly arranged rows
    [A, DATASET_class, DATA_test, DATA_class] = dataset_test_split(train_dataset, p_train, rand_flag);
  endif
  [rows,cols]=size(input);
  train_y = input(:,cols);
  
  # Feature manual selection from file
  if length(argv)>0
    printf("Archivo de configuracion: %s\n",argv)
    fid = fopen (argv, 'r');
    txt = fgetl (fid);
    dataColumns = strsplit(txt, " ");
    printf(" Caracteristicas seleccionadas: %d\n", length(dataColumns))
    g=sprintf('%s ', dataColumns{});
    printf(' Caracteristicas: %s\n', g)
    train_x = zeros(rows,length(dataColumns));
    a=1;
    for c = 1:length(dataColumns)
      for r = 1:rows
        train_x(r,a) = input(r,c);
      endfor
      a++;
    endfor
  else
    train_x = input(:,1:cols-1);
  endif
  
  [total, user, system] = cputime();
  start_time = total;
  
  # PSO initialization
  particles = PSO_init(h_nodes,cols-1,n_particles);
  if train_flag
    for i = 1:iterations
      for p = 1:n_particles
        # separate particle's position
        w = particles(p).x(:,1);
        r = particles(p).x(:, 2:cols);
        c = particles(p).x(:, cols+1:end);
        # train the model
        o = train(w, r, c, train_x, h_nodes); # feed-forward method
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

  test_x = output(:,1:end-1);
  train_y = output(:,end);
  
  tp = 0;
  tn = 0;
  fp = 0;
  fn = 0;
  
  if testing_flag
    o = train(best_w, best_r, best_c, test_x, h_nodes);
    [rows,cols] = size(o);
    compare = zeros(1,cols);
    for o_i = 1:cols
      [tp, tn, fp, fn] = confusion(tp, tn, fp, fn, sign(o(o_i)), train_y(o_i));
      compare(o_i) = sign(o(o_i));
    endfor
  endif
  
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
  
  #end_time = now();
  [total, user, system] = cputime();
  end_time = total;
  printf(" testing time: %fs\n", end_time-end_training)
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

