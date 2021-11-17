function RGB = EscalaColores(m)
[ancho, largo] = size(m);
R = zeros(ancho,largo);
G = zeros(ancho,largo);
B = zeros(ancho,largo);

    n = 1.75; % Exponente
    rC = 0.25; % Posición del cian (0 0.5)
    rA = 0.75; % Posición del amarillo (0.5 1)
    
    for i=1:ancho
        for j=1:largo
            l = m(i,j);
   if l < rC && l >= 0
        R(i,j) = 0;
        G(i,j) = 0 + (l/rC)^(1/n);
        B(i,j) = 1;
    elseif l < 0.5
        R(i,j) = 0;
        G(i,j) = 1;
        B(i,j) = 1 - ((l - rC)/(0.5 - rC))^n;
    elseif l < rA
        R(i,j) = 0 + ((l - 0.5)/(rA - 0.5))^(1/n);
        G(i,j) = 1;
        B(i,j) = 0;
    elseif l <= 1
        R(i,j) = 1;
        G(i,j) = 1 - ((l - rA)/(1 - rA))^n;
        B(i,j) = 0;
   end
        end
    end
    RGB(:,:,1) = R;
    RGB(:,:,2) = G;
    RGB(:,:,3) = B;
end
