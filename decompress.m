function decompress(compressedImg, method, k, h)
  % Geração da matriz dos coeficientes:
  % Caso o método seja de interpolação Bilinear
  if method == 1
    coefficients = zeros(size(compressedImg)(1)-1,size(compressedImg)(2)-1,3,4);
    % Gera-se a inversa da matriz dos coeficientes do sistema linear
     h_matrix_inv = inv([1 0 0 0; 1 0 h 0; 1 h 0 0; 1 h h h^2]);
     % Com isso:
    for i = [1:size(compressedImg)(1)-1] % Para cada linha
      for j = [1:size(compressedImg)(2)-1] % Para cada coluna
        for c = [1:3]                        % Para cada canal de cor
          % Gera-se a matriz coluna dos resultados esperados do sistema linear
          f_column = double([compressedImg(i,j,c);compressedImg(i,j+1,c);compressedImg(i+1,j,c);compressedImg(i+1,j+1,c)]);
          % E realiza-se o processo de multiplicação de h_matrix_inv por f_column (Vide [Parte do erro] no relatório)
          _res = (h_matrix_inv*f_column);
          for l = [1:4]
            coefficients(i,j,c,l) = _res(l);
          endfor
        endfor
      endfor
    endfor
    
    % Interpolação para a descompressão:
    incr = h/(k+1);
    decompressedImg = zeros(size(compressedImg)(1)*(1+k)-k,size(compressedImg)(2)*(1+k)-k,3);
    size(decompressedImg)
    for c = [1:3]
      for i = [0:size(coefficients)(1)-1]
	for j = [0:size(coefficients)(2)-1]
          for x_inc = [0:k]
            for y_inc = [0:k]
              pos_desc_i = i*(k+1)+x_inc;
              pos_desc_j = j*(k+1)+y_inc;
              cf = coefficients(i+1,j+1,c,:);
              decompressedImg(pos_desc_i+1,pos_desc_j+1,c) = cf(1) + cf(2)*(x_inc) +cf(3)*(y_inc) + cf(4)*(x_inc)*(y_inc);
            endfor
          endfor
	endfor
      endfor
      size(decompressedImg)
      for i = [0:size(coefficients)(1)-1]
	cf1 = coefficients(size(coefficients)(1),i+1,c,:);
	cf2 = coefficients(i+1,size(coefficients)(2),c,:);
	for g_inc = [0:k]
          pos_desc_i = i*(k+1)+g_inc;
          decompressedImg(size(decompressedImg)(1),pos_desc_i+1,c) = cf1(1) + cf1(2)*(k+1) +cf1(3)*(g_inc) + cf1(4)*(g_inc)*(k+1);
          decompressedImg(pos_desc_i+1,size(decompressedImg)(2),c) = cf2(1) + cf2(2)*(g_inc) +cf2(3)*(k+1) + cf2(4)*(g_inc)*(k+1);
	endfor
      endfor
      cff = coefficients(size(coefficients)(1),size(coefficients)(2),c,:);
      decompressedImg(size(decompressedImg(1)),size(decompressedImg)(2),c) = cff(1) + cff(2)*(k+1) +cff(3)*(k+1) + cff(4)*(k+1)^2;
    endfor


  elseif method == 2
    size_c = size(compressedImg)(1);
    coefficients = double(zeros(size_c-1,size_c-1,3,4,4));
    h_matrix = [1 0 0 0; 1 h h^2 h^3; 0 1 0 0; 0 1 2*h 3*h^2];
    der = double(zeros(3,size_c,size_c,3));
    for c = [1:3]
      for i = [1:size_c]
	for j = [1:size_c]
	  if(i == 1)
	    der(1,1,j,c) = double(compressedImg(2,j,c)-compressedImg(1,j,c))/(1.0*h);
	  elseif(i == size_c)
	    der(1,size_c,j,c) = double(compressedImg(size_c,j,c)-compressedImg(size_c-1,j,c))/(1.0*h);
	  else
	    der(1,i,j,c) = double(compressedImg(i+1,j,c)-compressedImg(i-1,j,c))/(2.0*h);
	  endif
	  
	  if(j == 1)
	    der(2,i,1,c) = double(compressedImg(i,2,c)-compressedImg(i,1,c))/(1.0*h);
	  elseif(j == size_c)
	    der(2,i,size_c,c) = double(compressedImg(i,size_c,c)-compressedImg(i,size_c-1,c))/(1.0*h);
	  else
	    der(2,i,j,c) = double(compressedImg(i,j+1,c)-compressedImg(i,j-1,c))/(2.0*h);
	  endif
	endfor
      endfor
      
      for i = [1:size_c]
	for j = [1:size_c]
	  if(i == 1)
	    der(3,1,j,c) = double(der(2,2,j,c)-der(2,1,j,c))/(1.0*h);
	  elseif(i == size_c)
	    der(3,size_c,j,c) = double(der(2,size_c,j,c)-der(2,size_c-1,j,c))/(1.0*h);
	  else
	    der(3,i,j,c) = double(der(2,i+1,j,c)-der(2,i-1,j,c))/(2.0*h);
	  endif
	endfor
      endfor

      for i = [1:size_c-1]
	for j = [1:size_c-1]
	  aux_M = double(zeros(4,4));
	  for x = [1:2]
	    for y = [1:2]
	      aux_M(x,y) = compressedImg(i+x-1,j+y-1,c);
	      aux_M(2+x,y) = der(1,i+x-1,j+y-1,c);
	      aux_M(x,y+2) = der(2,i+x-1,j+y-1,c);
	      aux_M(2+x,y+2) = der(3,i+x-1,j+y-1,c);
	    endfor
	  endfor
	  aux_M = inv(h_matrix) * aux_M * inv(h_matrix');
	  for m = [1:4]
	    for n = [1:4]
	      coefficients(i,j,c,m,n) = aux_M(m,n);
	    endfor
	  endfor
	endfor
      endfor
    endfor
    
    incr = h/(k+1);
    decompressedImg = zeros(size(compressedImg)(1)*(1+k)-k,size(compressedImg)(2)*(1+k)-k,3);
    for c = [1:3]
      for i = [1:size_c-1]
	for j = [1:size_c-1]
          for x_inc = [0:k]
            for y_inc = [0:k]
	      x = x_inc*incr;
	      y = y_inc*incr;
	      pos_desc_i = i*(k+1)+x_inc;
	      pos_desc_j = j*(k+1)+y_inc;
	      cf = coefficients(i,j,c,:,:);
	      decompressedImg(pos_desc_i,pos_desc_j,c) = [1 x x^2 x^3] * reshape(cf,4,4) * [1; y; y^2; y^3];
            endfor
          endfor
	endfor
      endfor
      for i = [1:size_c-1]
	cf1 = coefficients(size_c - 1,i,c,:,:);
	cf2 = coefficients(i,size_c - 1,c,:,:);
	for g_inc = [0:k]
	  g = g_inc * incr;
          pos_desc_i = i*(k+1)+g_inc;
          decompressedImg(size(decompressedImg)(1),pos_desc_i,c) = [1 h h^2 h^3] * reshape(cf1,4,4) * [1; g; g^2; g^3];
          decompressedImg(pos_desc_i,size(decompressedImg)(2),c) = [1 g g^2 g^3] * reshape(cf2,4,4) * [1; h; h^2; h^3];
	endfor
      endfor
      cff = coefficients(size_c-1,size_c-1,c,:,:);
      decompressedImg(size(decompressedImg(1)),size(decompressedImg)(2),c) = [1 h h^2 h^3] * reshape(cff,4,4) * [1; h; h^2; h^3];
    endfor
  endif
  clear coefficients;
  imwrite(uint8(decompressedImg),"decompressed.png",'Compression',"none",'Quality',0);
endfunction
