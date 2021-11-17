%%Programa que trata la imagen, pasandola a escala de grises y aplicandole
%%un filtro de mediana para eliminar ruido

%Autor: Felipe López Padilla

function [imout] = Tratamiento(imin,x)
%Parametros de entrada:
%imin: imagen de entrada a color, ya en matriz.
%x: densidad de ruido, por defecto se toma 0.02

if nargin == 1
    x=0.02;
end
%Se pasa la imagen a escala de grises
imin = im2gray(imin);
%Se le aplica un ruido de sal y pimienta
imin2 = imnoise(imin,'salt & pepper',x);
%Para posteriormente obtener la imagen filtrada a traves de la media
imout = medfilt2(imin2);
imshowpair(imin,imout,'montage');
title('Imagen sin filtrar             Imagen filtrada ');
end


