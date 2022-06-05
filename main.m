clear all;
compress("gato.png",2);
decompress("compressed.png",2,2,1);
calculateError("input.png","decompressed.png");
