clear all; close all; clc;
pkg load image;
pkg load signal;
% Charger l'image
I = imread('M5.jpg');
I = double(I);
I=I./max(max(I));
[h,l]=size(I);

d=[0.1:0.1:0.9]; %densité de bruit
Q = zeros(1,length(d));
for i = 1:length(d)

 % Ajout du bruit à l'image
 I_b = imnoise(I,'salt & pepper',d(i));
 % Calcul de Q
 m = sum((I(:)-I_b(:)).^2) /(h*l);
 Q(i)=sqrt(m);
end
plot(d, Q, '-');
xlabel('Niveau de bruit d'); ylabel(' Ecart Q'); title('Evolution de Q en fonction du niveau de bruit');

%Recherche de la valeur de Q pour laquelle le diagnostic n'est plus correct
for j = 1:length(d)

 I_b = imnoise(I,'salt & pepper',d(j));

 Aa = imadjust(I_b, [0.2 0.7], [0 1]);

 A1=double(Aa(:,:,1));
 A2=double(Aa(:,:,2));

 A1 = A1./max(max(A1));
 A2 = A2./max(max(A2));

 SE=strel ("diamond", 7);

 Ab1 = im2bw(A1,0.55);

 Ab1=imfill(Ab1,'holes');


 figure,
 imagesc(Ab1); colormap(gray);

 Ab2 = ~im2bw(A2,0.35);

 Ab2=imfill(Ab2,'holes');


 [I_lab, n] = bwlabel(Ab2, 4);

 reg = regionprops(I_lab,'Area','BoundingBox');


 for i = 1:numel(reg)

  bbox = reg(i).BoundingBox;

  size = reg(i).Area;

  if size < 30000

   x = round(bbox(1));
   y = round(bbox(2));
   width = round(bbox(3));
   height = round(bbox(4));
   Ab2(y:y+height-1, x:x+width-1) = 0;
  end
 end
 Ab2=Ab2;

 Ab=Ab1+Ab2;
 Ab=im2bw(Ab);
 Ab=imfill(Ab,'holes');

 se=strel ("diamond", 3);
 for i=1:2
  ie1=imerode(Ab,se);
  ie2=ie1;
 endfor
 ie=ie2;

 for i=1:5
  id1=imerode(ie,se);
  id2=id1;
 endfor
 id=id1;


 [L, num] = bwlabel(id, 4);

 figure,
 imagesc(id),colormap(gray)
 colorbar,
 title(['image labellisee contenant ',num2str(num),' objet(s)']);

 [B,L] = bwboundaries(id,4);

 title(['image labellisee contenant ',num2str(num),' objet(s)']);
 hold on
 for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
 end

 hold off

 s = regionprops(L,'Area','Centroid','BoundingBox','Perimeter','Eccentricity');
 somme=0;
 for i = 1:num
    s = regionprops(L == i, 'Area','Centroid','BoundingBox','Perimeter','Eccentricity');
    aire =  cat(1,s.Area);

    if aire >30000 && aire <47000
        v = 0.02;
    elseif aire > 47000 && aire < 70000
        v = 0.2;
    elseif aire > 70000 && aire < 75000
        v = 2;
    else
        v = 0;
    end

    somme = somme + v;
 end

 fprintf('La somme totale des pièces de M5 vaut %.2f euros pour d=%.2f.\n', somme,d(j));

 if somme < round(6.28)

   m=sum((I(:)-I_b(:)).^2)/(h*l);

   Q=sqrt(m);
   fprintf('Le diagnostic n est plus bon pour Q = %.2f(d=%.2f) .\n', Q,d(j));
 endif
end


