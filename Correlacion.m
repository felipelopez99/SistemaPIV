%% Programa que realiza la correlacion para calcular la velocidad de la particulas
%Autor: Felipe López Padilla.

function [vx, vy, media, dv] = Correlacion(imagen1,imagen2,tam_ven,dt,FI,FR,M)
% ARGUMENTOS DE LA FUNCION
%  - im1:       Primera imagen
%  - im2:       Segunda imagen
%  - tam_ven:   Vector [ancho alto] que contiene en tamaño del
%  subdominio
%  - dt:        Diferencia de tiempo entre imagenes
%  - FI:        Variable lógica para aplicar filtro a las imagenes
%  - FR:        Variable lógica para aplicar filtro a los vectores
% SALIDAS
%  - vx: Componente horizontal del vector de desplazamiento.
%  - vy: componente vertical del vector de desplazamiento.
%  - media: Media del modulo de los vectores de desplazamiento.
%  - dv: Deviacion tipica del modulo de los vectores de desplazamiento.



if FI ==1 %Si se ha elegido hacer filtro de imagen se hace
    imagen1 = Tratamiento(imagen1);
    imagen2 = Tratamiento(imagen2);
end

%Se obtiene el tamaño de las imagenes (las dos tienen el mismo tamaño)
[xmax, ymax] = size(imagen1);

%Se obtiene el tamaño de ventana seleccionado
v_ancho = tam_ven(1);
v_alto = tam_ven(2);

%Vectores que almacenan la posicion de cada centro de ventana:
%Desde una posicion mas que el ancho de ventana hasta el final menos el
%ancho de ventana en saltos de ancho medios
x_grid = (1+v_ancho):v_ancho/2:(xmax-v_ancho);
y_grid = (1+v_alto):v_alto/2:(ymax-v_alto);
%Se deja esa separacion en el medio ya que luego se va a buscar en la
%imagen 2 a la izquierda y derecha, en lo extremos nos saldriamos de la
%imagen

%Numero de ventanas: longitud de los arrays
nVen_x = length(x_grid);
nVen_y = length(y_grid);

%Lo que se va a mover la ventana de busqueda en la segunda imagen:
x_disp_max = v_ancho/2;
y_disp_max = v_alto/2;

%Vectores que almacenan los vectores de desplazamento, se inicializan
dx(nVen_x, nVen_y) = 0;
dy(nVen_x, nVen_y) = 0;

%Se recorre cada ventana, de columna en columna
for i=1:nVen_x
    for j=1:nVen_y
        %Valores del rectangulo de ventana en cada ciclo:
        test_xmin = x_grid(i)-v_ancho/2;
        test_xmax = x_grid(i)+v_ancho/2;
        test_ymin = y_grid(j)-v_alto/2;
        test_ymax = y_grid(j)+v_alto/2;
        %Se centra la ventana en la imagen 1->Ventana de prueba 1
        test_im1 = imagen1(test_xmin:test_xmax, test_ymin:test_ymax);
        %Se centra la ventana aumentada media ventana para cada lado en la
        %imagen 2-> Ventana de prueba 2
        test_im2 = imagen2((test_xmin-x_disp_max):(test_xmax+x_disp_max),(test_ymin-y_disp_max):(test_ymax+y_disp_max));
        %Se calcula la correlacion entre las ventanas de prueba 1 y 2
        corr = normxcorr2(test_im1,test_im2);
        %Se  busca el valor maximo en la correlacion:
        [x_pico,y_pico] = find(corr==max(corr(:)));
        %Se reescala el valor para conocer su posicion:
        x_pico(1) = test_xmin + x_pico(1) - v_ancho/2 - x_disp_max;
        y_pico(1) = test_ymin + y_pico(1) - v_alto/2 - y_disp_max;
        %Se calcula el desplazamiento como la resta del pico menos el
        %centro de ventana
        dx(i,j) = x_pico(1) - x_grid(i);
        dy(i,j) = y_pico(1) - y_grid(j);
    end
end
%Se calcula la velocidad en pixeles/s
vx = dx*1000/dt;
vy = dy*1000/dt;
%Se calcula la media y desviacion tipica del modulo de los vectores:
num_ven=nVen_x*nVen_y;
modulos=zeros(1,num_ven);
c=0;
%Se almacena los modulos en un vector
for i=1:size(vx,1)
    for j=1:size(vx,2)
        c=c+1;
        modulos(c)=sqrt((vx(i,j))^2 +(vy(i,j))^2);
    end
end
%Se calcula la media y desviacion tipica del vector que almacena los
%modulos

if FR ==1 %Variable de filtrado de resultado=1 -> se aplica filtro
    [vx, vy] = FiltroVectores(vx,vy,media,dv);
end
if nargin ==7 %Se ha dado el factor de magnificacion: se pasa a cm
    vx = vx / M;
    vy = vy / M;
    media=mean(modulos/M);
    dv=std(modulos/M);
    %Se representa los vectores de velocidad
    subplot(4,4,[7,8,11,12]);
    quiver(vy,-vx);
    %Título a la gráfica de los vectores
    [~,s] = title('Velocidad de las particulas',['Media = ',num2str(media),' cm/s ; σ = ',num2str(dv),' cm/s']);
    s.FontAngle = 'italic';
    %Se calcula el campo escalar de cada componente
    subplot(4,4,[1,2,5,6]);
    CampoEscalar(vy,'X');
    c=colorbar;
    c.Label.String = 'Velocidad (cm/s)';
    subplot(4,4,[9,10,13,14]);
    CampoEscalar(-vx,'Y');
    d=colorbar;
    d.Label.String = 'Velocidad (cm/s)';
else
    media=mean(modulos);
    dv=std(modulos);
    %Se representa los vectores de velocidad
    subplot(4,4,[7,8,11,12]);
    quiver(vy,-vx);
    %Título a la gráfica de los vectores
    [~,s] = title('Velocidad de las particulas',['Media = ',num2str(media),' pixeles/s ; σ = ',num2str(dv),' pixeles/s']);
    s.FontAngle = 'italic';
    %Se calcula el campo escalar de cada componente
    subplot(4,4,[1,2,5,6]);
    CampoEscalar(vy,'X');
    c=colorbar;
    c.Label.String = 'Velocidad (pixeles/s)';
    subplot(4,4,[9,10,13,14]);
    CampoEscalar(-vx,'Y');
    d=colorbar;
    d.Label.String = 'Velocidad (pixeles/s)';  
end
