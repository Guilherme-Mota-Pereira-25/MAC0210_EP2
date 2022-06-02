function calculateError(originalImg, decompressedImg)
  error = 0.0;
  for k = [1:3]
    a = double(vecnorm(originalImg-decompressedImg,2,k));
    b = double(vecnorm(originalImg,2,k));
    error = error + a/b;
  endfor
  error = error/3;
endfunction
