function [a0, a, b] = coeficientes(sig, N, T)
% COEFICIENTES  Coeficientes de la serie trigonometrica de Fourier
%   x(t) = a0 + sum_{k=1}^{N} [ a_k cos(k w0 t) + b_k sin(k w0 t) ]
%   Valores analiticos (deducidos a mano).  T no altera a_k, b_k.
    k  = 1:N;
    a0 = 0;
    a  = zeros(1, N);
    b  = zeros(1, N);
    impar = (mod(k, 2) == 1);
    switch sig
        case 1   % Cuadrada: b_k = 4/(pi k), k impar
            b(impar) = 4 ./ (pi*k(impar));
        case 2   % Triangular: a_k = 8/(pi^2 k^2), k impar
            a(impar) = 8 ./ (pi^2 * k(impar).^2);
        case 3   % Sierra: b_k = 2(-1)^(k+1)/(pi k)
            b = 2 * (-1).^(k+1) ./ (pi*k);
        otherwise
            error('Senal no valida.');
    end
end
