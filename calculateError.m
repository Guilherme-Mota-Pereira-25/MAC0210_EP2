function calculateError(originalImg, decompressedImg)
  error = 0.0;
  for k = [1:3]
    error = error + (vecnorm(reshape(originalImg(:,:,k)-decompressedImg(:,:,k),size(originalImg)(1)^2,1),2)/vecnorm(reshape(originalImg(:,:,k),size(originalImg)(1)^2,1),2));
  endfor
  error = error/3
endfunction
