function compress(originalImg, k)
  original = imread(originalImg);
  indexes = [];
  i = 1;
  for index = [1:k+1:size(original)(1)]
    indexes(i) = index;
    i = i + 1;
  endfor
  imwrite(original(indexes,indexes,:),"compressed.png",'Compression',"none",'Quality',0);
endfunction
