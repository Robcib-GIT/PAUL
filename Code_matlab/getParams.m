%% Function to get the most important relations betwweb voltage, length and
% valves' opening time from the data obtained in the measurments.
% 
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-06-13

function params = getParams(nSensor, l, voltages)
    params.nSensor = nSensor;
    params.mV = (voltages(6) - voltages(11)) / 500;
    params.mL = (voltages(6) - voltages(11)) / (l(nSensor+1,6) - l(nSensor+1,11));
    params.mLt = (voltages(1) - voltages(11)) / (l(nSensor+1,1) - l(nSensor+1,11));
end