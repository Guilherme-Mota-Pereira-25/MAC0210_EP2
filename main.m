clear all;
img = imread("input.png");
size(img)
compress(img,1);
c = imread("compressed.bmp");
decompress(c,1,1,1);
