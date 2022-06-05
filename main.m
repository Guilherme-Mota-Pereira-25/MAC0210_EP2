clear all;
original = imread("gato.png");
compress(original,2);
compressed = imread("compressed.png");
decompress(compressed,1,2,1);
decompressed = imread("decompressed.png");
calculateError(original,decompressed);
imshow(original)
figure, imshow(compressed);
figure, imshow(decompressed);
