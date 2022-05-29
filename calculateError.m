function calculateError(originalImg, decompressedImg)
  error = 0;
  for k = [1:3]
    ch = decompressedImg(:,:,k);
    aux = originalImg(:,:,k) - ch;
    aux = double(resize(aux,1,size(aux)(1)*size(aux)(2)));
    ch = double(resize(ch,1,size(ch)(1)*size(ch)(2)));
    error += (aux*aux')/(ch*ch');
  endfor
  printf("error: %f\n",error);
endfunction