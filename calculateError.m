function calculateError(originalImg, decompressedImg)
  error = 0;
  for k = [1:3]
    error = error + vecnorm(originalImg-decompressedImg,2,k)/vecnorm(originalImg,2,k);
  endfor
  error = error/3
endfunction
