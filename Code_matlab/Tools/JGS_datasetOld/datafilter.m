function [data_filtered] = datafilter(data, x,y,z,e1,e2,e3)

%x(min,max)

j = 1;
data_filtered.p = 1;

    % Recorremos todos los datos
    for i = 1:data.nummuestras
    
        % Condiciones para saltar al siguiente dato
        if data.outputs(i,1) < x(1) || data.outputs(i, 1) > x(2)
            disp("dato rechazado x");
            continue
            
        end
        
        if data.outputs(i, 2) < y(1) || data.outputs(i, 2) > y(2)
            disp("dato rechazado y");
            continue
        end
    
        if data.outputs(i,3) < z(1) || data.outputs(i, 3) > z(2)
            disp("dato rechazado z");
            continue
        end
    
        % Condiciones para saltar al siguiente dato
        if data.outputs(i,4) < e1(1) || data.outputs(i, 4) > e1(2)
            disp("dato rechazado e1");
            continue
        end
        
        if data.outputs(i, 5) < e2(1) || data.outputs(i, 5) > e2(2)
            disp("dato rechazado e2");
            continue
        end
    
        if data.outputs(i,6) < e3(1) || data.outputs(i, 6) > e3(2)
            disp("dato rechazado e3");
            continue
        end
    
        if data.outputs(i,1) == -1 || data.outputs(i, 2) == -1 || data.outputs(i, 3) == -1 
            continue
        end
    
    
    
    
        % Si llegamos aqui es que el dato se ha aceptado
        data_filtered.inputs(j, 1:9) = data.inputs(i, 1:9);
        data_filtered.outputs(j,1:6) = data.outputs(i, 1:6);
        data_filtered.index(j) = j;
        j = j  + 1;
    end
    
    data_filtered.nummuestras = j - 1;
    

    


end