%%Programa que analiza los vectores calculados para descartar outliers.
%Autor: Felipe López Padilla.

function [U, V] = FiltroVectores(X,Y,media,dv)
%PARAMETROS DE ENTRADA
%X: Componente horizontal de los vectores calculados.
%Y: Componente vertical de los vectores calculados
%media: Media del modulo de los vectores
%dv: Desviacion tipica del modulo de los vectores

%PARAMETROS DE SALIDA
%U: Componente horizontal de los vectores una vez tratados
%V: Componente vertical de los vectores una vez tratados

tam_X = size(X,1);
tam_Y = size(X,2);
num_celdas = tam_X * tam_Y;
U = zeros(tam_X,tam_Y);
V = zeros(tam_X,tam_Y);
c=0; %Numero de outliers

while (c-1)/num_celdas>0.05 || c==0
    %Se realizan interpolaciones hasta que el num de outliers sea menor que
    %el 5%
    c=1;
for i=1:tam_X
    for j=1:tam_Y
        pos_x = X(i,j);
        pos_y = Y(i,j);
        if abs((sqrt(pos_x^2+pos_y^2))-media)<3*dv
            U(i,j) = X(i,j);
            V(i,j) = Y(i,j);
        else
            [U(i,j),V(i,j)] = interpola(X,Y,i,j);
            c=c+1;
        end
    end
end
end
end
function [x_s, y_s] = interpola(X,Y,i,j)
%Funcion que interpola los valores de los 8 vectores vecinos
%PARAMETROS DE ENTRADA:
%X: Componente horizontal de los vectores calculados
%Y: Componente vertical de los vectores calculados
%i: Fila de ventana seleccionada
%j: Columna de ventana seleccionada
%----------> j
%|
%|
%|
%|
%V
%i

%Parametros de salida:
%x_s: Componente horizontal del vector interpolado
%y_s: Componente vertical del vector interpolado




if i==1 %Primera fila
    if j==1 %y primera columna (3 vecinos)
        x_s = ( X(i,j+1) + X(i+1,j+1) +X(i+1,j))/3;
        y_s = ( Y(i,j+1) + Y(i+1,j+1) +Y(i+1,j))/3;
    elseif j==size(X,2) %y ultima columna (3 vecinos)
        x_s = (X(i,j-1) +X(i+1,j-1) +X(i+1,j))/3;
        y_s = (Y(i,j-1) +Y(i+1,j-1) +Y(i+1,j))/3;
    else
    %Columna intermedia (5 vecinos)
        x_s=(X(i,j-1) +X(i+1,j-1) +X(i+1,j) +X(i+1,j+1) +X(i,j+1))/5;
        y_s=(Y(i,j-1) +Y(i+1,j-1) +Y(i+1,j) +Y(i+1,j+1) +Y(i,j+1))/5;   
    end


elseif i==size(X,1) %Ultima fila
    if j==1 %Y primera columna (3 vecinos)
        x_s=(X(i-1,j) +X(i-1,j+1) +X(i,j+1))/3;
        y_s=(Y(i-1,j) +Y(i-1,j+1) +Y(i,j+1))/3;
    
    elseif j==size(X,2) %Y ultima columna (3 vecinos)
        x_s=(X(i-1,j) +X(i-1,j-1) +X(i,j-1))/3;
        y_s=(Y(i-1,j) +Y(i-1,j-1) +Y(i,j-1))/3;
    else
        %Columna intermedia (5 vecinos)
        x_s=(X(i,j-1) +X(i-1,j-1) +X(i-1,j) +X(i-1,j+1) +X(i,j+1))/5;
        y_s=(Y(i,j-1) +Y(i-1,j-1) +Y(i-1,j) +Y(i-1,j+1) +Y(i,j+1))/5;       
    end   
end

if j==1 && i~=1 && i~=size(X,1) %Primera columna
    %Fila intermedia (5 vecinos)
    x_s =(X(i-1,j) +X(i-1,j+1) +X(i,j+1) +X(i+1,j+1) +X(i+1,j))/5;
    y_s =(Y(i-1,j) +Y(i-1,j+1) +Y(i,j+1) +Y(i+1,j+1) +Y(i+1,j))/5;
elseif j==size(X,2)&& i~=1 && i~=size(X,1) %Ultima columna
    %Fila intermedia(5 vecinos)
    x_s=(X(i-1,j) +X(i-1,j-1) +X(i,j-1) +X(i+1,j-1) +X(i+1,j))/5;
    y_s=(Y(i-1,j) +Y(i-1,j-1) +Y(i,j-1) +Y(i+1,j-1) +Y(i+1,j))/5;
end

if i~=1 && i~=size(X,1) && j~=1 && j~=size(X,2)
    %Fila y columna intermedia (8 vecinos)
    x_s=(X(i-1,j) +X(i-1,j+1) +X(i,j+1) +X(i+1,j+1) +X(i+1,j) +X(i+1,j-1) +X(i,j-1) +X(i-1,j-1))/8;
    y_s=(Y(i-1,j) +Y(i-1,j+1) +Y(i,j+1) +Y(i+1,j+1) +Y(i+1,j) +Y(i+1,j-1) +Y(i,j-1) +Y(i-1,j-1))/8;
end
end