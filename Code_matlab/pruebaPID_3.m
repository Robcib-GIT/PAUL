%% Pruebas PID con 3 longitudes
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-19

close all

%% Configuración
tol = 1e-5;
maxAction = 100;
maxIter = 15;
Vmin = 8.8;
Vmax = 8.97;
T = NaT(3, maxIter);
A = zeros(3, maxIter);

%xobj = [127 -37 -79]';
%Lobj = MCI(xobj)';
Lobj = [84 95 152]';
Vobj = -0.0038 * Lobj + 9.34;

%% PID

% Saturación
for valv = 1:3
    if Vobj(valv) < Vmin
        Vobj(valv) = Vmin;
        fprintf('Se satura por mínimo la válvula %d\n', valv)
    end
    if Vobj(valv) > Vmax
        Vobj(valv) = Vmax;
        fprintf('Se satura por máximo la válvula %d\n', valv)
    end
end


K = 500;
r.Measure();

Tor = datetime('now');
for valv = 1:3
    fprintf('Empezamos con la válvula número %d\n', valv-1);
    niter = 0;
    error = 1e12;
    while norm(error) > tol && niter < maxIter
        niter = niter + 1;
    
        % Acción
        if error > 0 
            action = min(K*error, maxAction);
        else
            action = max(K*error, -maxAction);
        end
        r.WriteOneValveMillis(valv-1, action);
        A(valv,niter) = action;
        T(valv,niter) = datetime('now');
    
        % Medida
        r.Measure()
        error = r.voltages(valv,end) - Vobj(valv);
    end
end

% Error final
pos2 = r.R * r.CapturePosition();
errorFin = norm(pos2 - xobj);
disp(errorFin)

%% Gráficas
T1 = seconds(T-Tor) * 1000;
figure;
subplot(1,2,1)
hold on
for valv = 1:3
    plot(T1(valv,1:niter), r.voltages(valv,3:end))
end
hold off
title('Measured voltages')

subplot(1,2,2)
hold on
for valv = 1:3
    plot(T1(valv,1:niter), A(valv,3:end))
end
hold off
title('Milliseconds sent')