clear all, close all, clc;

pkg load signal;
pkg load image;
I=imread('M5.jpg');
[h,l]=size(I)
Aa = imadjust(I, [0.2 0.7], [0 1]);
%partie compression

%calcul de la DCT
I1=dct2(Aa);
taille=5:50:h         #taille

PSNR=zeros(taille,1);
tauc=zeros(taille,1);
for i=1:length(taille),
 mask=zeros(h,l);
 mask(1:taille(i),1:taille(i))=1;

 #calcul de la DCT inverse
 I_i=idct2(I1.*mask);

 #calcul du taux de compression
 tauc=100*(1-((taille/h).*(taille/l)));

 #calcul du PSNR
 m=mean((I(:)-I_i(:)).^2);
 PSNR(i,1)=10*log10((max(I(:))^2)/m);
 %Aa = imadjust(Ia, [0.2 0.7], [0 1]);

 A1=double(abs(I_i));
 %A2=double(I_i(:,:,2));


 A1 = A1./max(max(A1));
 Ab1=A1;
 %A2 = A2./max(max(A2));

 %figure,
 %imhist(A1)

 %figure,
 %imhist(A2)
 SE=strel ("diamond", 7);

 %Ab1 = im2bw(A1,0.6);
 %Ab1=medfilt2(Ab1, [10 10]);
 Ab1=imfill(Ab1,'holes');
 %Ab1=imdilate(Ab1,SE);
 %Ab1=imerode(Ab1,SE);
 %figure,
 %imagesc(Ab1); colormap(gray);

 %Ab2 = ~im2bw(A2,0.3);
 %Ab2=imerode(Ab2,se);
 %Ab2=medfilt2(Ab2, [10 10]);
 %Ab2=imfill(Ab2,'holes');

 %[I_lab, n] = bwlabel(Ab2, 4);
 %figure,
 %imagesc(Ab2),colormap(gray)
 %colorbar,
 %title(['image labellisée contenant ',num2str(n),' objet(s)']);
 %reg = regionprops(I_lab,'Area','BoundingBox');


 %for i = 1:numel(reg)
 % Récupère les propriétés de la bounding box
  %bbox = reg(i).BoundingBox;
 % Calcule la taille de l'objet
  %size = reg(i).Area;

  %if size < 30000
  % supprime l'objet de l'image
   %x = round(bbox(1));
   %y = round(bbox(2));
   %width = round(bbox(3));
   %height = round(bbox(4));
   %Ab2(y:y+height-1, x:x+width-1) = 0;
  %end
 %end
 %Ab2=Ab2;

 %figure,
 %imagesc(Ab2); colormap(gray);
 %Ab=Ab1+Ab2;
 Ab=im2bw(Ab1);

 %Ab=medfilt2(Ab, [10 10]);

 Ab=imfill(Ab,'holes');

 %figure,
 %imhist(Ab);
 %figure,
 %imagesc(Ab);colormap(gray);
 %erosion
 se=strel ("diamond", 3);
 for i=1:2
  ie1=imerode(Ab,se);
  ie2=ie1;
 endfor
 ie=ie2;
 %figure,
 %imagesc(ie);colormap(gray);
 for i=1:2
  id1=imerode(ie,se);
  id2=id1;
 endfor
 id=id1;
 %figure,
 %imagesc(id);colormap(gray);

%%% fonction regionprops %%%
 [L, num] = bwlabel(id, 4);

 figure,
 imagesc(id),colormap(gray)
 colorbar,
 title(['image labellisee contenant ',num2str(num),' objet(s)']);
 % Détection des contours
 [B,L] = bwboundaries(id,4);

 %title(['image labellisee contenant ',num2str(num),' objet(s)']);
 %hold on
 for k = 1:length(B)
   boundary = B{k};
   %plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
 end

 %hold off

 %s = regionprops(L,'Area','Centroid','BoundingBox','Perimeter','Eccentricity');

 somme=0;
 for i = 1:num
    s_1 = regionprops(L == i, 'Area','Centroid','BoundingBox','Perimeter','Eccentricity');
    aire =  cat(1,s_1.Area);



    % Déterminer la valeur de la pièce en fonction de sa taille
    if aire >30000 && aire <47000
        v = 0.02;
    elseif aire > 47000 && aire< 70000
        v = 0.2;
    elseif aire > 70000 && aire < 75000
        v = 2;
    else
        v = 0;
    end

    somme = somme + v;
 end

 fprintf('La somme totale des pièces de M5 vaurt %.2f euros.\n', somme);
 %figure,
 %imagesc(Ia);colormap(gray)
 %title(['Image M',num2str(j),' contient ',num2str(somme),' €']);


#calcul du SSIM


end

%figure,

%plot(tauc,PSNR)
%title('PSNR en fonction du taux de compression')
%xlabel('taux de compression (%)')
%ylabel('PSNR (dB)')

