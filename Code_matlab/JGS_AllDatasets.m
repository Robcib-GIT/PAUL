%% Propiedades de todos los datasets

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-17

% Listamos todos los datasets
datList = dir(fullfile('.','dataset_*.mat'));

% Cargamos cada dataset, sacamos de él las propiedades interesantes y lo
% metemos en el grande
datosTodo.inputs = [];
datosTodo.outputs = [];
for i = 1:length(datList)
    load(datList(i).name);
    
    if (isfield(data,'pmax'))
        datInfo(i).pmax = data.pmax;
    end
    if (isfield(data,'pmin'))
        datInfo(i).pmin = data.pmin;
    end
    if (isfield(data,'temp_amb'))
        datInfo(i).temp_amb = data.temp_amb;
    end
    if (isfield(data,'presion_presostato'))
        datInfo(i).presion_presostato = data.presion_presostato;
    end
    if (isfield(data,'maxRpressure'))
        datInfo(i).maxRpressure = data.maxRpressure;
    end
    if (isfield(data,'nummuestras'))
        datInfo(i).nummuestras = data.nummuestras;
    end
    if (isfield(data,'elapsed_time'))
        datInfo(i).elapsed_time = data.elapsed_time;
    end

    datosTodo.inputs = [datosTodo.inputs; data.inputs];
    datosTodo.outputs = [datosTodo.outputs; data.outputs];
end
