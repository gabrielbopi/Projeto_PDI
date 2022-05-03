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


function [] = reconstroi_cores(endereco,imagem)
  disp("Recover the embedded colors:\n")
  disp(imagem)
  disp("\n")

  Yconstr = imread(strcat([endereco,'Imagens\',imagem,'\','processado.png']));
  [N,M] = size(Yconstr);
  n = N*M;
  figure;imshow(Yconstr);

  %Wavelet Transform (Haar)
  Ydb = fwt2(double(Yconstr),'db1',2);
  Ymdb = 20*log10(abs(Ydb));
  imwrite(Ymdb, strcat([endereco,'Imagens\',imagem,'\','wav_db1.png']), 'png');
  figure; imagesc(dynlimit(Ymdb,70));
  colormap(gray);
  
  escala = 31;
  Sv = zeros(N/2,M/2);
  Sh = zeros(N/2,M/2);
  Sv = (Ydb(1:N/2,M/2+1:M).*escala)+escala;
  Sh = (Ydb(N/2+1:N,1:M/2,1).*escala)+escala;
  Cb = uint8(imresize(Sv,2,"bicubic"));
  Cr = uint8(imresize(Sh,2,"bicubic"));
  
  Ydb(1:N/2,M/2+1:M)=0;
  Ydb(N/2+1:N,1:M/2,1)=0;
  Y = uint8(round(ifwt2(Ydb,'db1',2)));
  
  figure; imshow(Y);
##  figure; imshow(Cb);
##  figure; imshow(Cr);
  
  YCbCr = cat(3,Y,Cb,Cr);
  RGB = ycbcr2rgb(YCbCr);
  figure;imshow(RGB);
  imwrite(RGB, strcat([endereco,'Imagens\',imagem,'\','reconstruido.png']), 'png');
end

%COMECAR
endereco = './';

imagem = 'PeppersRGB.bmp';
reconstroi_cores(endereco,imagem);
  
imagem = 'BaboonRGB.bmp';
reconstroi_cores(endereco,imagem)
  
imagem = 'monarch.bmp';
reconstroi_cores(endereco,imagem)
