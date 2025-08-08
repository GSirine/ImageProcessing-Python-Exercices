clear all, close all, clc ;
pkg load image;
pkg load signal;

Ia = imread('M7.jpg');
%étendre la dynamique

Aa = imadjust(Ia, [0.2 0.7], [0 1]);

% Normalisation des images dans le canal rouge et vert
A1=double(Aa(:,:,1));
A2=double(Aa(:,:,2));
%A3=double(A(:,:,3));

A1 = A1./max(max(A1));
A2 = A2./max(max(A2));

% binarisation manuelle
%SE=strel ("diamond", 7);

Ab1 = im2bw(A1,0.6);

Ab1=imfill(Ab1,'holes');



Ab2 = ~im2bw(A2,0.3);
Ab2=imfill(Ab2,'holes');
SE=strel ("diamond", 3);
Ab2=imerode(Ab2,SE);
Ab2=imdilate(Ab2,SE);

% Labelisé Ab2 pour détecter le nombre d'objets afin de supprimer ceux qui ne sont pas circulaires
[I_lab, n] = bwlabel(Ab2, 4);
figure,
imagesc(Ab2),colormap(gray)
colorbar,
title(['image  Ab2 labellisée contenant ',num2str(n),' objet(s)']);
reg = regionprops(I_lab,'Area','BoundingBox');

aire= cat(1,reg.Area);
boundy = cat(1,reg.BoundingBox);

for i = 1:numel(reg)
    % Récupère les propriétés de la bounding box
    bbox = reg(i).BoundingBox;
    % Récupère les surfaces de l'objet
    size = reg(i).Area;
    % supprime l'objet de petite taille de l'image binaire dans le canal vert
    if size < 30000

        x = round(bbox(1));
        y = round(bbox(2));
        width = round(bbox(3));
        height = round(bbox(4));
        Ab2(y:y+height-1, x:x+width-1) = 0;
    end
end
Ab2=Ab2;


%additin des images binaires du canal vert et rouge
Ab=Ab1+Ab2;
Ab=im2bw(Ab);

Ab=imfill(Ab,'holes');

%erosion
se=strel ("diamond", 3);
for i=1:2
 ie1=imerode(Ab,se);
 ie2=ie1;
endfor
ie=ie2;
figure,
imagesc(ie);colormap(gray);
for i=1:2
 id1=imerode(ie,se);
 id2=id1;
endfor
id=id1;

% Image labelisé contenant nombre d'objet
[L, num] = bwlabel(id, 4);

figure,
imagesc(id),colormap(gray)
colorbar,
title(['image labellisee contenant ',num2str(num),' objet(s)']);
% Détection des contours
[B,L] = bwboundaries(id,4);

title(['image labellisee contenant ',num2str(num),' objet(s)']);
hold on
% tracé un contour vert autour de chaque objet détecté
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end

%hold off

%s = regionprops(L,'Area','Centroid','BoundingBox','Perimeter','Eccentricity');
%calcul de la somme en euro des pièces
somme=0;
for i = 1:num
    s = regionprops(L == i, 'Area','Centroid','BoundingBox','Perimeter','Eccentricity');
    aire =  cat(1,s.Area);



    % valeur de la pièce en fonction de sa surface
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

fprintf('La somme totale des pièces de M7 vaut %.2f euros.\n', somme);
figure,
imagesc(Ia);colormap(gray)
title(['Image M7 contient ',num2str(somme),' €']);

