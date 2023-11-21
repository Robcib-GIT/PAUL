%% Callibration essays
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-22

%% Setup
r.Deflate();
r.ResetVoltagesPositions();
voltages = zeros(r.nSensors, 2);
positions = zeros(3 * r.nSensors, 2);
lengths = zeros(r.nSensors, 2);

%% Measures 
for sens = 1:r.nSensors
    for j = 1:9
        r.WriteOneValveMillis(sens-1, 100);
        pause(1);
        
        % Calculates lengths at 400 and 900ms
        if j == 4 || j == 9
            s = round(j/4);
            pos = r.CapturePosition();
            aux = MCI(r.R * pos(4,:)')';
            lengths(sens,s) = aux(sens);
        end

        pause(2);
        r.Measure();
        pause(1);
        
        % Measure voltages at 400 and 900ms
        if j == 4 || j == 9 
            voltages(sens,s) = r.voltages(sens,end);
        end
    end
end

% Data processing
mL = (voltages(:,2) - voltages(:,1)) / (lengths(:,2) - lengths(:,1));

%% Transformation (to check if result is correct)
pos2v([0 0 90], mL, voltages(:,1))

%% Aux Functions
function voltage = pos2v (pos, mL, L0)
    l = MCI(pos)';
    voltage = L0 + mL * (l - L0);
end