function calculateError(originalImg, decompressedImg)
  original = imread(originalImg);
  decompressed = imread(decompressedImg);
  error = 0.0;
  for k = [1:3]
    error = error + (vecnorm(reshape(original(:,:,k)-decompressed(:,:,k),size(original)(1)^2,1),2)/vecnorm(reshape(original(:,:,k),size(original)(1)^2,1),2));
  endfor
  error = error/3
endfunction
