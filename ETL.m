#main function
function ETL
  file = fopen ("KDDTest.txt", "r");
  array = strsplit(fgets(file), ",");
  cols = length(array)-1;
  c = 0;
  
  #read file
  while (! feof (file))
    c = c+1;
    if c == 1
      new_line = cell2Double(array,cols);
      matrix_etl = new_line;
    else
      line = fgets(file);
      A = strsplit(line, ","); 
      new_line=cell2Double(A, cols);
      new_line;
      matrix_etl = vertcat(matrix_etl, new_line);
    endif
  endwhile
  
  #Normalization DataSet
  [x,y] = size(matrix_etl);
  max_num = intmin;
  min_num = intmax;
  
  for i = 1:1:x
    for j = 1:1:y-1
      if matrix_etl(i,j) > max_num
        max_num = matrix_etl(i,j);
      endif
      
      if matrix_etl(i,j) < min_num
        min_num = matrix_etl(i,j);
      endif
    endfor
  endfor 
  matrix_first_norm = matrix_etl;
  for i = 1:1:x
    for j = 1:1:y-1
      matrix_first_norm(i,j) = (matrix_first_norm(i,j) - min_num)/(max_num - min_num);
    endfor
  endfor
  
  matrix_second_norm = matrix_first_norm;
  a = 0.1;
  b = 0.95;
  for i = 1:1:x
    for j = 1:1:y-1
      matrix_second_norm(i,j) = (b-a)*matrix_second_norm(i,j) + a;
    endfor
  endfor
  
  #save matrix
  save matrix_etl.mat matrix_etl;
  save matrix_second_norm_test.mat matrix_second_norm;
endfunction


