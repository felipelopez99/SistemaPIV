function[resultado] = CampoEscalar(modulos,eje)
%Funcion que calcula el campo escalar de una de las componentes
%Se crean dos matrices X,Y que van desde 1 hasta el numero de ventanas
%Esto crea una superficie con cada ventana
x = 1:1:size(modulos,1);
y = 1:1:size(modulos,2);
[X,Y] = meshgrid(y,x);
%Se representa en cada ventana el modulo de la velocidad
surf(X,Y,modulos);
title(['Campo escalar de la velocidad en ',eje]);
%Se observa desde arriba
view(2)
end