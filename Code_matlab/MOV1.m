obj = serialport('COM3', 9600);
millisdesinflar = "w,1,-5000,-5000,-5000,-5000,-5000,-5000,-5000,-5000,-5000";
writeline(obj, millisdesinflar);
pause(5);
% Funcionan las válvulas 2,4 y 8 (sumar 1 porque Arduino empieza en 0)

writeOneValveMillis(obj, 1, 1100);
pause(6);
disp('Paso realizado');
millisdesinflar = "w,1,-6000,-6000,-10000,-6000,-6000,-6000,-6000,-6000,-6000";
writeline(obj, millisdesinflar);

writeOneValveMillis(obj, 1, 1500);
pause(3);
writeOneValveMillis(obj, 8, 1600);
pause(6);
disp('Paso realizado');
millisdesinflar = "w,1,-6000,-6000,-6000,-6000,-6000,-6000,-6000,-6000,-6000";
writeline(obj, millisdesinflar);

writeOneValveMillis(obj, 2, 1000);
writeOneValveMillis(obj, 8, 1200);
pause(6);
disp('Paso realizado');
millisdesinflar = "w,1,-5000,0,-5000,-5000,-5000,-5000,-5000,-5000,-5000";
writeline(obj, millisdesinflar);

delete(obj)