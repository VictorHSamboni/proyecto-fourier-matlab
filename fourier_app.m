function fourier_app
% FOURIER_APP  Reconstruccion de senales periodicas con series de Fourier.
%   Ejecutar:  >> fourier_app
%   Requiere en la misma carpeta: senal.m, coeficientes.m, reconstruir.m

    T     = 1;                                  % periodo fijo [s]
    f0    = 1/T;                                % frecuencia fundamental [Hz]
    Nlist = [1 2 3 5 10 20 50 100 150 200];      % armonicos permitidos (RF3)
    nombres = {'A: Cuadrada','B: Triangular','C: Diente de sierra'};

    fig = figure('Name','Reconstruccion de senales - Series de Fourier', ...
                 'NumberTitle','off','Color',[0.94 0.94 0.94], ...
                 'Units','normalized','Position',[0.05 0.08 0.9 0.82]);

    % ---------- Panel de control ----------
    p = uipanel('Parent',fig,'Title','Parametros','Position',[0.01 0.01 0.21 0.98]);
    etiqueta(p,'Senal',0.93);
    pSig = uicontrol(p,'Style','popupmenu','String',nombres,'Value',1, ...
        'Units','normalized','Position',[0.05 0.87 0.9 0.05],'Callback',@actualizar);
    etiqueta(p,'Numero de armonicos N',0.80);
    pN = uicontrol(p,'Style','popupmenu','String',cellstr(num2str(Nlist(:))),'Value',5, ...
        'Units','normalized','Position',[0.05 0.74 0.9 0.05],'Callback',@actualizar);
    etiqueta(p,'Tiempo inicial [s]',0.67);
    eT1 = uicontrol(p,'Style','edit','String','-2','Units','normalized', ...
        'Position',[0.05 0.62 0.9 0.05],'Callback',@actualizar);
    etiqueta(p,'Tiempo final [s]',0.55);
    eT2 = uicontrol(p,'Style','edit','String','2','Units','normalized', ...
        'Position',[0.05 0.50 0.9 0.05],'Callback',@actualizar);
    uicontrol(p,'Style','pushbutton','String','Actualizar','Units','normalized', ...
        'Position',[0.05 0.41 0.9 0.06],'Callback',@actualizar);
    txtMet = uicontrol(p,'Style','text','Units','normalized','HorizontalAlignment','left', ...
        'Position',[0.05 0.02 0.9 0.35],'FontSize',10,'String','');

    % ---------- Ejes ----------
    ax1 = axes('Parent',fig,'Position',[0.28 0.76 0.69 0.19]);
    ax2 = axes('Parent',fig,'Position',[0.28 0.53 0.69 0.19]);
    ax3 = axes('Parent',fig,'Position',[0.28 0.30 0.69 0.19]);
    ax4 = axes('Parent',fig,'Position',[0.28 0.06 0.69 0.19]);

    actualizar();

    % ---------- Funciones internas ----------
    function etiqueta(padre, txt, y)
        uicontrol(padre,'Style','text','String',txt,'Units','normalized', ...
            'HorizontalAlignment','left','Position',[0.05 y 0.9 0.04]);
    end

    function actualizar(~,~)
        try
            sig = get(pSig,'Value');
            N   = Nlist(get(pN,'Value'));
            ti  = str2double(get(eT1,'String'));
            tf  = str2double(get(eT2,'String'));
            if ~isfinite(ti) || ~isfinite(tf)
                error('Los limites del intervalo deben ser numeros validos.');
            end
            if tf <= ti
                error('El tiempo final debe ser mayor que el inicial.');
            end
            if (tf - ti) > 20*T
                error('El intervalo no puede superar 20 periodos (T = %g s).', T);
            end

            [a0, a, b] = coeficientes(sig, N, T);

            % Senales en el intervalo de visualizacion
            np = min(max(2000, round(1000*(tf-ti)/T)), 40000);
            t  = linspace(ti, tf, np);
            x  = senal(sig, t, T);
            xr = reconstruir(a0, a, b, t, T);
            e  = abs(x - xr);

            % Metricas sobre un periodo completo (malla de puntos medios)
            M  = 20000;
            tp = ((0:M-1) + 0.5) * T / M;
            xp  = senal(sig, tp, T);
            xrp = reconstruir(a0, a, b, tp, T);
            mse = sqrt(mean((xp - xrp).^2));       % definicion del documento
            P0  = mean(xp.^2);
            Pr  = mean(xrp.^2);
            Pr_parseval = a0^2 + 0.5*sum(a.^2 + b.^2);

            plot(ax1, t, x,  'b','LineWidth',1.3); grid(ax1,'on');
            title(ax1,['Senal original - ' nombres{sig}]); ylabel(ax1,'x(t)');
            xlim(ax1,[ti tf]); ylim(ax1,[-1.3 1.3]);

            plot(ax2, t, xr, 'r','LineWidth',1.3); grid(ax2,'on');
            title(ax2,sprintf('Senal reconstruida (N = %d)',N)); ylabel(ax2,'x^(t)');
            xlim(ax2,[ti tf]); ylim(ax2,[-1.3 1.3]);

            plot(ax3, t, e, 'k','LineWidth',1.0); grid(ax3,'on');
            title(ax3,'Error |x(t) - x^(t)|'); ylabel(ax3,'|e(t)|'); xlabel(ax3,'t [s]');
            xlim(ax3,[ti tf]);

            kk  = 0:N;
            amp = [abs(a0), sqrt(a.^2 + b.^2)];
            stem(ax4, kk*f0, amp, 'filled','MarkerSize',3); grid(ax4,'on');
            title(ax4,'Espectro de linea (amplitud de cada armonico)');
            xlabel(ax4,'Frecuencia [Hz]  (k \cdot f_0)'); ylabel(ax4,'|c_k|');
            xlim(ax4,[-0.5*f0, (N+0.5)*f0]);

            set(txtMet,'String',sprintf(['MSE (con raiz):\n  %.6g\n\n' ...
                'Potencia original:\n  %.6f\n\nPotencia reconstruida:\n  %.6f\n' ...
                '  (Parseval: %.6f)'], mse, P0, Pr, Pr_parseval));
            drawnow;
        catch ME
            errordlg(ME.message, 'Error');
        end
    end
end
