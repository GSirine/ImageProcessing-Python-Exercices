

clear all, close all, clc;

pkg load signal;
pkg load image;
I=double(imread('M5.jpg'));
%I=rgb2gray(I);
[h,l]=size(I)

%partie compression

%calcul de la DCT
I1=dct2(I);
taille=5:50:h         #taille

PSNR=zeros(taille,1);
tauc=zeros(taille,1);
for i=1:length(taille),
mask=zeros(h,l);
mask(1:taille(i),1:taille(i))=1;

#calcul de la DCT inverse
I_i=idct2(I1.*mask);

#calcul du PSNR
m=mean((I(:)-I_i(:)).^2);
PSNR(i,1)=10*log10((max(I(:))^2)/m);

#calcul du taux de compression
tauc=100*(1-((taille/h).*(taille/l)));


endfor


figure,
plot(tauc,PSNR)
title('PSNR en fonction du taux de compression')
xlabel('taux de compression (%)')
ylabel('PSNR (dB)')


