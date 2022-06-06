function calculateError(originalImg, decompressedImg)
  %Cria as matrizes de cores
  original = imread(originalImg);
  decompressed = imread(decompressedImg);
  
  %Verifica se a imagem eh colorida ou nao 
  if (size(size(original))(2) == 2)
    color = 1;
  else
    color = 3;
  endif

  %Calculo do erro usando da norma 2 do vetor gerado pelos pontos das duas imagens 
  error = 0.0;
  for k = [1:color]
    error = error + (vecnorm(reshape(original(:,:,k)-decompressed(:,:,k),size(original)(1)^2,1),2)/vecnorm(reshape(original(:,:,k),size(original)(1)^2,1),2));
  endfor
  
  %Imprime o erro
  error = error/color
endfunction
