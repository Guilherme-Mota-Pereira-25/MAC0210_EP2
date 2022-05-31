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
  for c = [1:3]
    for i = [1:size(coefficients)(1)]
      for j = [1:size(coefficients)(2)]
        for x_inc = [0:k]
          for y_inc = [0:k]
            pos_desc_i = i*(k+1)+x_inc;
            pos_desc_j = j*(k+1)+y_inc;
            cf = coefficients(i,j,c,:);
            decompressedImg(pos_desc_i,pos_desc_j,c) = cf(1) + cf(2)*(x_inc) +cf(3)*(y_inc) + cf(4)*(x_inc)*(y_inc);
          endfor
        endfor
      endfor
    endfor
    for i = [1:size(coefficients)(1)]
      cf1 = coefficients(size(coefficients)(1),i,c,:);
      cf2 = coefficients(i,size(coefficients)(2),c,:);
      for g_inc = [0:k]
        pos_desc_i = i*(k+1)+g_inc;
        decompressedImg(size(decompressedImg)(1),pos_desc_i,c) = cf1(1) + cf1(2)*(x_inc) +cf1(3)*(y_inc) + cf1(4)*(x_inc)*(y_inc);
        decompressedImg(pos_desc_i,size(decompressedImg)(2),c) = cf2(1) + cf2(2)*(x_inc) +cf2(3)*(y_inc) + cf2(4)*(x_inc)*(y_inc);
      endfor
    endfor
    cff = coefficients(size(coefficients)(1),size(coefficients)(2),c,:);
    decompressedImg(size(decompressedImg(1)),size(decompressedImg)(2),c) = cff(1) + cff(2)*k +cff(3)*k + cff(4)*k^2;
  endfor
  elseif method == 2
    fprintf("Em andamento...");
  endif
  clear coefficients;
  imwrite(uint8(decompressedImg),"decompressed.png",'Compression',"none",'Quality',0);
endfunction
