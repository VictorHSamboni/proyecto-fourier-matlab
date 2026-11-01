function x = senal(sig, t, T)
% SENAL  Senal periodica ideal (amplitud 1, periodo T).
%   sig = 1 cuadrada | 2 triangular | 3 diente de sierra
    switch sig
        case 1   % Cuadrada: +1 en [0,T/2), -1 en [T/2,T)
            tau = t - T*floor(t/T);
            x = ones(size(t));
            x(tau >= T/2) = -1;
        case 2   % Triangular par: x(0)=1, x(T/2)=-1
            tau = t - T*floor(t/T);
            d = min(tau, T - tau);
            x = 1 - 4*d/T;
        case 3   % Diente de sierra: rampa de -1 a 1 en [-T/2,T/2)
            tau = t - T*floor(t/T + 0.5);
            x = 2*tau/T;
        otherwise
            error('Senal no valida.');
    end
end
