#main function
function convert()
  file = fopen ("OutpuTst.txt", "r");
  array = strsplit(fgets(file), ";");
  cols = length(array);
  c = 0;
  
  #read file
  while (! feof (file))
    c = c+1;
    if c == 1
      new_line = cell2Double(array,cols);
      matrix_etl = new_line;
    else
      line = fgets(file);
      A = strsplit(line, ";");
      new_line=cell2Double(A, cols);
      new_line;
      matrix_etl = vertcat(matrix_etl, new_line);
    endif
  endwhile
  #save matrix
  save OutpuTst.mat matrix_etl;
endfunction


#function convert element cell to double element
function [retval] = cell2Double( cellArray, cols )
  contador=1;
  doubleArray=zeros(1,cols);
  
  while(contador < cols+1)
    doubleArray(1,contador)=str2double(cellArray{1,contador});        
    contador++;
  endwhile
  retval=doubleArray;
endfunction
 
      