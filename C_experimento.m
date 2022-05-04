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
##pkg load ltfat
##pkg unload ltfat
##ltfatstart

function [] = experiment(endereco,imagem) 
  disp("Experiment for image embedding algorithm\n")
  disp(imagem)
  disp("\n")

  %GENERATING
  RGB = imread(imagem);
  [N,M,c] = size(RGB);
  n = N*M;
  
  YCbCr = rgb2ycbcr(RGB);
  Y = YCbCr(:,:,1);

  Sv = imresize(YCbCr(:,:,2),0.5);
  Sh = imresize(YCbCr(:,:,3),0.5);
  
    %Wavelet Transform (Haar)
  Idb = fwt2(double(Y),'db1',2);
  Imdb = 20*log10(abs(Idb));

  %EXPERIMENT FOR EACH SCALE COEFICIENT
  k = 7;
  MSE_Y = [];
  PSNR_Y = [];
  MSE_RGB = [];
  PSNR_RGB = [];
  for (i=1:k)
    escala=2.^i;
    
    Idb(1:N/2,M/2+1:M,1) = (Sv.-escala)/escala;
    Idb(N/2+1:N,1:M/2,1) = (Sh.-escala)/escala;
    Imdb = 20*log10(abs(Idb));
    
    Yconstr = uint8(round(ifwt2(Idb,'db1',2)));
    
    %RECOVERING
      %Wavelet Transform (Haar)
    Ydb = fwt2(double(Yconstr),'db1',2);
    Ymdb = 20*log10(abs(Ydb));
    
    Sv = zeros(N/2,M/2);
    Sh = zeros(N/2,M/2);
    Sv = (Ydb(1:N/2,M/2+1:M).*escala)+escala;
    Sh = (Ydb(N/2+1:N,1:M/2,1).*escala)+escala;
    Cb = uint8(imresize(Sv,2,"bicubic"));
    Cr = uint8(imresize(Sh,2,"bicubic"));
    
    Ydb(1:N/2,M/2+1:M)=0;
    Ydb(N/2+1:N,1:M/2,1)=0;
    Y_rec = uint8(round(ifwt2(Ydb,'db1',2)));
    
    YCbCr = cat(3,Y_rec,Cb,Cr);
    RGB_rec = ycbcr2rgb(YCbCr);
  
    VarY = (Y(:,:)-Yconstr(:,:)).^2;
    MSE_Y = [MSE_Y, sum(VarY(:))/n];
    PSNR_Y = [PSNR_Y, 20*log10(255^2/MSE_Y(i))];
   
    VarRGB = (RGB(:,:)-RGB_rec(:,:)).^2;
    MSE_RGB = [MSE_RGB, sum(VarRGB(:))/(c*n)];
    PSNR_RGB = [PSNR_RGB, 20*log10(255^2/MSE_RGB(i))];  
  endfor
  
  %PRINT PERFORMANCE
  escala=2.^(1:k);
  
  figure;
  hold on;
  plot(escala, MSE_Y, 'b-');
  plot(escala, MSE_RGB, 'r-');
  ylim([min([MSE_RGB, MSE_Y]),max([MSE_RGB, MSE_Y])]);
  xlim([min(escala),max(escala)]);
  set(gca,'FontSize',14);
  ylabel('Mean Squared Error');
  xlabel('Scale coeficient');
  legend('Orig (Luma) x Generated grayscale','Orig x Reconstructed')
  legend("location","east");
  title(imagem);
  saveas(gca,strcat([endereco,'Imagens\',imagem,'\experiment\','MSE.png']), 'png')
  hold off;
  
  figure;
  hold on;
  plot(escala, PSNR_Y, 'b-');
  plot(escala, PSNR_RGB, 'r-');
  ylim([min([PSNR_RGB, PSNR_Y]),max([PSNR_RGB, PSNR_Y])]);
  xlim([min(escala),max(escala)]);
  set(gca,'FontSize',14);
  ylabel('PSNR (dB)');
  xlabel('Scale coeficient');
  legend('Orig (Luma) x Generated grayscale','Orig x Reconstructed')
  legend("location","east");
  title(imagem);
  saveas(gca,strcat([endereco,'Imagens\',imagem,'\experiment\','PSNR.png']), 'png')
  hold off;
end

%COMECAR
endereco = './';

imagem = 'PeppersRGB.bmp';
experiment(endereco,imagem);
  
imagem = 'BaboonRGB.bmp';
experiment(endereco,imagem)
  
imagem = 'monarch.bmp';
experiment(endereco,imagem)