function decompress(compressedImg, method, k, h)
  
  compressed = imread(compressedImg);
  s_comp = size(compressed)(1) - 1;
  s_coef = s_comp-1;
  s_desc = (s_comp+1)*(1+k)-k;
  decompressedImg = zeros(s_desc,s_desc,3);
  incr = h/(k+1);
  k_1 = k+1;
  
  % Geração da matriz dos coeficientes:
  % Caso o método seja de interpolação Bilinear
  if method == 1
    coefficients = zeros(s_comp,s_comp,3,4);
    % Gera-se a inversa da matriz dos coeficientes do sistema linear
     h_matrix_inv = inv([1 0 0 0; 1 0 h 0; 1 h 0 0; 1 h h h^2]);
     % Com isso:
    for i = [1:s_comp] % Para cada linha
      for j = [1:s_comp] % Para cada coluna
        for c = [1:3]                        % Para cada canal de cor
          % Gera-se a matriz coluna dos resultados esperados do sistema linear
          f_column = double([compressed(i,j,c);compressed(i,j+1,c);compressed(i+1,j,c);compressed(i+1,j+1,c)]);
          % E realiza-se o processo de multiplicação de h_matrix_inv por f_column (Vide [Parte do erro] no relatório)
          _res = (h_matrix_inv*f_column);
          for l = [1:4]
            coefficients(i,j,c,l) = _res(l);
          endfor
        endfor
      endfor
    endfor

    % Interpolação para a descompressão:
    for c = [1:3]
      for i = [0:s_coef]
	for j = [0:s_coef]
          for x_inc = [0:k]
            for y_inc = [0:k]
              pos_desc_i = i*k_1+x_inc+1;
              pos_desc_j = j*k_1+y_inc+1;
              cf = coefficients(i+1,j+1,c,:);
              decompressedImg(pos_desc_i,pos_desc_j,c) = cf(1) + cf(2)*x_inc*incr +cf(3)*y_inc*incr + cf(4)*x_inc*y_inc*incr^2;
            endfor
          endfor
	endfor
      endfor
      for i = [0:s_coef]
	cf1 = coefficients(s_coef,i+1,c,:);
	cf2 = coefficients(i+1,s_coef,c,:);
	for g_inc = [0:k]
          pos_desc_i = i*k_1+g_inc+1;
          decompressedImg(s_desc,pos_desc_i,c) = cf1(1) + cf1(2)*h + cf1(3)*g_inc*incr + cf1(4)*g_inc*h*incr;
          decompressedImg(pos_desc_i,s_desc,c) = cf2(1) + cf2(2)*g_inc*incr + cf2(3)*h + cf2(4)*g_inc*h*incr;
	endfor
      endfor
      cff = coefficients(s_coef,s_coef,c,:);
      decompressedImg(s_desc,s_desc,c) = cff(1) + cff(2)*h +cff(3)*h + cff(4)*h^2;
    endfor


  elseif method == 2
    coefficients = double(zeros(s_comp,s_comp,3,4,4));
    h_matrix = [1 0 0 0; 1 h h^2 h^3; 0 1 0 0; 0 1 2*h 3*h^2];
    s_comp2 = s_comp+1;



    %Calculo dos coeficientes
    der = double(zeros(3,s_comp2,s_comp2,3));
    for c = [1:3]
      %Calculo de todas as derivadas parciais
      for i = [1:s_comp2]
	for j = [1:s_comp2]
	  if(i == 1)
	    der(1,1,j,c) = double(compressed(2,j,c)-compressed(1,j,c))/(1.0*h);
	  elseif(i == s_comp2)
	    der(1,s_comp2,j,c) = double(compressed(s_comp2,j,c)-compressed(s_comp,j,c))/(1.0*h);
	  else
	    der(1,i,j,c) = double(compressed(i+1,j,c)-compressed(i-1,j,c))/(2.0*h);
	  endif
	  
	  if(j == 1)
	    der(2,i,1,c) = double(compressed(i,2,c)-compressed(i,1,c))/(1.0*h);
	  elseif(j == s_comp2)
	    der(2,i,s_comp2,c) = double(compressed(i,s_comp2,c)-compressed(i,s_comp,c))/(1.0*h);
	  else
	    der(2,i,j,c) = double(compressed(i,j+1,c)-compressed(i,j-1,c))/(2.0*h);
	  endif
	endfor
      endfor
      
      for i = [1:s_comp2]
	for j = [1:s_comp2]
	  if(i == 1)
	    der(3,1,j,c) = double(der(2,2,j,c)-der(2,1,j,c))/(1.0*h);
	  elseif(i == s_comp2)
	    der(3,s_comp2,j,c) = double(der(2,s_comp2,j,c)-der(2,s_comp,j,c))/(1.0*h);
	  else
	    der(3,i,j,c) = double(der(2,i+1,j,c)-der(2,i-1,j,c))/(2.0*h);
	  endif
	endfor
      endfor


      %Criacao dos coeeficientes
      for i = [1:s_comp]
	for j = [1:s_comp]
	  aux_M = double(zeros(4,4));
	  for x = [1:2]
	    m = i+x-1;
	    for y = [1:2]
	      n = j+y-1;
	      aux_M(x,y) = compressed(m, n, c);
	      aux_M(2+x,y) = der(1, m, n, c);
	      aux_M(x,y+2) = der(2, m, n, c);
	      aux_M(2+x,y+2) = der(3, m, n, c);
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

    %Processo de Interpolacao
    for c = [1:3]
      for i = [0:s_coef]
	tx = i*k_1+1;
	for j = [0:s_coef]
	  ty = j*k_1+1;
          for x_inc = [0:k]
            for y_inc = [0:k]
	      x = x_inc*incr;
	      y = y_inc*incr;
	      pos_desc_i = tx+x_inc;
	      pos_desc_j = ty+y_inc;
	      cf = coefficients(i+1,j+1,c,:,:);
	      decompressedImg(pos_desc_i,pos_desc_j,c) = [1 x x^2 x^3] * reshape(cf,4,4) * [1; y; y^2; y^3];
            endfor
          endfor
	endfor
      endfor
      for i = [0:s_coef]
	cf1 = coefficients(s_coef,i+1,c,:,:);
	cf2 = coefficients(i+1,s_coef,c,:,:);
	tg = i*k_1+1;
	for g_inc = [0:k]
	  g = g_inc * incr;
          pos_desc_i = tg+g_inc;
          decompressedImg(s_desc,pos_desc_i,c) = [1 h h^2 h^3] * reshape(cf1,4,4) * [1; g; g^2; g^3];
          decompressedImg(pos_desc_i,s_desc,c) = [1 g g^2 g^3] * reshape(cf2,4,4) * [1; h; h^2; h^3];
	endfor
      endfor
      cff = coefficients(s_coef,s_coef,c,:,:);
      decompressedImg(s_desc,s_desc,c) = [1 h h^2 h^3] * reshape(cff,4,4) * [1; h; h^2; h^3];
    endfor

  else
    "Numero do metodo incorreto!"
  endif
  
  clear coefficients;
  imwrite(uint8(decompressedImg),"decompressed.png",'Compression',"none",'Quality',0);
endfunction
