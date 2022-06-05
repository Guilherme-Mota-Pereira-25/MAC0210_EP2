function image = genImg()
  x = 0; y = 0; h = pi; p = 128; % Variáveis de definição da imagem e de sua projeção em R²
  image = uint8(zeros(p,p,3));
  for i = [1:p]
    for j = [1:p]
      image(i,j,1) = floor(255*(sin(rad2deg(x))+1)/2);
      image(i,j,2) = floor(255*((sin(rad2deg(x))+sin(rad2deg(y)))/2+1)/2);
      image(i,j,3) = image(i,j,1);
      y = y + h;
    endfor
    x = x + h; 
  endfor
  imwrite(image,"genned.png",'Compression',"none",'Quality',0);
endfunction