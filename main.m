clear all;
original = imread("input.png");
compress(original,1);
compressed = imread("compressed.png");
decompress(compressed,1,1,1);
decompressed = imread("decompressed.png");
calculateError(original([1:255],[1:255],:),decompressed);
imshow(original)
figure, imshow(compressed);
figure, imshow(decompressed);
