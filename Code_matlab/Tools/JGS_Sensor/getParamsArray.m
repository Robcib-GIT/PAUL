%% Getting params for all the measurements and storing them in an array
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-13

dirName = 'Tools/JGS_ImagenesMedir/';
resDir = dir(dirName);
files = {resDir.name};

s = [0 0 0 1 1 1 1 2 2 2 2 2 2 2 2 2 2];

%% Cargamos los resultados que queremos
params = zeros(length(files)-3, 4);
for i = 3:length(files)-1
    load(strcat(dirName, '/', files{i}));
    pAux = getParams(s(i-2), l, voltages);
    params(i-2,:) = [pAux.nSensor, pAux.mV, pAux.mL, pAux.mLt];
end