function concatenate()
  load InputTrn.mat
  matrix_etl;
  A = matrix_etl;
  load OutputTrn.mat
  matrix_etl;
  B = matrix_etl;
  
  inputTrain = cat(2,A,B)
  
  save inputTrain.mat matrix_etl;
endfunction