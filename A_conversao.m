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

%COMECAR
endereco = './';
imagem = 'PeppersRGB.bmp';

##function [] = gera_grayscale(endereco,imagem)
  disp("\n")
  disp(imagem)

  RGB = imread(imagem);
  [N,M,c] = size(RGB);
  n = N*M;
  figure;imshow(RGB);
  imwrite(RGB, strcat([endereco,'Imagens\',imagem,'\','orig.png']), 'png');
  YCbCr = rgb2ycbcr(RGB);
  figure;imshow(YCbCr(:,:,1));
  Sv = imresize(YCbCr(:,:,2),0.5);
  Sh = imresize(YCbCr(:,:,3),0.5);
  
  %Wavelet Transform (Daubechies 4)
  Idb = fwt2(double(YCbCr(:,:,1)),'db4',2);
  Imdb = 20*log10(abs(Idb));
  imwrite(Imdb, strcat([endereco,'Imagens\',imagem,'\','wav_db4.png']), 'png');
  figure; imagesc(dynlimit(Imdb,70));
  colormap(gray);
  
  Idb(1:N/2,M/2+1:M,1) = (Sv.-63)/63;
  Idb(N/2+1:N,1:M/2,1) = (Sh.-63)/63;
  Imdb = 20*log10(abs(Idb));
  figure; imagesc(dynlimit(Imdb,70));
  colormap(gray);
  imwrite(Imdb, strcat([endereco,'Imagens\',imagem,'\','wav_mod.png']), 'png');
  
  Yconstr = uint8(round(ifwt2(Idb,'db4',2)));
  figure;imshow(Yconstr);
  imwrite(Yconstr, strcat([endereco,'Imagens\',imagem,'\','processado.png']), 'png');
##end
##
##%COMECAR
##endereco = '../';
##
##imagem = 'lena_gray_512.tif';
##Calc_quant_transf(endereco,imagem);
##
##imagem = 'clown_notch_256.tif';
##Calc_quant_transf(endereco,imagem);
##
##imagem = 'mountain.tif';
##Calc_quant_transf(endereco,imagem);
