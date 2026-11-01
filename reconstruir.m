function xr = reconstruir(a0, a, b, t, T)
% RECONSTRUIR  Suma de los N primeros armonicos de la serie de Fourier.
    w0 = 2*pi/T;
    xr = a0 * ones(size(t));
    for k = 1:numel(a)
        xr = xr + a(k)*cos(k*w0*t) + b(k)*sin(k*w0*t);
    end
end
