function image = genImg()
  x = 0; y = 0; h = 5; p = 256; % Variáveis de definição da imagem e de sua projeção em R²
  image = uint8(zeros(p,p,3));
  for i = [1:p]
    for j = [1:p]
      image(i,j,1) = floor(255*(sin(x)+1)/2);
      image(i,j,2) = floor(255*((sin(x)+sin(y))/2 + 1)/2);
      image(i,j,3) = image(i,j,1);
      x += h; y += h;
    endfor
  endfor
  imwrite(image,"genned.png",'Compression',"none",'Quality',0);
endfunction