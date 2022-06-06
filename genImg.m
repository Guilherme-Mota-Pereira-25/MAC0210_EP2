function image = genImg()
  p = 601; % Tamanho da imagem
  image = uint8(zeros(p,p,3));
  for i = [1:p]
    for j = [1:p]
      image(i,j,1) = floor(255*(sind(i)+1)/2);
      image(i,j,2) = floor(255*((sind(i)+sind(j))/2+1)/2);
      image(i,j,3) = floor(255*(sind(j)+1)/2);
    endfor
  endfor
  imwrite(image,"genned.png",'Compression',"none",'Quality',0);
endfunction
