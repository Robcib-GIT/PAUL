function [error, tr, net] = MCDNeur(n, puntosP, puntosq)
    
%     n = 50000

      
%     load('2020-09-09-puntos-12000.mat')
    % Red neuronal de 3 capas, 2 entradas y 1 salida
    % El número de neuronas es 2/3*tamaño entrada + tamaño salida
    % Errores muy pequeños, sobretodo con [5 5]
    net = feedforwardnet([5 5 3]);

    % Probamos con función de activación
%     net.layers{1}.transferFcn = 'logsig';
%     net.layers{2}.transferFcn = 'satlin';
    net.layers{3}.transferFcn = 'logsig';
    % net.layers{1}.transferFcn = 'softmax';
    % net.layers{2}.transferFcn = 'satlin';
    % net.layers{3}.transferFcn = 'softmax';

    net.trainFcn = 'trainbfg';

    net.trainParam.showCommandLine = true;
    net.trainParam.max_fail = 10;
    net.trainParam.lr = 1e-6;
    net.trainParam.mc = 0.7;
    net.performParam.regularization = 0.5;
    
%     net.performFcn = 'msesparse';

    % options = trainingOptions('InitialLearnRate', 1e-5, 'Momentum', 0.6);
    %     'MaxEpochs',60, ...
    %     'LearnRateDropPeriod',1,...
    %     'LearnRateSchedule','piecewise',...
    %     'ValidationData',{valImages,valLabels},...
    %     'ValidationFrequency',50,...

    % Número de repeticiones
%     n = 10000;

    % Para determinar el número de entradas y salidas
    rango = 1:length(puntosq);
    a = puntosq(rango,:);
    b = puntosP(rango,:);
    x = zeros(3, n);
    y = zeros(3, n);

    % Bajo máximo, pero tampoco se mejora mucho el mínimo
    % net.divideParam.trainRatio = .8;
    % net.divideParam.valRatio = .05;
    % net.divideParam.testRatio = .15;

    % % Similar o mejor a la anterior
    % net.divideParam.trainRatio = .6;
    % net.divideParam.valRatio = .15;
    % net.divideParam.testRatio = .25;

    % Datos de entrenamiento
    for k = 1:n
        j = randi([1 length(rango)]);
    %     x(:,k) = a(j,4:6);
        x(:,k) = a(j,:);
        y(:,k) = b(j,:);
    end

    %  x = x + [0.5 2.5 -1.5]*ones(size(x));
    %  x = wrapToPi(x);

    % histogram(x(1,:));
    % figure
    % histogram(x(2,:));
    % figure
    % histogram(x(3,:));
    % figure

    % Transformarmos las posiciones para homogeneizar errores
    initialIntX = [min(y(1,:)) max(y(1,:))];
    initialIntY = [min(y(2,:)) max(y(2,:))];
    initialIntPhi = [min(y(3,:)) max(y(3,:))];
    newInt = [-1 1];
    newIntPhi = newInt/6;

    y(1,:) = transformData(y(1,:), initialIntX, newInt);
    y(2,:) = transformData(y(2,:), initialIntY, newInt);
    y(3,:) = transformData(y(3,:), initialIntPhi, newIntPhi);

    % newIntQ = [-1 1];
    % x(1,:) = transformData(x(1,:), [min(x(1,:)) max(x(1,:))], newIntQ);
    % x(2,:) = transformData(x(2,:), [min(x(2,:)) max(x(2,:))], newIntQ);
    % x(3,:) = transformData(x(3,:), [min(x(3,:)) max(x(3,:))], newIntQ);

    % Transformación de ángulos
    x = transformAngle(x);

    net = configure(net, x, y);
    net.name = 'Robot 3RRR';
    [net, tr] = train(net, x, y);

    % Datos de comprobación
    V = [-0.2042 1.0475 0.1893;
         -.2524 1.014 -2.613;
         .2997 2.468 2.72;
         .2997 2.468 2.72;
         -.3255 -.2541 -1.557]';

     R = [0.3 0.2 0;
          0.3 0.2 0.1;
          0.1 0.2 0;
          .297 .3 .3;
          0.4 0.1 -0.2]';

    c = zeros(3, size(R,2));
    s = zeros(size(R,2), 1);

    V = transformAngle(V);

    % V(1,:) = transformData(V(1,:), [min(V(1,:)) max(V(1,:))], newIntQ);
    % V(2,:) = transformData(V(2,:), [min(V(2,:)) max(V(2,:))], newIntQ);
    % V(3,:) = transformData(V(3,:), [min(V(3,:)) max(V(3,:))], newIntQ);

    for i = 1:length(V)
        c(:,i) = sim(net, V(:,i));
        %disp(c);
    end

    % Revertimos la transfomración
    c(1,:) = transformData(c(1,:), newInt, initialIntX);
    c(2,:) = transformData(c(2,:), newInt, initialIntY);
    c(3,:) = transformData(c(3,:), newIntPhi, initialIntPhi);

    % c(3,:) = transformData(c(3,:), [0 .1], [-1.2 1.2]);


    for i = 1:size(V,2)
        s(i) = norm(c(:,i) - R(:,i), 2);
    end

    error = min(s);
    
end