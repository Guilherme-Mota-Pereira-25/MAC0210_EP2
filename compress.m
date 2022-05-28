function compress(originalImg, k)
   indexes = [];
   i = 1;
   for index = [1:size(originalImg)(1)]
      if mod(index, k+1) == 0
        indexes(i) = index;
        i = i + 1;
      endif
   endfor
   imwrite(originalImg(indexes,indexes,:),"compressed.bmp");
endfunction