%% Unir dos estructuras

% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-01-17
 
function structC = JGS_mergeStructs(structA, structB)
    structC.outputs = [structA.outputs; structB.outputs];
    structC.inputs = [structA.inputs; structB.inputs];
end