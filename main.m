# author: Cristian Duartes
function main(argv="")
  clc
  disp("Artificial Neural Network")
  
  # Behavior flags
  train_flag = 1;
  testing_flag = 1;
  
  # Parameters
  
  h_nodes = 3; #number of hidden layers
  
  iterations = 100; # swarm iterations
  n_particles = 25; # particle's amount
  
  # cog_coef + col_coef <= 4
  cog_coef = 1.4; # jugar con esto
  col_coef = 2.6; # jugar con esto
  
  # inertia values
  w_max = 0.3; # jugar con esto
  w_min = 0.001; # jugar con esto
  
  mse_log = zeros(1,iterations);
  best_fit = intmax;
  
  # Load a simple matrix
  
  #load input.mat
  #A
  
  # Load the real matrix
  
  load train.mat
  train_dataset;
  A = train_dataset;
  
  [rows,cols]=size(A);
  DATASET_class = A(:,cols);
  
  # Feature manual selection from file
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
  
  # clock
  start_time = now();
  
  # PSO initialization
  particles = PSO_init(h_nodes,cols-1,n_particles);
  if train_flag
    for i = 1:iterations
      for p = 1:n_particles
        # separate particle's position
        w = particles(p).x(1,:);
        r = particles(p).x(2:h_nodes+1,:);
        c = particles(p).x(h_nodes+2:end,:);
        # train the model
        o = train(w, r, c, DATASET_input, h_nodes);
        # evaluate
        current_fit = mse(DATASET_class, o);
        # compare particle's cognitive value and save the local best
        if current_fit < particles(p).pbest
          particles(p).pbest = current_fit;
          particles(p).xbest = cat(1,w,r,c);
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
    best_w = best_x(1, :);
    best_r = best_x(2:h_nodes+1, :);
    best_c = best_x(h_nodes+2:end, :);
  endif
  
  end_training = now();
  printf(" training time: %f\n", end_training-start_time)
  
  # Simple test matrix
  #DATA_test = [1, 1, 0, 0; 1, 1, 0, 0]
  
  # The real test matrix
  load test.mat
  test_dataset;
  DATA_test = test_dataset(:,1:end-1)
  
  if testing_flag
    o = train(best_w, best_r, best_c, DATA_test, h_nodes)
    [rows,cols] = size(o);
    for o_i = 1:cols
      disp(sign(o(o_i)))
    endfor
  endif
  f_plot(iterations, mse_log);
  
  end_time = now();
  printf(" testing time: %f\n", end_time-end_training)
  [total, user, system] = cpu_time = cputime();
  printf(" cpu time: %f\n", total)
endfunction

function f_plot(iterations, mse_log)
  x = 1:1:iterations;
  plot (x, mse_log(x));
  xlabel ("x");
  ylabel ("sin (x)");
  title ("Simple 2-D Plot");
endfunction
