close all;
%Autor: Gabriel Borges Pinheiro
%Engenharia Eletrônica - UnB_FGA
%Processamento Digital de Imagens

%Projeto Final
clear all;
close all;
clc
pkg load image
pkg load signal
%Must install ltfat package
pkg load ltfat
##pkg unload ltfat
##ltfatstart

function [] = gera_grayscale(endereco,imagem)
  disp("Generate agray-scale picture with embedded colors:\n")
  disp(imagem)
  disp("\n")

  RGB = imread(imagem);
  [N,M,c] = size(RGB);
  n = N*M;
  figure;imshow(RGB);
  imwrite(RGB, strcat([endereco,'Imagens\',imagem,'\','orig.png']), 'png');
  
  YCbCr = rgb2ycbcr(RGB);
  figure;imshow(YCbCr(:,:,1));
  imwrite(YCbCr(:,:,1), strcat([endereco,'Imagens\',imagem,'\','Y_orig.png']), 'png');
  Sv = imresize(YCbCr(:,:,2),0.5);
  Sh = imresize(YCbCr(:,:,3),0.5);
  
  %Wavelet Transform (Haar)
  Idb = fwt2(double(YCbCr(:,:,1)),'db1',2);
  Imdb = 20*log10(abs(Idb));
  imwrite(Imdb, strcat([endereco,'Imagens\',imagem,'\','wav_db1.png']), 'png');
  figure; imagesc(dynlimit(Imdb,70));
  colormap(gray);
  
  escala = 31;
  Idb(1:N/2,M/2+1:M,1) = (Sv.-escala)/escala;
  Idb(N/2+1:N,1:M/2,1) = (Sh.-escala)/escala;
  Imdb = 20*log10(abs(Idb));
  figure; imagesc(dynlimit(Imdb,70));
  colormap(gray);
  imwrite(Imdb, strcat([endereco,'Imagens\',imagem,'\','wav_mod.png']), 'png');
  
  Yconstr = uint8(round(ifwt2(Idb,'db1',2)));
  figure;imshow(Yconstr);
  imwrite(Yconstr, strcat([endereco,'Imagens\',imagem,'\','processado.png']), 'png');
end

%COMECAR
endereco = './';

imagem = 'PeppersRGB.bmp';
gera_grayscale(endereco,imagem);
  
imagem = 'BaboonRGB.bmp';
gera_grayscale(endereco,imagem)
  
imagem = 'monarch.bmp';
gera_grayscale(endereco,imagem)