function [x_train ,y_train, x_test, y_test]= dataset_test_split(M,p_train,rand_flag)
  p_test=1-p_train;
  if(rand_flag==1)
    M =  M(randperm(end),:); 
  endif
  tamano=size(M);
  train_size=round(rows(M)*p_train);
  test_size=round(rows(M)*p_test);
  x_train = M(1:train_size,1:(tamano(2)-1));
  x_test = M((train_size+1):end,1:(tamano(2)-1));
  y_train = M(1:train_size,tamano(2));
  y_test = M((train_size+1):end,tamano(2));
end