% Funcion para combinar los datos de 2 datasets generados mediante la
% herramienta "Interfaz.m"

function [data] = dataset_combinator(arg1, arg2)



% Comprobamos si el numero de argumentos es correcto y si los datasets son
% combinables
if nargin > 1 && nargin <= 2

    if (arg1.temp_amb == arg2.temp_amb) && (arg1.maxRpressure == arg2.maxRpressure) 

        data_p.outputs(1:arg1.nummuestras, :) = arg1.outputs(1:arg1.nummuestras, :);
        data_p.inputs(1:arg1.nummuestras, :) = arg1.inputs(1:arg1.nummuestras, :);
        data_p.index(1:arg1.nummuestras) = arg1.inputs(1:arg1.nummuestras);
        
        data_p.outputs(arg1.nummuestras + 1: arg2.nummuestras + arg1.nummuestras , :) = arg2.outputs(1:arg2.nummuestras, :);
        data_p.inputs(arg1.nummuestras + 1: arg2.nummuestras + arg1.nummuestras, :) = arg2.inputs(1:arg2.nummuestras, :);
        data_p.index(arg1.nummuestras + 1: arg2.nummuestras + arg1.nummuestras) = arg2.inputs(1:arg2.nummuestras);
    
        data_p.temp_amb = arg1.temp_amb;
        data_p.maxRpressure = arg1.maxRpressure;
        data_p.nummuestras = arg1.nummuestras + arg2.nummuestras;
      
        data_p.controlporcentual = arg1.controlporcentual;

        

        data = data_p;

        
    
    else
        disp("ERROR: datasets no combinables");
    end

else

    disp("ERROR: revisar los argumentos dados");

end
end