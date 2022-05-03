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
##endereco = '../';
endereco = './';
imagem = 'PeppersRGB.bmp';

##function [] = reconstroi_color(endereco,imagem)
  disp("\n")
  disp(imagem)

  Yconstr = imread(strcat([endereco,'Imagens\',imagem,'\','processado.png']));
  [N,M] = size(Yconstr);
  n = N*M;
  figure;imshow(Yconstr);

  %Wavelet Transform (Daubechies 4)
  Ydb = fwt2(double(Yconstr),'db4',2);
  Ymdb = 20*log10(abs(Ydb));
  imwrite(Ymdb, strcat([endereco,'Imagens\',imagem,'\','wav_db4.png']), 'png');
  figure; imagesc(dynlimit(Ymdb,70));
  colormap(gray);
  

  
  Sv = zeros(N/2,M/2);
  Sh = zeros(N/2,M/2);
  Sv = (Ydb(1:N/2,M/2+1:M).*63)+63;
  Sh = (Ydb(N/2+1:N,1:M/2,1).*63)+63;
  Cb = uint8(imresize(Sv,2,"bicubic"));
  Cr = uint8(imresize(Sh,2,"bicubic"));
  
  Ydb(1:N/2,M/2+1:M)=0;
  Ydb(N/2+1:N,1:M/2,1)=0;
  Y = uint8(round(ifwt2(Ydb,'db4',2)));
  
  figure; imshow(Y);
  figure; imshow(Cb);
  figure; imshow(Cr);
  
  YCbCr = cat(3,Y,Cb,Cr);
  RGB = ycbcr2rgb(YCbCr);
  figure;imshow(RGB);
  imwrite(RGB, strcat([endereco,'Imagens\',imagem,'\','reconstruido.png']), 'png');
##end
##
##%COMECAR
##endereco = '../';
##
##imagem = 'lena_gray_512.tif';
##Calc_quant_transf(endereco,imagem);
