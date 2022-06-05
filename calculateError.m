function calculateError(originalImg, decompressedImg)
  original = imread(originalImg);
  decompressed = imread(decompressedImg);
  if (size(size(original))(2) == 2)
    color = 1;
  else
    color = 3;
  endif
  error = 0.0;
  for k = [1:color]
    error = error + (vecnorm(reshape(original(:,:,k)-decompressed(:,:,k),size(original)(1)^2,1),2)/vecnorm(reshape(original(:,:,k),size(original)(1)^2,1),2));
  endfor
  error = error/color
endfunction
