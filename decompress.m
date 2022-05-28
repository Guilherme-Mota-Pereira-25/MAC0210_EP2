function decompress(compressedImg, method, k, h)
  % Geração da matriz dos coeficientes:
  coefficients = zeros(size(compressedImg)(1),size(compressedImg)(2),3,4);
  % Caso o método seja de interpolação Bilinear
  if method == 1
    % Gera-se a inversa da matriz dos coeficientes do sistema linear
     h_matrix_inv = inv([1 0 0 0; 1 0 h 0; 1 h 0 0; 1 h h h^2]);
     % Com isso:
    for i = [1:size(compressedImg)(1)-1] % Para cada linha
      for j = [1:size(compressedImg)(2)-1] % Para cada coluna
        for k = [1:3]                        % Para cada canal de cor
          % Gera-se a matriz coluna dos resultados esperados do sistema linear
          f_column = [compressedImg(i,j,k),compressedImg(i,j+1,k),compressedImg(i+1,j,k),compressedImg(i+1,j+1,k)];
          % E realiza-se o processo de multiplicação de h_matrix_inv por f_column (Vide [Parte do erro] no relatório)
          for m = [1:4]
            for n = [1:4]
              coefficients(i,j,k,m) += h_matrix_inv(m,n)*f_column(n);          
            endfor
          endfor
        endfor
      endfor
    endfor
  elseif method == 2
    fprintf("Em andamento...");
  endif
  % Interpolação para a descompressão:
  incr = h/k;
  decompressedImg = zeros(size(compressedImg)(1)(1+k)-k,size(compressedImg)(2)(1+k)-k,3);
  for k = [1:3]
    x = 0; y = 0;
    while i < size(decompressedImg)(1)
      while j < size(decompressedImg)(1)
         
      endwhile
    endwhile
  endfor
  clear coefficients;
endfunction
