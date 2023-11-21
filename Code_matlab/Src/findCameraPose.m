function [rotation,translation] = findCameraPose(cam, cameraPar)

% Tomamos imagen de calibracion
img = snapshot(cam);

% Corregimos distorsion de la lente
[im,~] = undistortImage(img, cameraPar, 'OutputView','full');

% Deteccion del patron
[imagePoints,boardSize] = detectCheckerboardPoints(im);
squareSize = 20; % Tamano del tablero en mm
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Obtencion de los parametros extrinsics
[rotationMatrix, translationVector] = extrinsics(imagePoints,worldPoints,cameraPar);

% Se muestra gráficamente la posición de la camara
[orientation, location] = extrinsicsToCameraPose(rotationMatrix, translationVector);
figure
plotCamera('Location',location,'Orientation',orientation,'Size',20);
hold on
pcshow([worldPoints,zeros(size(worldPoints,1),1)],'VerticalAxisDir','down','MarkerSize',40);

rotation = rotationMatrix;
translation = translationVector;
end