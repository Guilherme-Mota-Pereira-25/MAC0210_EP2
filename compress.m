function compress(originalImg, k)
  %Criacao da matriz de cores da imagem
  original = imread(originalImg);
  indexes = [];
  i = 1;

  %Popula o index com as posicoes que devem ser utilizadas na imagem comprimida
  for index = [1:k+1:size(original)(1)] %Salto de k+1 faz com que crie-se um espaco entre um pixel e outro de k unidades
    indexes(i) = index;
    i = i + 1;
  endfor

  %Cria a imagem comprimida
  imwrite(original(indexes,indexes,:),"compressed.png",'Compression',"none",'Quality',0);
endfunction