#function convert element cell to double element
function [retval] = cell2Double( cellArray, cols )
  contador=1;
  doubleArray=zeros(1,cols);
  
  while(contador < cols+1)
    switch(contador)
      case 2
        if strcmp(cellArray{1,contador},"tcp") == 1
          doubleArray(1,contador)=1;
        endif
        if strcmp(cellArray{1,contador},"udp") == 1
          doubleArray(1,contador)=2;
        endif
        if strcmp(cellArray{1,contador},"icmp") == 1
          doubleArray(1,contador)=3;
        endif
      case 3
        if strcmp(cellArray{1,contador},"ftp_data")==1
          doubleArray(1,contador)=1;
        endif
        if strcmp(cellArray{1,contador},"other")==1
          doubleArray(1,contador)=2;
        endif
        if strcmp(cellArray{1,contador},"private")==1
          doubleArray(1,contador)=3;
        endif
        if strcmp(cellArray{1,contador},"http")==1
          doubleArray(1,contador)=4;
        endif
        if strcmp(cellArray{1,contador},"remote_job")==1
          doubleArray(1,contador)=5;
        endif
        if strcmp(cellArray{1,contador},"name")==1
          doubleArray(1,contador)=6;
        endif
        if strcmp(cellArray{1,contador},"netbios_ns")==1
          doubleArray(1,contador)=7;
        endif
        if strcmp(cellArray{1,contador},"eco_i")==1
          doubleArray(1,contador)=8;
        endif
        if strcmp(cellArray{1,contador},"mtp")==1
          doubleArray(1,contador)=9;
        endif
        if strcmp(cellArray{1,contador},"telnet")==1
          doubleArray(1,contador)=10;
        endif
        if strcmp(cellArray{1,contador},"finger")==1
          doubleArray(1,contador)=11;
        endif
        if strcmp(cellArray{1,contador},"domain_u")==1
          doubleArray(1,contador)=12;
        endif
        if strcmp(cellArray{1,contador},"supdup")==1
          doubleArray(1,contador)=13;
        endif
        if strcmp(cellArray{1,contador},"uucp_path")==1
          doubleArray(1,contador)=14;
        endif
        if strcmp(cellArray{1,contador},"Z39_50")==1
          doubleArray(1,contador)=15;
        endif
        if strcmp(cellArray{1,contador},"smtp")==1
          doubleArray(1,contador)=16;
        endif
        if strcmp(cellArray{1,contador},"csnet_ns")==1
          doubleArray(1,contador)=17;
        endif
        if strcmp(cellArray{1,contador},"uucp")==1
          doubleArray(1,contador)=18;
        endif
        if strcmp(cellArray{1,contador},"netbios_dgm")==1
          doubleArray(1,contador)=19;
        endif
        if strcmp(cellArray{1,contador},"urp_i")==1
          doubleArray(1,contador)=20;
        endif
        if strcmp(cellArray{1,contador},"auth")==1
          doubleArray(1,contador)=21;
        endif
        if strcmp(cellArray{1,contador},"domain")==1
          doubleArray(1,contador)=22;
        endif
        if strcmp(cellArray{1,contador},"ftp")==1
          doubleArray(1,contador)=23;
        endif
        if strcmp(cellArray{1,contador},"bgp")==1
          doubleArray(1,contador)=24;
        endif
        if strcmp(cellArray{1,contador},"ldap")==1
          doubleArray(1,contador)=25;
        endif
        if strcmp(cellArray{1,contador},"ecr_i")==1
          doubleArray(1,contador)=26;
        endif
        if strcmp(cellArray{1,contador},"gopher")==1
          doubleArray(1,contador)=27;
        endif
        if strcmp(cellArray{1,contador},"vmnet")==1
          doubleArray(1,contador)=28;
        endif
        if strcmp(cellArray{1,contador},"systat")==1
          doubleArray(1,contador)=29;
        endif
        if strcmp(cellArray{1,contador},"http_443")==1
          doubleArray(1,contador)=30;
        endif
        if strcmp(cellArray{1,contador},"efs")==1
          doubleArray(1,contador)=31;
        endif
        if strcmp(cellArray{1,contador},"whois")==1
          doubleArray(1,contador)=32;
        endif
        if strcmp(cellArray{1,contador},"imap4")==1
          doubleArray(1,contador)=33;
        endif
        if strcmp(cellArray{1,contador},"iso_tsap")==1
          doubleArray(1,contador)=34;
        endif
        if strcmp(cellArray{1,contador},"echo")==1
          doubleArray(1,contador)=35;
        endif
        if strcmp(cellArray{1,contador},"klogin")==1
          doubleArray(1,contador)=36;
        endif
        if strcmp(cellArray{1,contador},"link")==1
          doubleArray(1,contador)=37;
        endif
        if strcmp(cellArray{1,contador},"sunrpc")==1
          doubleArray(1,contador)=38;
        endif
        if strcmp(cellArray{1,contador},"login")==1
          doubleArray(1,contador)=39;
        endif
        if strcmp(cellArray{1,contador},"kshell")==1
          doubleArray(1,contador)=40;
        endif
        if strcmp(cellArray{1,contador},"sql_net")==1
          doubleArray(1,contador)=41;
        endif
        if strcmp(cellArray{1,contador},"time")==1
          doubleArray(1,contador)=42;
        endif
        if strcmp(cellArray{1,contador},"hostnames")==1
          doubleArray(1,contador)=43;
        endif
        if strcmp(cellArray{1,contador},"exec")==1
          doubleArray(1,contador)=44;
        endif
        if strcmp(cellArray{1,contador},"ntp_u")==1
          doubleArray(1,contador)=45;
        endif
        if strcmp(cellArray{1,contador},"discard")==1
          doubleArray(1,contador)=46;
        endif
        if strcmp(cellArray{1,contador},"nntp")==1
          doubleArray(1,contador)=47;
        endif
        if strcmp(cellArray{1,contador},"courier")==1
          doubleArray(1,contador)=48;
        endif
        if strcmp(cellArray{1,contador},"ctf")==1
          doubleArray(1,contador)=49;
        endif
        if strcmp(cellArray{1,contador},"ssh")==1
          doubleArray(1,contador)=50;
        endif
        if strcmp(cellArray{1,contador},"daytime")==1
          doubleArray(1,contador)=51;
        endif
        if strcmp(cellArray{1,contador},"shell")==1
          doubleArray(1,contador)=52;
        endif
        if strcmp(cellArray{1,contador},"netstat")==1
          doubleArray(1,contador)=53;
        endif
        if strcmp(cellArray{1,contador},"pop_3")==1
          doubleArray(1,contador)=54;
        endif
        if strcmp(cellArray{1,contador},"nnsp")==1
          doubleArray(1,contador)=55;
        endif
        if strcmp(cellArray{1,contador},"IRC")==1
          doubleArray(1,contador)=56;
        endif
        if strcmp(cellArray{1,contador},"pop_2")==1
          doubleArray(1,contador)=57;
        endif
        if strcmp(cellArray{1,contador},"printer")==1
          doubleArray(1,contador)=58;
        endif
        if strcmp(cellArray{1,contador},"tim_i")==1
          doubleArray(1,contador)=59;
        endif
        if strcmp(cellArray{1,contador},"pm_dump")==1
          doubleArray(1,contador)=60;
        endif
        if strcmp(cellArray{1,contador},"red_i")==1
          doubleArray(1,contador)=61;
        endif
        if strcmp(cellArray{1,contador},"netbios_ssn")==1
          doubleArray(1,contador)=62;
        endif
        if strcmp(cellArray{1,contador},"rje")==1
          doubleArray(1,contador)=63;
        endif
        if strcmp(cellArray{1,contador},"X11")==1
          doubleArray(1,contador)=64;
        endif
        if strcmp(cellArray{1,contador},"urh_i")==1
          doubleArray(1,contador)=65;
        endif
        if strcmp(cellArray{1,contador},"http_8001")==1
          doubleArray(1,contador)=66;
        endif
      case 4
        if strcmp(cellArray{1,contador},"SF")==1
          doubleArray(1,contador)=1;
        endif
        if strcmp(cellArray{1,contador},"S0")==1
          doubleArray(1,contador)=2;
        endif
        if strcmp(cellArray{1,contador},"REJ")==1
          doubleArray(1,contador)=3;
        endif
        if strcmp(cellArray{1,contador},"RSTR")==1
          doubleArray(1,contador)=4;
        endif
        if strcmp(cellArray{1,contador},"SH")==1
          doubleArray(1,contador)=5;
        endif
        if strcmp(cellArray{1,contador},"RSTO")==1
          doubleArray(1,contador)=6;
        endif
        if strcmp(cellArray{1,contador},"S1")==1
          doubleArray(1,contador)=7;
        endif
        if strcmp(cellArray{1,contador},"RSTOS0")==1
          doubleArray(1,contador)=8;
        endif
        if strcmp(cellArray{1,contador},"S3")==1
          doubleArray(1,contador)=9;
        endif
        if strcmp(cellArray{1,contador},"S2")==1
          doubleArray(1,contador)=10;
        endif
        if strcmp(cellArray{1,contador},"OTH")==1
          doubleArray(1,contador)=11;
        endif
      case 42
        if strcmp(cellArray{1,contador},"normal")==1
          doubleArray(1,contador)=1;
        else
          doubleArray(1,contador)=-1;
        endif
      otherwise
        doubleArray(1,contador)=str2double(cellArray{1,contador});        
    endswitch
    contador++;
  endwhile
  retval=doubleArray;
endfunction

 
      