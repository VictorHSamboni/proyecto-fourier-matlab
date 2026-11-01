% CALCULAR_TABLA  Tabla de resultados (MSE y potencias vs N) y graficas.
%   Ejecutar:  >> calcular_tabla
%   Genera resultados_fourier.xlsx y tres figuras por senal.
clear; clc; close all;

T     = 1;
Nlist = [1 2 3 5 10 20 50 100 150 200];
nombres = {'Cuadrada','Triangular','Diente de sierra'};
M  = 20000;
tp = ((0:M-1) + 0.5) * T / M;           % malla de puntos medios (un periodo)
w0 = 2*pi/T;

% --- Verificacion: coeficientes analiticos vs integracion numerica propia ---
for sig = 1:3
    x = senal(sig, tp, T);
    [~, a, b] = coeficientes(sig, 20, T);
    dif = 0;
    for k = 1:20
        ak = (2/T) * sum(x .* cos(k*w0*tp)) * (T/M);
        bk = (2/T) * sum(x .* sin(k*w0*tp)) * (T/M);
        dif = max([dif, abs(ak - a(k)), abs(bk - b(k))]);
    end
    fprintf('Verificacion %-18s: max |coef numerico - analitico| = %.2e\n', nombres{sig}, dif);
end

% --- Tabla ---
for sig = 1:3
    x  = senal(sig, tp, T);
    P0 = mean(x.^2);
    R  = zeros(numel(Nlist), 3);       % [MSE, P_original, P_reconstruida]
    for i = 1:numel(Nlist)
        N = Nlist(i);
        [a0, a, b] = coeficientes(sig, N, T);
        xr = reconstruir(a0, a, b, tp, T);
        R(i,:) = [sqrt(mean((x - xr).^2)), P0, mean(xr.^2)];
    end
    res{sig} = R;

    fprintf('\n=== %s ===\n', nombres{sig});
    fprintf('%10s %18s %18s %18s\n','N','MSE','P. original','P. reconstruida');
    for i = 1:numel(Nlist)
        fprintf('%10d %18.6e %18.6f %18.6f\n', Nlist(i), R(i,1), R(i,2), R(i,3));
    end

    % --- Graficas ---
    figure('Name',['Resultados - ' nombres{sig}],'NumberTitle','off');
    subplot(1,2,1);
    loglog(Nlist, R(:,1), 'o-','LineWidth',1.4); grid on;
    xlabel('N armonicos'); ylabel('MSE'); title(['MSE vs N - ' nombres{sig}]);
    subplot(1,2,2);
    semilogx(Nlist, R(:,3), 's-','LineWidth',1.4); hold on;
    semilogx(Nlist, R(:,2), 'r--','LineWidth',1.2); grid on;
    xlabel('N armonicos'); ylabel('Potencia');
    title(['Potencia vs N - ' nombres{sig}]);
    legend('Reconstruida','Original','Location','southeast');
end

% --- Exportar a Excel ---
try
    for sig = 1:3
        tabla = array2table([Nlist(:), res{sig}], ...
            'VariableNames', {'N','MSE','P_original','P_reconstruida'});
        writetable(tabla, 'resultados_fourier.xlsx', 'Sheet', nombres{sig});
    end
    disp('Tabla exportada a resultados_fourier.xlsx');
catch ME
    warning('No se pudo exportar a Excel: %s', ME.message);
end
