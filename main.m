clear all;
compress("black-white.png",2);
decompress("compressed.png",1,2,1);
calculateError("black-white.png","decompressed.png");
