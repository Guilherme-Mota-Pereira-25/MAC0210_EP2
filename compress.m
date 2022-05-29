function compress(originalImg, k)
  indexes = [];
  i = 1;
  for index = [1:k:size(originalImg)(1)]
    indexes(i) = index;
    i = i + 1;
  endfor
  imwrite(originalImg(indexes,indexes,:),"compressed.png",'Compression',"none",'Quality',0);
endfunction
